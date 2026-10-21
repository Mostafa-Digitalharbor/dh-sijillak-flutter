import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/search_cubit.dart';

/// Opening a search result.
extension SearchNavigation on BuildContext {
  /// Remembers the current query, then pushes [route] carrying [extra].
  void openSearchResult(String route, Object extra) {
    unawaited(read<SearchCubit>().remember());
    push(route, extra: extra);
  }
}
