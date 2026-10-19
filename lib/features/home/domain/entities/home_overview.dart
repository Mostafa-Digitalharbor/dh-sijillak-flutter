import 'package:equatable/equatable.dart';

import 'home_summary.dart';
import 'home_task.dart';
import 'home_user.dart';

/// Everything the dashboard displays.
class HomeOverview extends Equatable {
  const HomeOverview({
    required this.user,
    required this.summary,
    required this.tasks,
  });

  final HomeUser user;
  final HomeSummary summary;
  final List<HomeTask> tasks;

  @override
  List<Object?> get props => [user, summary, tasks];
}
