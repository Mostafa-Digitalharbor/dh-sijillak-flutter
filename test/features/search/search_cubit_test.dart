import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/error/failure.dart';
import 'package:sijilak/core/utils/result.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/search/domain/entities/customer_hit.dart';
import 'package:sijilak/features/search/domain/entities/search_results.dart';
import 'package:sijilak/features/search/domain/repositories/recent_searches_repository.dart';
import 'package:sijilak/features/search/domain/repositories/search_repository.dart';
import 'package:sijilak/features/search/domain/usecases/clear_recent_searches_use_case.dart';
import 'package:sijilak/features/search/domain/usecases/get_recent_searches_use_case.dart';
import 'package:sijilak/features/search/domain/usecases/save_recent_search_use_case.dart';
import 'package:sijilak/features/search/domain/usecases/search_use_case.dart';
import 'package:sijilak/features/search/presentation/cubit/search_cubit.dart';

const _hit = CustomerHit(
  id: 'c-1',
  name: 'Acme',
  location: 'Riyadh',
  openDeals: 2,
);

class _FakeSearch implements SearchRepository {
  final queries = <String>[];
  Result<SearchResults> result = const Success(
    SearchResults(customers: [_hit]),
  );

  @override
  Future<Result<SearchResults>> search(String query) async {
    queries.add(query);
    return result;
  }
}

class _FakeRecents implements RecentSearchesRepository {
  final saved = <String>[];
  bool cleared = false;

  @override
  Future<Result<List<String>>> recent() async =>
      Success(saved.reversed.toList());

  @override
  Future<Result<void>> save(String query) async {
    saved.add(query);
    return const Success(null);
  }

  @override
  Future<Result<void>> clear() async {
    cleared = true;
    saved.clear();
    return const Success(null);
  }
}

void main() {
  late _FakeSearch searchRepository;
  late _FakeRecents recents;
  late SearchCubit cubit;

  const debounce = Duration(milliseconds: 20);
  const afterDebounce = Duration(milliseconds: 80);

  setUp(() {
    searchRepository = _FakeSearch();
    recents = _FakeRecents();
    cubit = SearchCubit(
      SearchUseCase(searchRepository),
      GetRecentSearchesUseCase(recents),
      SaveRecentSearchUseCase(recents),
      ClearRecentSearchesUseCase(recents),
      debounce: debounce,
    );
  });

  tearDown(() => cubit.close());

  test('starts idle with no query', () {
    expect(cubit.state.hasQuery, isFalse);
    expect(cubit.state.status, ViewStatus.initial);
    expect(cubit.state.results.isEmpty, isTrue);
  });

  test('load reads the remembered searches', () async {
    recents.saved.addAll(['a', 'b']);
    await cubit.load();

    expect(cubit.state.recents, ['b', 'a']);
  });

  test('typing searches once, after the pause', () async {
    cubit
      ..queryChanged('a')
      ..queryChanged('ac')
      ..queryChanged('acm');
    expect(searchRepository.queries, isEmpty);
    expect(cubit.state.status, ViewStatus.loading);

    await Future<void>.delayed(afterDebounce);

    expect(searchRepository.queries, ['acm']);
    expect(cubit.state.status, ViewStatus.success);
    expect(cubit.state.results.customers, [_hit]);
    expect(cubit.state.query, 'acm');
  });

  test('clearing the text drops the results without searching', () async {
    cubit.queryChanged('acme');
    await Future<void>.delayed(afterDebounce);
    cubit.queryChanged('');

    expect(cubit.state.hasQuery, isFalse);
    expect(cubit.state.status, ViewStatus.initial);
    expect(cubit.state.results.isEmpty, isTrue);
    await Future<void>.delayed(afterDebounce);
    expect(searchRepository.queries, ['acme']);
  });

  test('a late answer of an older query is dropped', () async {
    cubit.queryChanged('acme');
    await Future<void>.delayed(debounce + const Duration(milliseconds: 1));
    cubit.queryChanged('');
    await Future<void>.delayed(afterDebounce);

    expect(cubit.state.status, ViewStatus.initial);
    expect(cubit.state.results.isEmpty, isTrue);
  });

  test('a failed search is reported and can be retried', () async {
    searchRepository.result = const Failed(NetworkFailure());
    cubit.queryChanged('acme');
    await Future<void>.delayed(afterDebounce);

    expect(cubit.state.status, ViewStatus.failure);
    expect(cubit.state.failure, isA<NetworkFailure>());

    searchRepository.result = const Success(SearchResults(customers: [_hit]));
    cubit.searchNow(cubit.state.query);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(cubit.state.status, ViewStatus.success);
    expect(cubit.state.failure, isNull);
  });

  test('searchNow searches immediately and sets the query', () async {
    cubit.searchNow('beta');
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(cubit.state.query, 'beta');
    expect(searchRepository.queries, ['beta']);
    expect(cubit.state.status, ViewStatus.success);
  });

  test('remember saves the trimmed query and refreshes the list', () async {
    cubit.queryChanged('  acme ');
    await cubit.remember();

    expect(recents.saved, ['acme']);
    expect(cubit.state.recents, ['acme']);
  });

  test('remember does nothing without a query', () async {
    await cubit.remember();

    expect(recents.saved, isEmpty);
  });

  test('clearRecents forgets the history', () async {
    recents.saved.add('a');
    await cubit.load();
    await cubit.clearRecents();

    expect(recents.cleared, isTrue);
    expect(cubit.state.recents, isEmpty);
  });
}
