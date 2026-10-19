import 'package:equatable/equatable.dart';

/// A one-time code to check against the number it was sent to.
class OtpVerification extends Equatable {
  const OtpVerification({required this.phone, required this.code});

  final String phone;
  final String code;

  @override
  List<Object?> get props => [phone, code];
}
