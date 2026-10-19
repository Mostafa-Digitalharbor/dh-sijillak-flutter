import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/core/usecase/usecase.dart';
import 'package:sijilak/core/utils/result.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/pipeline/data/datasources/pipeline_mock_api.dart';
import 'package:sijilak/features/pipeline/data/datasources/pipeline_remote_data_source.dart';
import 'package:sijilak/features/pipeline/data/models/new_deal_model.dart';
import 'package:sijilak/features/pipeline/data/models/pipeline_model.dart';
import 'package:sijilak/features/pipeline/data/repositories/pipeline_repository_impl.dart';
import 'package:sijilak/features/pipeline/domain/entities/deal.dart';
import 'package:sijilak/features/pipeline/domain/entities/deal_stage.dart';
import 'package:sijilak/features/pipeline/domain/entities/lead_defaults.dart';
import 'package:sijilak/features/pipeline/domain/entities/lead_party.dart';
import 'package:sijilak/features/pipeline/domain/entities/new_deal.dart';
import 'package:sijilak/features/pipeline/domain/entities/pipeline.dart';
import 'package:sijilak/features/pipeline/domain/repositories/pipeline_repository.dart';
import 'package:sijilak/features/pipeline/domain/usecases/create_deal_use_case.dart';
import 'package:sijilak/features/pipeline/domain/usecases/get_lead_defaults_use_case.dart';
import 'package:sijilak/features/pipeline/domain/usecases/get_pipeline_use_case.dart';
import 'package:sijilak/features/pipeline/presentation/cubit/new_lead_cubit.dart';
import 'package:sijilak/features/pipeline/presentation/cubit/pipeline_cubit.dart';
import 'package:sijilak/features/pipeline/presentation/extensions/lead_input_parser.dart';
import 'package:sijilak/features/invoices/domain/entities/document_line.dart';
import 'package:sijilak/features/quote/domain/entities/quote_document.dart';
import 'package:sijilak/features/quote/domain/repositories/quote_repository.dart';
import 'package:sijilak/features/quote/domain/usecases/create_quote_for_deal_use_case.dart';

class _FakeQuotes implements QuoteRepository {
  _FakeQuotes({this.failure});

  final Failure? failure;
  final requestedDeals = <String>[];

  @override
  Future<Result<QuoteDocument>> createQuoteForDeal(String dealId) async {
    requestedDeals.add(dealId);
    if (failure != null) return Failed(failure!);
    return const Success(
      QuoteDocument(
        number: 143,
        customer: 'C',
        dealTitle: 'T',
        lines: [DocumentLine(name: 'T', unitPrice: 1)],
      ),
    );
  }

  @override
  Future<Result<QuoteDocument>> getQuote(int number) =>
      throw UnimplementedError();

  @override
  Future<Result<QuoteDocument>> confirmQuote(int number) =>
      throw UnimplementedError();
}

class _FakeRepository implements PipelineRepository {
  _FakeRepository({this.pipeline, this.defaults, this.createFailure});

  final Pipeline? pipeline;
  final LeadDefaults? defaults;
  final Failure? createFailure;
  final created = <NewDeal>[];

  @override
  Future<Result<Pipeline>> getPipeline() async =>
      pipeline == null ? const Failed(NetworkFailure()) : Success(pipeline!);

  @override
  Future<Result<LeadDefaults>> getLeadDefaults() async =>
      defaults == null ? const Failed(NetworkFailure()) : Success(defaults!);

  @override
  Future<Result<Deal>> createDeal(NewDeal deal) async {
    created.add(deal);
    if (createFailure != null) return Failed(createFailure!);
    return Success(
      Deal(
        id: 'd-new',
        title: deal.title,
        stage: deal.stage,
        customerId: deal.customerId,
        customerName: 'C',
        value: deal.value,
        probability: 10,
        ownerId: deal.ownerId,
        ownerName: 'O',
      ),
    );
  }
}

