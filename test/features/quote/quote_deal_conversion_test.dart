import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/core/usecase/usecase.dart';
import 'package:sijilak/features/invoices/data/datasources/invoices_mock_api.dart';
import 'package:sijilak/features/invoices/data/datasources/invoices_remote_data_source.dart';
import 'package:sijilak/features/invoices/data/repositories/invoices_repository_impl.dart';
import 'package:sijilak/features/invoices/domain/usecases/get_invoice_draft_use_case.dart';
import 'package:sijilak/features/pipeline/data/datasources/pipeline_mock_api.dart';
import 'package:sijilak/features/pipeline/data/models/new_deal_model.dart';
import 'package:sijilak/features/pipeline/domain/entities/new_deal.dart';
import 'package:sijilak/features/pipeline/data/datasources/pipeline_remote_data_source.dart';
import 'package:sijilak/features/pipeline/data/repositories/pipeline_repository_impl.dart';
import 'package:sijilak/features/pipeline/domain/entities/deal_stage.dart';
import 'package:sijilak/features/pipeline/domain/usecases/get_pipeline_use_case.dart';
import 'package:sijilak/core/network/api_client.dart';
import 'package:sijilak/features/invoices/domain/entities/document_line.dart';
import 'package:sijilak/features/quote/data/datasources/quote_mock_api.dart';
import 'package:sijilak/features/quote/domain/entities/quote_document.dart';
import 'package:sijilak/features/quote/data/datasources/quote_remote_data_source.dart';
import 'package:sijilak/features/quote/data/repositories/quote_repository_impl.dart';
import 'package:sijilak/features/quote/domain/usecases/confirm_quote_use_case.dart';
import 'package:sijilak/features/quote/domain/usecases/create_quote_for_deal_use_case.dart';
import 'package:sijilak/features/quote/domain/usecases/get_quote_use_case.dart';

