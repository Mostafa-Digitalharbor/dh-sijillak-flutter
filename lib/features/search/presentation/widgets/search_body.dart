import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/status_body.dart';
import '../cubit/search_cubit.dart';
import 'recent_searches.dart';
import 'search_message.dart';
import 'search_results_list.dart';

/// Under the query box: the recent searches while it is empty, otherwise the
/// grouped results (or the no-results message).
class SearchBody extends StatelessWidget {
  const SearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    final state = context.watch<SearchCubit>().state;
    if (!state.hasQuery) return const RecentSearches();
    final l10n = context.l10n;
    return StatusBody(
      status: state.status,
      failure: state.failure,
      onRetry: () => cubit.searchNow(state.query),
      builder: (_) => state.results.isEmpty
          ? SearchMessage(
              title: l10n.searchNoResultsTitle(state.query.trim()),
              hint: l10n.searchNoResultsHint,
            )
          : SearchResultsList(results: state.results),
    );
  }
}
