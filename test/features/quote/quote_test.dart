import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/core/utils/result.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/invoices/domain/entities/document_line.dart';
import 'package:sijilak/features/quote/data/datasources/quote_mock_api.dart';
import 'package:sijilak/features/quote/data/datasources/quote_remote_data_source.dart';
import 'package:sijilak/features/quote/data/models/quote_model.dart';
import 'package:sijilak/features/quote/data/repositories/quote_repository_impl.dart';
import 'package:sijilak/features/quote/domain/entities/quote_document.dart';
import 'package:sijilak/features/quote/domain/repositories/quote_repository.dart';
import 'package:sijilak/features/quote/domain/usecases/confirm_quote_use_case.dart';
import 'package:sijilak/features/quote/domain/usecases/get_quote_use_case.dart';
import 'package:sijilak/features/quote/presentation/cubit/quote_cubit.dart';

class _FakeQuoteRepository implements QuoteRepository {
  _FakeQuoteRepository({this.failure});

  final Failure? failure;

  static const _quote = QuoteDocument(
    number: 5,
    customer: 'c',
    dealTitle: 'd',
    lines: [DocumentLine(name: 'x', unitPrice: 100)],
  );

  @override
  Future<Result<QuoteDocument>> getQuote(int number) async =>
      failure == null ? const Success(_quote) : Failed(failure!);

  @override
  Future<Result<QuoteDocument>> createQuoteForDeal(String dealId) async =>
      failure == null ? const Success(_quote) : Failed(failure!);

  @override
  Future<Result<QuoteDocument>> confirmQuote(int number) async =>
      failure == null
      ? const Success(
          QuoteDocument(
            number: 5,
            customer: 'c',
            dealTitle: 'd',
            lines: [DocumentLine(name: 'x', unitPrice: 100)],
            status: QuoteStatus.approved,
          ),
        )
      : Failed(failure!);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuoteModel', () {
    test('maps JSON to the entity and ignores totals', () {
      final quote = QuoteModel.fromJson({
        'number': 9,
        'customer': 'c',
        'dealTitle': 'd',
        'status': 'approved',
        'viewedAt': '2026-10-17T09:15:00',
        'validUntil': '2026-10-31',
        'lines': [
          {'name': 'a', 'unitPrice': 100, 'quantity': 2},
        ],
      });
      expect(quote.isApproved, isTrue);
      expect(quote.viewedAt, DateTime(2026, 10, 17, 9, 15));
      expect(quote.validUntil, DateTime(2026, 10, 31));
      expect(quote.totals.subtotal, 200);
    });
  });

  group('use cases over the mock backend', () {
    final now = DateTime(2026, 10, 18, 14);
    late GetQuoteUseCase getQuote;
    late ConfirmQuoteUseCase confirmQuote;

    setUp(() {
      final client = MockApiClient(
        modules: [QuoteMockApi(MockAssets(), clock: () => now)],
      );
      final repository = QuoteRepositoryImpl(QuoteRemoteDataSourceImpl(client));
      getQuote = GetQuoteUseCase(repository);
      confirmQuote = ConfirmQuoteUseCase(repository);
    });

    test('serves the fixture quote, viewed today', () async {
      final quote = (await getQuote(142)).dataOrNull!;
      expect(quote.customer, isNotEmpty);
      expect(quote.status, QuoteStatus.sent);
      expect(quote.lines.map((l) => l.unitPrice), [58000, 7000]);
      expect(quote.totals.subtotal, 65000);
      expect(quote.viewedAt, DateTime(2026, 10, 18, 9, 15));
      expect(quote.validUntil, DateTime(2026, 10, 31));
    });

    test('confirming approves the quote for later reads', () async {
      final confirmed = (await confirmQuote(142)).dataOrNull!;
      expect(confirmed.isApproved, isTrue);
      expect((await getQuote(142)).dataOrNull!.isApproved, isTrue);
    });

    test('unknown quotes are not found', () async {
      expect((await getQuote(1)).failureOrNull, isA<NotFoundFailure>());
      expect((await confirmQuote(1)).failureOrNull, isA<NotFoundFailure>());
    });
  });

  group('QuoteCubit', () {
    QuoteCubit build(_FakeQuoteRepository repo) =>
        QuoteCubit(GetQuoteUseCase(repo), ConfirmQuoteUseCase(repo));

    test('loads then confirms the quote', () async {
      final cubit = build(_FakeQuoteRepository());
      addTearDown(cubit.close);
      await cubit.load(5);
      expect(cubit.state.status, ViewStatus.success);
      expect(cubit.state.quote?.isApproved, isFalse);

      await cubit.confirm();
      expect(cubit.state.confirmStatus, ViewStatus.success);
      expect(cubit.state.quote?.isApproved, isTrue);
    });

    test('reports load and confirm failures', () async {
      const failure = NetworkFailure();
      final bad = build(_FakeQuoteRepository(failure: failure));
      addTearDown(bad.close);
      await bad.load(5);
      expect(bad.state.status, ViewStatus.failure);
      expect(bad.state.failure, failure);

      final good = build(_FakeQuoteRepository());
      addTearDown(good.close);
      await good.load(5);
      final failing = QuoteCubit(
        GetQuoteUseCase(_FakeQuoteRepository()),
        ConfirmQuoteUseCase(_FakeQuoteRepository(failure: failure)),
      );
      addTearDown(failing.close);
      await failing.load(5);
      await failing.confirm();
      expect(failing.state.confirmStatus, ViewStatus.failure);
      expect(failing.state.confirmFailure, failure);
      expect(failing.state.quote?.isApproved, isFalse);
    });
  });
}
