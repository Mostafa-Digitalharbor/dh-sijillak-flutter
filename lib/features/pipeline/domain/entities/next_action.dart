import 'package:equatable/equatable.dart';

/// The next step planned on a deal, optionally scheduled.
class NextAction extends Equatable {
  const NextAction({required this.title, this.at, this.hasTime = false});

  final String title;

  /// When the step is due; null when it has no date yet.
  final DateTime? at;

  /// Whether the time of day in [at] is meaningful (else only the date is).
  final bool hasTime;

  @override
  List<Object?> get props => [title, at, hasTime];
}
