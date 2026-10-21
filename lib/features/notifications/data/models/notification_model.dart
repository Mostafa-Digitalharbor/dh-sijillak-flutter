import '../../../../core/network/api_client.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/entities/notification_kind.dart';

/// JSON mapping of an [AppNotification].
abstract final class NotificationModel {
  static AppNotification fromJson(Json json) => AppNotification(
    id: json['id'] as String,
    kind: NotificationKind.values.byName(json['kind'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
    isRead: json['isRead'] as bool? ?? false,
    customerName: json['customerName'] as String?,
    amount: json['amount'] as num?,
    subject: json['subject'] as String?,
    quoteNumber: (json['quoteNumber'] as num?)?.toInt(),
    invoiceNumber: (json['invoiceNumber'] as num?)?.toInt(),
    customerId: json['customerId'] as String?,
    dealId: json['dealId'] as String?,
  );

  static List<AppNotification> listFromJson(Object? payload) => [
    for (final json in payload.asJsonList) fromJson(json),
  ];

  static Json toJson(AppNotification n) => {
    'id': n.id,
    'kind': n.kind.name,
    'createdAt': n.createdAt.toIso8601String(),
    'isRead': n.isRead,
    if (n.customerName != null) 'customerName': n.customerName,
    if (n.amount != null) 'amount': n.amount,
    if (n.subject != null) 'subject': n.subject,
    if (n.quoteNumber != null) 'quoteNumber': n.quoteNumber,
    if (n.invoiceNumber != null) 'invoiceNumber': n.invoiceNumber,
    if (n.customerId != null) 'customerId': n.customerId,
    if (n.dealId != null) 'dealId': n.dealId,
  };
}
