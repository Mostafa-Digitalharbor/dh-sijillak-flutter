import 'package:equatable/equatable.dart';

import 'business_sector.dart';
import 'saudi_city.dart';

/// Everything collected across the registration steps, submitted at the end.
class RegistrationDraft extends Equatable {
  const RegistrationDraft({
    this.companyName = '',
    this.sector = BusinessSector.trade,
    this.handle = '',
    this.ownerName = '',
    this.email = '',
    this.phone = '',
    this.password = '',
    this.termsAccepted = true,
    this.commercialRegNo = '',
    this.vatNumber = '',
    this.city = SaudiCity.riyadh,
    this.postalCode = '',
    this.address = '',
    this.zatcaEnabled = true,
    this.hasLogo = false,
  });

  final String companyName;
  final BusinessSector sector;
  final String handle;
  final String ownerName;
  final String email;
  final String phone;
  final String password;
  final bool termsAccepted;
  final String commercialRegNo;
  final String vatNumber;
  final SaudiCity city;
  final String postalCode;
  final String address;
  final bool zatcaEnabled;
  final bool hasLogo;

  RegistrationDraft copyWith({
    String? companyName,
    BusinessSector? sector,
    String? handle,
    String? ownerName,
    String? email,
    String? phone,
    String? password,
    bool? termsAccepted,
    String? commercialRegNo,
    String? vatNumber,
    SaudiCity? city,
    String? postalCode,
    String? address,
    bool? zatcaEnabled,
    bool? hasLogo,
  }) => RegistrationDraft(
    companyName: companyName ?? this.companyName,
    sector: sector ?? this.sector,
    handle: handle ?? this.handle,
    ownerName: ownerName ?? this.ownerName,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    password: password ?? this.password,
    termsAccepted: termsAccepted ?? this.termsAccepted,
    commercialRegNo: commercialRegNo ?? this.commercialRegNo,
    vatNumber: vatNumber ?? this.vatNumber,
    city: city ?? this.city,
    postalCode: postalCode ?? this.postalCode,
    address: address ?? this.address,
    zatcaEnabled: zatcaEnabled ?? this.zatcaEnabled,
    hasLogo: hasLogo ?? this.hasLogo,
  );

  /// The tax step skipped: its fields go back to their defaults.
  RegistrationDraft withoutTaxDetails() => RegistrationDraft(
    companyName: companyName,
    sector: sector,
    handle: handle,
    ownerName: ownerName,
    email: email,
    phone: phone,
    password: password,
    termsAccepted: termsAccepted,
    hasLogo: hasLogo,
  );

  @override
  List<Object?> get props => [
    companyName,
    sector,
    handle,
    ownerName,
    email,
    phone,
    password,
    termsAccepted,
    commercialRegNo,
    vatNumber,
    city,
    postalCode,
    address,
    zatcaEnabled,
    hasLogo,
  ];
}
