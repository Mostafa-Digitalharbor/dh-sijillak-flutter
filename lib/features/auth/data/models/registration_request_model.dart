import '../../../../core/network/api_client.dart';
import '../../domain/entities/business_sector.dart';
import '../../domain/entities/registration_draft.dart';
import '../../domain/entities/saudi_city.dart';

/// JSON body of the workspace registration request.
class RegistrationRequestModel {
  const RegistrationRequestModel(this.draft);

  factory RegistrationRequestModel.fromJson(Json json) {
    final company = json['company'] as Json;
    final owner = json['owner'] as Json;
    final tax = json['tax'] as Json;
    final brand = json['brand'] as Json;
    return RegistrationRequestModel(
      RegistrationDraft(
        companyName: company['name'] as String,
        sector: BusinessSector.values.byName(company['sector'] as String),
        handle: company['handle'] as String,
        ownerName: owner['name'] as String,
        email: owner['email'] as String,
        phone: owner['phone'] as String,
        password: owner['password'] as String,
        termsAccepted: owner['termsAccepted'] as bool,
        commercialRegNo: tax['commercialRegNo'] as String,
        vatNumber: tax['vatNumber'] as String,
        city: SaudiCity.values.byName(tax['city'] as String),
        postalCode: tax['postalCode'] as String,
        address: tax['address'] as String,
        zatcaEnabled: tax['zatcaEnabled'] as bool,
        hasLogo: brand['hasLogo'] as bool,
      ),
    );
  }

  final RegistrationDraft draft;

  Json toJson() => {
    'company': {
      'name': draft.companyName,
      'sector': draft.sector.name,
      'handle': draft.handle,
    },
    'owner': {
      'name': draft.ownerName,
      'email': draft.email,
      'phone': draft.phone,
      'password': draft.password,
      'termsAccepted': draft.termsAccepted,
    },
    'tax': {
      'commercialRegNo': draft.commercialRegNo,
      'vatNumber': draft.vatNumber,
      'city': draft.city.name,
      'postalCode': draft.postalCode,
      'address': draft.address,
      'zatcaEnabled': draft.zatcaEnabled,
    },
    'brand': {'hasLogo': draft.hasLogo},
  };

  RegistrationDraft toEntity() => draft;
}
