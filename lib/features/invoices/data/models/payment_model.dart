import '../../../../core/network/api_client.dart';
import '../../domain/entities/new_payment.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/payment_method.dart';

/// JSON codes of [PaymentMethod].
extension PaymentMethodCode on PaymentMethod {
  String get code => switch (this) {
    PaymentMethod.bankTransfer => 'bank_transfer',
    PaymentMethod.card => 'card',
    PaymentMethod.cash => 'cash',
  };

  static PaymentMethod fromCode(String code) => PaymentMethod.values.firstWhere(
    (m) => m.code == code,
    orElse: () => PaymentMethod.bankTransfer,
  );
}

/// JSON mapping of [Payment] and of the [NewPayment] request body.
abstract final class PaymentModel {
  static Payment fromJson(Json json) => Payment(
    amount: (json['amount'] as num).toInt(),
    method: PaymentMethodCode.fromCode(json['method'] as String),
    date: DateTime.parse(json['date'] as String),
    reference: json['reference'] as String?,
    hasReceipt: json['hasReceipt'] as bool? ?? false,
  );

  static Json toJson(NewPayment payment) => {
    'amount': payment.amount,
    'method': payment.method.code,
    'date': payment.date.toIso8601String(),
    'reference': payment.reference,
    'hasReceipt': payment.hasReceipt,
  };
}
