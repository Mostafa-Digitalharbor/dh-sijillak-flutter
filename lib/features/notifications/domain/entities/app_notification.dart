import 'package:equatable/equatable.dart';

import 'notification_kind.dart';

/// One event the user is told about. It carries raw data only; the wording is
/// composed by the UI from [kind] and these fields.
class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.kind,
    required this.createdAt,
    required this.isRead,
    this.customerName,
    this.amount,
    this.subject,
    this.quoteNumber,
    this.invoiceNumber,
    this.customerId,
    this.dealId,
  });

  final String id;
  final NotificationKind kind;
  final DateTime createdAt;
  final bool isRead;

  /// Customer the event concerns.
  final String? customerName;

  /// Money involved (quote total, invoice amount, deal value).
  final num? amount;

  /// Title of the task or deal the event concerns.
  final String? subject;

  // Where tapping the notification leads, in order of precedence.
  final int? quoteNumber;
  final int? invoiceNumber;
  final String? customerId;
  final String? dealId;

  /// The quote or invoice number the wording refers to.
  int? get documentNumber => quoteNumber ?? invoiceNumber;

  /// This notification once opened.
  AppNotification markedRead() => isRead
      ? this
      : AppNotification(
          id: id,
          kind: kind,
          createdAt: createdAt,
          isRead: true,
          customerName: customerName,
          amount: amount,
          subject: subject,
          quoteNumber: quoteNumber,
          invoiceNumber: invoiceNumber,
          customerId: customerId,
          dealId: dealId,
        );

  @override
  List<Object?> get props => [
    id,
    kind,
    createdAt,
    isRead,
    customerName,
    amount,
    subject,
    quoteNumber,
    invoiceNumber,
    customerId,
    dealId,
  ];
}