/// Approving a quote closes its deal in the pipeline, and the approved quote
/// converts to an invoice draft; all three mock modules share one backend.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final now = DateTime(2026, 10, 18, 14);
  late GetPipelineUseCase getPipeline;
  late GetQuoteUseCase getQuote;
  late ConfirmQuoteUseCase confirmQuote;
  late CreateQuoteForDealUseCase createQuote;
  late MockApiClient client;
  late GetInvoiceDraftUseCase getDraft;

  setUp(() {
    final assets = MockAssets();
    client = MockApiClient(
      modules: [
        PipelineMockApi(assets, clock: () => now),
        QuoteMockApi(assets, clock: () => now),
        InvoicesMockApi(assets, clock: () => now),
      ],
    );
    getPipeline = GetPipelineUseCase(
      PipelineRepositoryImpl(PipelineRemoteDataSourceImpl(client)),
    );
    final quotes = QuoteRepositoryImpl(QuoteRemoteDataSourceImpl(client));
    getQuote = GetQuoteUseCase(quotes);
    confirmQuote = ConfirmQuoteUseCase(quotes);
    createQuote = CreateQuoteForDealUseCase(quotes);
    getDraft = GetInvoiceDraftUseCase(
      InvoicesRepositoryImpl(InvoicesRemoteDataSourceImpl(client)),
    );
  });

  test('the fixture quote is linked to a deal in the quote stage', () async {
    final quote = (await getQuote(142)).dataOrNull!;
    final pipeline = (await getPipeline(const NoParams())).dataOrNull!;
    expect(quote.dealId, 'd-4');
    expect(
      pipeline.dealsIn(DealStage.quote).map((d) => d.id),
      contains(quote.dealId),
    );
  });

  test(
    'approving the quote moves its deal to won and updates totals',
    () async {
      final before = (await getPipeline(const NoParams())).dataOrNull!;
      final quoteBefore = before.summaryOf(DealStage.quote);
      final wonBefore = before.summaryOf(DealStage.won);

      final confirmed = (await confirmQuote(142)).dataOrNull!;
      expect(confirmed.isApproved, isTrue);
      expect(confirmed.dealId, 'd-4');

      final after = (await getPipeline(const NoParams())).dataOrNull!;
      final deal = after.deals.firstWhere((d) => d.id == 'd-4');
      expect(deal.stage, DealStage.won);
      expect(deal.probability, 100);
      expect(after.summaryOf(DealStage.quote).count, quoteBefore.count - 1);
      expect(
        after.summaryOf(DealStage.quote).totalValue,
        quoteBefore.totalValue - deal.value,
      );
      expect(after.summaryOf(DealStage.won).count, wonBefore.count + 1);
      expect(
        after.summaryOf(DealStage.won).totalValue,
        wonBefore.totalValue + deal.value,
      );
      expect(
        after.dealsIn(DealStage.quote).map((d) => d.id),
        isNot(contains('d-4')),
      );
    },
  );

  test('approving twice moves the deal only once', () async {
    await confirmQuote(142);
    final once = (await getPipeline(const NoParams())).dataOrNull!;
    await confirmQuote(142);
    final twice = (await getPipeline(const NoParams())).dataOrNull!;
    expect(twice.summaryOf(DealStage.won), once.summaryOf(DealStage.won));
  });

  test('approval works even before the pipeline was ever read', () async {
    final confirmed = await confirmQuote(142);
    expect(confirmed.dataOrNull!.isApproved, isTrue);
    final pipeline = (await getPipeline(const NoParams())).dataOrNull!;
    expect(
      pipeline.deals.firstWhere((d) => d.id == 'd-4').stage,
      DealStage.won,
    );
  });

  test(
    'the invoice draft built from a quote carries its customer and lines',
    () async {
      final quote = (await getQuote(142)).dataOrNull!;
      final draft = (await getDraft(
        const GetInvoiceDraftParams(quoteNumber: 142),
      )).dataOrNull!;
      expect(draft.customer, quote.customer);
      expect(draft.lines, quote.lines);
      expect(draft.totals.subtotal, quote.totals.subtotal);
      expect(draft.issueDate, DateTime(2026, 10, 18));
      expect(draft.paymentTermsDays, 15);
    },
  );

  test('a draft from an unknown quote is not found', () async {
    final result = await getDraft(const GetInvoiceDraftParams(quoteNumber: 1));
    expect(result.failureOrNull, isA<NotFoundFailure>());
  });

  group('creating a quote for a deal', () {
    Future<String> newDeal({
      String title = 'عقد استضافة',
      int value = 12000,
    }) async {
      final defaults = (await client.get('/deals/lead-defaults')).asJson;
      final body = NewDealModel.fromEntity(
        NewDeal(
          title: title,
          customerId: (defaults['customer']! as Map)['id'] as String,
          ownerId: (defaults['owner']! as Map)['id'] as String,
          value: value,
          stage: DealStage.qualified,
        ),
      ).toJson();
      return (await client.post('/deals', body: body)).asJson['id'] as String;
    }

    test('builds a sent quote from the deal with the next number', () async {
      final dealId = await newDeal();

      final quote = (await createQuote(dealId)).dataOrNull!;

      expect(quote.number, 143);
      expect(quote.dealId, dealId);
      expect(quote.dealTitle, 'عقد استضافة');
      expect(quote.customer, isNotEmpty);
      expect(quote.status, QuoteStatus.sent);
      expect(quote.lines, [
        const DocumentLine(name: 'عقد استضافة', unitPrice: 12000),
      ]);
      expect(quote.totals.subtotal, 12000);
      expect(quote.viewedAt, now);
      expect(quote.validUntil, DateTime(2026, 11, 17));
      expect((await getQuote(143)).dataOrNull, quote);
    });

    test('is idempotent per deal and numbers keep increasing', () async {
      final first = await newDeal();
      final second = await newDeal(title: 'خدمة أخرى');

      final a = (await createQuote(first)).dataOrNull!;
      final again = (await createQuote(first)).dataOrNull!;
      final b = (await createQuote(second)).dataOrNull!;

      expect(again, a);
      expect(b.number, a.number + 1);
    });

    test('returns the existing quote of a seeded deal', () async {
      expect((await createQuote('d-4')).dataOrNull!.number, 142);
    });

    test('an unknown deal is not found', () async {
      final result = await createQuote('d-missing');
      expect(result.failureOrNull, isA<NotFoundFailure>());
    });

    test('approving the new quote wins the new deal', () async {
      final dealId = await newDeal();
      final quote = (await createQuote(dealId)).dataOrNull!;

      await confirmQuote(quote.number);

      final pipeline = (await getPipeline(const NoParams())).dataOrNull!;
      expect(
        pipeline.deals.firstWhere((d) => d.id == dealId).stage,
        DealStage.won,
      );
    });

    test('the invoice draft can start from the new quote', () async {
      final quote = (await createQuote(await newDeal())).dataOrNull!;

      final draft = (await getDraft(
        GetInvoiceDraftParams(quoteNumber: quote.number),
      )).dataOrNull!;

      expect(draft.lines, quote.lines);
      expect(draft.customer, quote.customer);
    });
  });
}
