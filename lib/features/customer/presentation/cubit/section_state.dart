import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/view_status.dart';

/// Loading state of one lazily loaded profile tab.
class SectionState<T> extends Equatable {
  const SectionState({
    this.status = ViewStatus.initial,
    this.items = const [],
    this.failure,
  });

  final ViewStatus status;
  final List<T> items;
  final Failure? failure;

  @override
  List<Object?> get props => [status, items, failure];
}
