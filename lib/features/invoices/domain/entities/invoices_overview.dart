import 'package:equatable/equatable.dart';

/// Amounts behind the summary bar at the top of the invoices list.
class InvoicesOverview extends Equatable {
  const InvoicesOverview({
    required this.paid,
    required this.due,
    required this.late,
  });

  final int paid;
  final int due;
  final int late;

  int get total => paid + due + late;

  /// Share of [part] in the total, as a whole percentage.
  int percent(int part) => total == 0 ? 0 : (part * 100 / total).round();

  @override
  List<Object?> get props => [paid, due, late];
}
