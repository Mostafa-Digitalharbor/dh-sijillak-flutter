import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sijilak/core/error/exceptions.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/network/mock/mock_api_client.dart';
import 'package:sijilak/core/network/mock/mock_assets.dart';
import 'package:sijilak/core/usecase/usecase.dart';
import 'package:sijilak/features/customer/data/datasources/customer_mock_api.dart';
import 'package:sijilak/features/invoices/domain/entities/invoice_summary.dart';
import 'package:sijilak/features/invoices/data/datasources/invoices_mock_api.dart';
import 'package:sijilak/features/pipeline/data/datasources/pipeline_mock_api.dart';
import 'package:sijilak/features/pipeline/domain/entities/deal_stage.dart';
import 'package:sijilak/features/quote/data/datasources/quote_mock_api.dart';
import 'package:sijilak/features/quote/domain/entities/quote_document.dart';
import 'package:sijilak/features/search/data/datasources/search_endpoints.dart';
import 'package:sijilak/features/search/data/datasources/search_mock_api.dart';
import 'package:sijilak/features/search/data/datasources/search_remote_data_source.dart';
import 'package:sijilak/features/search/data/datasources/search_text.dart';
import 'package:sijilak/features/search/data/models/search_results_model.dart';
import 'package:sijilak/features/search/data/repositories/preferences_recent_searches_repository.dart';
import 'package:sijilak/features/search/data/repositories/search_preferences_keys.dart';
import 'package:sijilak/features/search/data/repositories/search_repository_impl.dart';
import 'package:sijilak/features/search/domain/entities/search_results.dart';
import 'package:sijilak/features/search/domain/search_rules.dart';
import 'package:sijilak/features/search/domain/usecases/clear_recent_searches_use_case.dart';
import 'package:sijilak/features/search/domain/usecases/get_recent_searches_use_case.dart';
import 'package:sijilak/features/search/domain/usecases/save_recent_search_use_case.dart';
import 'package:sijilak/features/search/domain/usecases/search_use_case.dart';

const _modernFoods = 'مصنع الأغذية الحديثة';

class _FailingRemote implements SearchRemoteDataSource {
  @override
  Future<SearchResults> search(String query) async =>
      throw const NetworkException();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockApiClient client;
  late SearchUseCase search;

  setUp(() {
    final assets = MockAssets();
    client = MockApiClient(
      modules: [
        PipelineMockApi(assets),
        CustomerMockApi(assets),
        QuoteMockApi(assets),
        InvoicesMockApi(assets),
        SearchMockApi(assets),
      ],
    );
    search = SearchUseCase(
      SearchRepositoryImpl(SearchRemoteDataSourceImpl(client)),
    );
  });

  Future<SearchResults> run(String query) async =>
      (await search(query)).dataOrNull!;

  group('SearchText', () {
    test('lower-cases and trims', () {
      expect(SearchText.normalize('  Modern FOODS '), 'modern foods');
    });

    test('writes Arabic-Indic and Persian digits as Latin ones', () {
      expect(SearchText.normalize('٠١٢٣٤٥٦٧٨٩'), '0123456789');
      expect(SearchText.normalize('۰۱۲۳۴۵۶۷۸۹'), '0123456789');
      expect(SearchText.normalize('رقم ٣٩٢'), 'رقم 392');
    });

    test('matchesAny looks through every field', () {
      expect(SearchText.matchesAny('39', [1, 'x ٣٩٢']), isTrue);
      expect(SearchText.matchesAny('zz', [1, 'x']), isFalse);
    });
  });