const _defaults = LeadDefaults(
  customer: LeadParty(id: 'c-modern-foods', name: 'Modern Foods'),
  owner: LeadParty(id: 'u-1', name: 'Mohammed'),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // A Sunday.
  final now = DateTime(2026, 10, 18, 15);
  late PipelineRepositoryImpl repository;

  setUp(() {
    final client = MockApiClient(
      modules: [PipelineMockApi(MockAssets(), clock: () => now)],
    );
    repository = PipelineRepositoryImpl(PipelineRemoteDataSourceImpl(client));
  });

  group('GetPipelineUseCase', () {
    test('groups deals by stage with counts and totals', () async {
      final pipeline = (await GetPipelineUseCase(repository)(const NoParams()))
          .dataOrNull!;

      expect(
        [for (final s in DealStage.values) pipeline.summaryOf(s).count],
        [6, 5, 4, 3, 9],
      );
      expect(pipeline.summaryOf(DealStage.quote).totalValue, 120500);
      expect(pipeline.dealsIn(DealStage.quote), hasLength(3));
      expect(pipeline.openDeals, 18);
      expect(pipeline.expectedValue, 210000);
    });

    test('dates are resolved against the current day', () async {
      final pipeline = (await repository.getPipeline()).dataOrNull!;
      Deal deal(String id) => pipeline.deals.firstWhere((d) => d.id == id);

      expect(deal('d-1').nextAction!.at, DateTime(2026, 10, 19));
      expect(deal('d-1').nextAction!.hasTime, isFalse);
      expect(deal('d-2').nextAction!.at, isNull);
      expect(deal('d-3').nextAction!.at, DateTime(2026, 10, 18, 13));
      expect(deal('d-3').nextAction!.hasTime, isTrue);
      expect(deal('d-5').quoteExpiresAt, DateTime(2026, 10, 21));
      expect(deal('d-6').nextAction!.at!.weekday, DateTime.sunday);
      expect(deal('d-6').nextAction!.at!.isAfter(now), isTrue);
    });

    test('a data source error becomes a failure', () async {
      final result = await GetPipelineUseCase(_FakeRepository())(
        const NoParams(),
      );

      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });

  group('GetLeadDefaultsUseCase', () {
    test('returns the customer and owner the form starts with', () async {
      final defaults = (await GetLeadDefaultsUseCase(repository)(
        const NoParams(),
      )).dataOrNull!;

      expect(defaults.customer.id, 'c-modern-foods');
      expect(defaults.owner.id, 'u-1');
    });
  });

  group('CreateDealUseCase', () {
    const draft = NewDeal(
      title: 'Warehouse fit-out',
      customerId: 'c-modern-foods',
      ownerId: 'u-1',
      value: 50000,
      stage: DealStage.qualified,
      notes: 'Urgent',
    );

    test('the created deal shows up in the pipeline afterwards', () async {
      final created = (await CreateDealUseCase(repository)(draft)).dataOrNull!;
      final pipeline = (await repository.getPipeline()).dataOrNull!;

      expect(created.stage, DealStage.qualified);
      expect(created.customerName, isNotEmpty);
      expect(created.ownerName, isNotEmpty);
      expect(created.probability, greaterThan(0));
      expect(pipeline.deals.first.id, created.id);
      expect(pipeline.dealsIn(DealStage.qualified), contains(created));
      expect(pipeline.summaryOf(DealStage.qualified).count, 6);
      expect(pipeline.summaryOf(DealStage.qualified).totalValue, 92000);
      expect(pipeline.openDeals, 19);
      expect(pipeline.expectedValue, 260000);
    });

    test('rejects an empty title and a non-positive value', () async {
      const invalid = NewDeal(
        title: '  ',
        customerId: 'c-modern-foods',
        ownerId: 'u-1',
        value: 0,
        stage: DealStage.newLead,
      );

      final failure = (await CreateDealUseCase(repository)(invalid))
          .failureOrNull;

      expect(failure, isA<ValidationFailure>());
      expect(
        (failure! as ValidationFailure).fields.keys,
        containsAll(['title', 'value']),
      );
      expect((await repository.getPipeline()).dataOrNull!.openDeals, 18);
    });

    test('rejects an unknown customer', () async {
      const unknown = NewDeal(
        title: 'X',
        customerId: 'nobody',
        ownerId: 'u-1',
        value: 1,
        stage: DealStage.newLead,
      );

      final failure = (await CreateDealUseCase(repository)(unknown))
          .failureOrNull;

      expect(
        (failure! as ValidationFailure).fields.keys,
        contains('customerId'),
      );
    });
  });

  group('models', () {
    test('pipeline survives a toJson/fromJson round trip', () async {
      final data = {
        'stages': [
          {'stage': 'quote', 'count': 2, 'totalValue': 30},
        ],
        'deals': [
          {
            'id': 'd',
            'title': 'T',
            'stage': 'quote',
            'customerId': 'c',
            'customerName': 'C',
            'value': 30,
            'probability': 50,
            'ownerId': 'u',
            'ownerName': 'U',
            'nextAction': {
              'title': 'Call',
              'at': '2026-10-19T09:00:00.000',
              'hasTime': true,
            },
            'quoteExpiresAt': '2026-10-21T00:00:00.000',
            'expectedClose': '2026-11-30T00:00:00.000',
            'notes': 'n',
          },
        ],
      };

      final model = PipelineModel.fromJson(data);

      expect(
        PipelineModel.fromJson(model.toJson()).toEntity(),
        model.toEntity(),
      );
      expect(model.toEntity().deals.single.nextAction!.hasTime, isTrue);
      expect(model.toJson()['deals'], data['deals']);
    });

    test('new deal body round-trips through the entity', () {
      final deal = NewDeal(
        title: 'T',
        customerId: 'c',
        ownerId: 'u',
        value: 5,
        stage: DealStage.quote,
        expectedClose: DateTime(2026, 11, 30),
        notes: 'n',
      );

      final json = NewDealModel.fromEntity(deal).toJson();

      expect(NewDealModel.fromJson(json).toEntity(), deal);
    });
  });

  group('LeadInputParser', () {
    final today = DateTime(2026, 10, 18);
    const months = {'november': 11, 'نوفمبر': 11};

    test('reads amounts in any digit script', () {
      expect(LeadInputParser.amount('65,000'), 65000);
      expect(LeadInputParser.amount('٦٥٬٠٠٠'), 65000);
      expect(LeadInputParser.amount('abc'), isNull);
      expect(LeadInputParser.amount(''), isNull);
    });

    test('reads numeric and named dates', () {
      DateTime? parse(String text) =>
          LeadInputParser.date(text, now: today, monthNames: months);

      expect(parse('30/11'), DateTime(2026, 11, 30));
      expect(parse('٣٠ نوفمبر'), DateTime(2026, 11, 30));
      expect(parse('30 November'), DateTime(2026, 11, 30));
      expect(parse('2027-01-05'), DateTime(2027, 1, 5));
      expect(parse('5/1/2027'), DateTime(2027, 1, 5));
      expect(parse('1/10'), DateTime(2027, 10, 1));
      expect(parse('31/2'), isNull);
      expect(parse('soon'), isNull);
      expect(parse(''), isNull);
    });
  });

  group('PipelineCubit', () {
    test('loads and selects a stage', () async {
      final pipeline = (await repository.getPipeline()).dataOrNull!;
      final cubit = PipelineCubit(
        GetPipelineUseCase(_FakeRepository(pipeline: pipeline)),
      );
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.status, ViewStatus.success);
      expect(cubit.state.deals, hasLength(3));
      expect(cubit.state.total, 120500);
      cubit.selectStage(DealStage.won);
      expect(cubit.state.deals.single.id, 'd-8');
      expect(cubit.state.total, 38000);
    });

    test('exposes a failure', () async {
      final cubit = PipelineCubit(GetPipelineUseCase(_FakeRepository()));
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state.status, ViewStatus.failure);
      expect(cubit.state.failure, const NetworkFailure());
    });

    test('a silent reload never shows the loading state', () async {
      final pipeline = (await repository.getPipeline()).dataOrNull!;
      final cubit = PipelineCubit(
        GetPipelineUseCase(_FakeRepository(pipeline: pipeline)),
      );
      addTearDown(cubit.close);
      await cubit.load();
      final statuses = <ViewStatus>[];
      final sub = cubit.stream.listen((s) => statuses.add(s.status));

      await cubit.load(silent: true);
      await sub.cancel();

      expect(statuses, isNot(contains(ViewStatus.loading)));
    });
  });

  group('NewLeadCubit', () {
    NewLeadCubit build(_FakeRepository repository, [_FakeQuotes? quotes]) {
      final cubit = NewLeadCubit(
        GetLeadDefaultsUseCase(repository),
        CreateDealUseCase(repository),
        CreateQuoteForDealUseCase(quotes ?? _FakeQuotes()),
      );
      addTearDown(cubit.close);
      return cubit;
    }

    test('loads the defaults', () async {
      final cubit = build(_FakeRepository(defaults: _defaults));

      await cubit.load();

      expect(cubit.state.status, ViewStatus.success);
      expect(cubit.state.defaults, _defaults);
      expect(cubit.state.canSubmit, isTrue);
    });

    test('cannot submit before the defaults are loaded', () async {
      final repository = _FakeRepository();
      final cubit = build(repository);

      await cubit.submit(expectedClose: null, createQuote: false);

      expect(repository.created, isEmpty);
      expect(cubit.state.canSubmit, isFalse);
    });

    test('submits what the controllers hold', () async {
      final repository = _FakeRepository(defaults: _defaults);
      final cubit = build(repository);
      await cubit.load();
      cubit
        ..titleController.text = '  Filling line '
        ..valueController.text = '٦٥٬٠٠٠'
        ..notesController.text = ' '
        ..selectStage(DealStage.negotiation);

      await cubit.submit(
        expectedClose: DateTime(2026, 11, 30),
        createQuote: true,
      );

      expect(
        repository.created.single,
        NewDeal(
          title: 'Filling line',
          customerId: 'c-modern-foods',
          ownerId: 'u-1',
          value: 65000,
          stage: DealStage.negotiation,
          expectedClose: DateTime(2026, 11, 30),
        ),
      );
      expect(cubit.state.submitStatus, ViewStatus.success);
      expect(cubit.state.createQuote, isTrue);
    });

    test('save and create quote asks for the quote of the new deal', () async {
      final quotes = _FakeQuotes();
      final cubit = build(_FakeRepository(defaults: _defaults), quotes);
      await cubit.load();

      await cubit.submit(expectedClose: null, createQuote: true);

      expect(quotes.requestedDeals, ['d-new']);
      expect(cubit.state.submitStatus, ViewStatus.success);
      expect(cubit.state.quoteNumber, 143);
    });

    test('a plain save never creates a quote', () async {
      final quotes = _FakeQuotes();
      final cubit = build(_FakeRepository(defaults: _defaults), quotes);
      await cubit.load();

      await cubit.submit(expectedClose: null, createQuote: false);

      expect(quotes.requestedDeals, isEmpty);
      expect(cubit.state.quoteNumber, isNull);
    });

    test('a failed deal save does not create a quote', () async {
      final quotes = _FakeQuotes();
      final cubit = build(
        _FakeRepository(
          defaults: _defaults,
          createFailure: const ValidationFailure(),
        ),
        quotes,
      );
      await cubit.load();

      await cubit.submit(expectedClose: null, createQuote: true);

      expect(quotes.requestedDeals, isEmpty);
      expect(cubit.state.submitStatus, ViewStatus.failure);
    });

    test('a failed quote creation is reported and can be retried', () async {
      final cubit = build(
        _FakeRepository(defaults: _defaults),
        _FakeQuotes(failure: const NetworkFailure()),
      );
      await cubit.load();

      await cubit.submit(expectedClose: null, createQuote: true);

      expect(cubit.state.submitStatus, ViewStatus.failure);
      expect(cubit.state.submitFailure, const NetworkFailure());
      expect(cubit.state.quoteNumber, isNull);
      expect(cubit.state.canSubmit, isTrue);
    });

    test('reports a failed save and allows another try', () async {
      final repository = _FakeRepository(
        defaults: _defaults,
        createFailure: const ValidationFailure(),
      );
      final cubit = build(repository);
      await cubit.load();

      await cubit.submit(expectedClose: null, createQuote: false);

      expect(cubit.state.submitStatus, ViewStatus.failure);
      expect(cubit.state.submitFailure, const ValidationFailure());
      expect(cubit.state.canSubmit, isTrue);
    });

    test('end to end with the mock backend', () async {
      final cubit = NewLeadCubit(
        GetLeadDefaultsUseCase(repository),
        CreateDealUseCase(repository),
        CreateQuoteForDealUseCase(_FakeQuotes()),
      );
      addTearDown(cubit.close);
      await cubit.load();
      cubit
        ..titleController.text = 'Hosting contract'
        ..valueController.text = '12000';

      await cubit.submit(expectedClose: null, createQuote: false);
      final pipeline = (await repository.getPipeline()).dataOrNull!;

      expect(cubit.state.submitStatus, ViewStatus.success);
      expect(pipeline.deals.first.title, 'Hosting contract');
      expect(pipeline.deals.first.stage, DealStage.qualified);
    });
  });
}
