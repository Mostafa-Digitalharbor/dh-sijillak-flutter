import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/view_status.dart';
import '../../domain/entities/search_results.dart';
import '../../domain/usecases/clear_recent_searches_use_case.dart';
import '../../domain/usecases/get_recent_searches_use_case.dart';
import '../../domain/usecases/save_recent_search_use_case.dart';
import '../../domain/usecases/search_use_case.dart';
import '../constants/search_constants.dart';

/// What the search screen shows: the typed query, its results and the
/// remembered queries.
class SearchState extends Equatable {
  const SearchState({
    this.query = '',
    this.status = ViewStatus.initial,
    this.results = SearchResults.empty,
    this.failure,
    this.recents = const [],
  });

  final String query;
  final ViewStatus status;
  final SearchResults results;
  final Failure? failure;

  /// Past queries, most recent first.
  final List<String> recents;

  /// Whether the user has typed something to search for.
  bool get hasQuery => query.trim().isNotEmpty;

  SearchState copyWith({
    String? query,
    ViewStatus? status,
    SearchResults? results,
    Failure? failure,
    List<String>? recents,
  }) => SearchState(
    query: query ?? this.query,
    status: status ?? this.status,
    results: results ?? this.results,
    failure: failure,
    recents: recents ?? this.recents,
  );

  @override
  List<Object?> get props => [query, status, results, failure, recents];
}

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(
    this._search,
    this._getRecent,
    this._saveRecent,
    this._clearRecent, {
    this.debounce = SearchConstants.searchDebounce,
  }) : super(const SearchState());

  final SearchUseCase _search;
  final GetRecentSearchesUseCase _getRecent;
  final SaveRecentSearchUseCase _saveRecent;
  final ClearRecentSearchesUseCase _clearRecent;

  /// Pause after the last keystroke before the query is searched.
  final Duration debounce;
  Timer? _timer;
  int _request = 0;

  /// Loads the remembered queries.
  Future<void> load() => _loadRecents();

  /// The text box changed: searches [query] once typing pauses. An empty
  /// query drops the results and shows the recent searches again.
  void queryChanged(String query) {
    _timer?.cancel();
    _request++;
    if (query.trim().isEmpty) {
      emit(
        state.copyWith(
          query: query,
          status: ViewStatus.initial,
          results: SearchResults.empty,
        ),
      );
      return;
    }
    emit(state.copyWith(query: query, status: _pendingStatus));
    _timer = Timer(debounce, _run);
  }

  /// Searches [query] right away (a remembered query, or a retry).
  void searchNow(String query) {
    _timer?.cancel();
    _request++;
    emit(state.copyWith(query: query, status: _pendingStatus));
    unawaited(_run());
  }

  /// Saves the current query to the history; call when a result is opened.
  Future<void> remember() async {
    if (!state.hasQuery) return;
    await _saveRecent(state.query.trim());
    await _loadRecents();
  }

  /// Forgets every remembered query.
  Future<void> clearRecents() async {
    await _clearRecent(const NoParams());
    await _loadRecents();
  }

  /// Rows already on screen stay while a new search is pending.
  ViewStatus get _pendingStatus => state.status == ViewStatus.success
      ? ViewStatus.success
      : ViewStatus.loading;

  Future<void> _run() async {
    final request = _request;
    final result = await _search(state.query);
    if (request != _request || isClosed) return;
    emit(
      result.when(
        success: (results) =>
            state.copyWith(status: ViewStatus.success, results: results),
        error: (failure) =>
            state.copyWith(status: ViewStatus.failure, failure: failure),
      ),
    );
  }

  Future<void> _loadRecents() async {
    final result = await _getRecent(const NoParams());
    if (isClosed) return;
    emit(state.copyWith(recents: result.dataOrNull ?? state.recents));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