  group('GET /search', () {
    test('an empty or blank query returns nothing', () async {
      expect((await run('')).isEmpty, isTrue);
      expect((await run('   ')).isEmpty, isTrue);
    });

    test('groups hits by kind with the fields a row needs', () async {
      final results = await run('الأغذية');

      expect(results.customers.single.id, 'c-modern-foods');
      expect(results.customers.single.name, _modernFoods);
      expect(results.customers.single.location, isNotEmpty);
      expect(results.deals.map((d) => d.id), containsAll(['d-4', 'd-8']));
      expect(results.deals.first.customerId, 'c-modern-foods');
      expect(results.deals.first.stage, isA<DealStage>());
      expect(results.invoices.map((i) => i.number), contains(392));
      expect(results.invoices.first.status, isA<InvoiceStatus>());
      expect(results.quotes.single.number, 142);
      expect(results.quotes.single.status, QuoteStatus.sent);
    });

    test('matches deal titles, not only customer names', () async {
      final results = await run('خط تعبئة');

      expect(results.deals.map((d) => d.id), ['d-4']);
      expect(results.customers, isEmpty);
    });

    test('Arabic and Latin digits are equal', () async {
      final latin = await run('392');
      final arabic = await run('٣٩٢');

      expect(latin.invoices.map((i) => i.number), [392]);
      expect(arabic, latin);
      expect((await run('١٤٢')).quotes.map((q) => q.number), [142]);
      expect((await run('142')).quotes.map((q) => q.number), [142]);
      // Deal titles are stored with Arabic digits ("١٢ شهراً").
      expect((await run('12 شهراً')).deals.map((d) => d.id), ['d-5']);
    });

    test(
      'a partial invoice number matches every invoice containing it',
      () async {
        expect(
          (await run('39')).invoices.map((i) => i.number),
          containsAll([392, 391]),
        );
      },
    );

    test('matching ignores case', () async {
      final created = await client.post(
        '/customers',
        body: {'name': 'Modern Tools Co'},
      );
      expect(created, isNotNull);

      final results = await run('mOdErN tOOLS');
      expect(results.customers.map((c) => c.name), ['Modern Tools Co']);
    });

    test('limits every group', () async {
      // "ال" is in every Arabic customer name and invoice customer.
      final results = await run('ال');

      expect(results.customers, hasLength(SearchMockApi.groupLimit));
      expect(results.invoices, hasLength(SearchMockApi.groupLimit));
    });

    test('finds customers created through the customers API', () async {
      expect((await run('Zeta')).customers, isEmpty);
      await client.post('/customers', body: {'name': 'Zeta Trading'});

      expect((await run('zeta')).customers.single.name, 'Zeta Trading');
    });

    test('an unmatched query returns empty groups', () async {
      final results = await run('zzzzzz');

      expect(results.isEmpty, isTrue);
      expect(results.total, 0);
    });

    test('the raw endpoint answers with the four groups', () async {
      final payload =
          (await client.get(
                SearchEndpoints.search,
                query: {SearchEndpoints.queryParam: '392'},
              ))!
              as Map<String, dynamic>;

      expect(payload.keys, [
        SearchEndpoints.customersKey,
        SearchEndpoints.dealsKey,
        SearchEndpoints.invoicesKey,
        SearchEndpoints.quotesKey,
      ]);
      expect(SearchResultsModel.fromJson(payload).invoices, isNotEmpty);
    });
  });

  group('SearchRepositoryImpl', () {
    test('turns a transport error into a failure', () async {
      final result = await SearchUseCase(
        SearchRepositoryImpl(_FailingRemote()),
      )('x');

      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });

  group('recent searches', () {
    late SharedPreferences preferences;
    late PreferencesRecentSearchesRepository repository;
    late GetRecentSearchesUseCase get;
    late SaveRecentSearchUseCase save;
    late ClearRecentSearchesUseCase clear;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await SharedPreferences.getInstance();
      repository = PreferencesRecentSearchesRepository(preferences);
      get = GetRecentSearchesUseCase(repository);
      save = SaveRecentSearchUseCase(repository);
      clear = ClearRecentSearchesUseCase(repository);
    });

    Future<List<String>> recent() async =>
        (await get(const NoParams())).dataOrNull!;

    test('starts empty', () async {
      expect(await recent(), isEmpty);
    });

    test('keeps the most recent first', () async {
      await save('a');
      await save('b');
      await save('c');

      expect(await recent(), ['c', 'b', 'a']);
    });

    test(
      'moves a repeated query to the front without duplicating it',
      () async {
        await save('Alpha');
        await save('beta');
        await save('  alpha ');

        expect(await recent(), ['alpha', 'beta']);
      },
    );

    test('treats Arabic and Latin digits as the same query', () async {
      await save('فاتورة ٣٩٢');
      await save('فاتورة 392');

      expect(await recent(), ['فاتورة 392']);
    });

    test('ignores blank queries', () async {
      await save('   ');
      await save('');

      expect(await recent(), isEmpty);
    });

    test('keeps at most ${SearchRules.maxRecentSearches}', () async {
      for (var i = 1; i <= SearchRules.maxRecentSearches + 3; i++) {
        await save('q$i');
      }

      final stored = await recent();
      expect(stored, hasLength(SearchRules.maxRecentSearches));
      expect(stored.first, 'q${SearchRules.maxRecentSearches + 3}');
      expect(stored, isNot(contains('q1')));
    });

    test('persists in the device preferences and survives a restart', () async {
      await save('persisted');

      expect(preferences.getStringList(SearchPreferencesKeys.recent), [
        'persisted',
      ]);
      final reopened = PreferencesRecentSearchesRepository(
        await SharedPreferences.getInstance(),
      );
      expect((await reopened.recent()).dataOrNull, ['persisted']);
    });

    test('clear forgets everything', () async {
      await save('a');
      await save('b');
      await clear(const NoParams());

      expect(await recent(), isEmpty);
      expect(preferences.containsKey(SearchPreferencesKeys.recent), isFalse);
    });
  });
}
