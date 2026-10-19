import 'package:equatable/equatable.dart';

enum CustomerActivityKind { quoteSent, call, invoiceOverdue }

/// One entry of a customer's activity timeline.
class CustomerActivity extends Equatable {
  const CustomerActivity({
    required this.id,
    required this.kind,
    required this.title,
    required this.at,
    this.detail,
    this.amount,
  });

  final String id;
  final CustomerActivityKind kind;
  final String title;

  /// When it happened; for an overdue invoice, when it fell due.
  final DateTime at;

  /// Free-text note on the activity, when any.
  final String? detail;

  /// Money involved (quote or invoice total), when any.
  final int? amount;

  @override
  List<Object?> get props => [id, kind, title, at, detail, amount];
}
