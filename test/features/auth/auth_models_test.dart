import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/features/auth/data/models/auth_session_model.dart';
import 'package:sijilak/features/auth/data/models/handle_availability_model.dart';
import 'package:sijilak/features/auth/data/models/registration_request_model.dart';
import 'package:sijilak/features/auth/data/models/workspace_model.dart';
import 'package:sijilak/features/auth/domain/entities/business_sector.dart';
import 'package:sijilak/features/auth/domain/entities/registration_draft.dart';
import 'package:sijilak/features/auth/domain/entities/saudi_city.dart';

void main() {
  test('WorkspaceModel round-trips JSON and maps to the entity', () {
    final json = {
      'id': 'w1',
      'name': 'Acme',
      'handle': 'acme',
      'url': 'acme.sijillak.com',
    };
    final model = WorkspaceModel.fromJson(json);
    expect(model.toJson(), json);
    final entity = model.toEntity();
    expect(entity.handle, 'acme');
    expect(entity.url, 'acme.sijillak.com');
  });

  test('AuthSessionModel parses user and workspace', () {
    final session = AuthSessionModel.fromJson({
      'user': {'id': 'u1', 'name': 'Sara', 'email': 's@a.sa'},
      'workspace': {
        'id': 'w1',
        'name': 'Acme',
        'handle': 'acme',
        'url': 'acme.sijillak.com',
      },
    }).toEntity();
    expect(session.user.email, 's@a.sa');
    expect(session.workspace.name, 'Acme');
  });

  test('HandleAvailabilityModel reads the flag', () {
    expect(
      HandleAvailabilityModel.fromJson({'available': true}).toEntity(),
      isTrue,
    );
  });

  test('RegistrationRequestModel round-trips the whole draft', () {
    const draft = RegistrationDraft(
      companyName: 'Acme',
      sector: BusinessSector.industry,
      handle: 'acme',
      ownerName: 'Sara',
      email: 's@a.sa',
      phone: '500000000',
      password: 'secret123',
      termsAccepted: false,
      commercialRegNo: '1010101010',
      vatNumber: '300000000000003',
      city: SaudiCity.jeddah,
      postalCode: '12345',
      address: 'Street 1',
      zatcaEnabled: false,
      hasLogo: true,
    );
    final json = RegistrationRequestModel(draft).toJson();
    expect(RegistrationRequestModel.fromJson(json).toEntity(), draft);
  });

  test('skipping the tax step resets only its fields', () {
    const draft = RegistrationDraft(
      companyName: 'Acme',
      vatNumber: '3',
      city: SaudiCity.dammam,
      zatcaEnabled: false,
    );
    final cleared = draft.withoutTaxDetails();
    expect(cleared.companyName, 'Acme');
    expect(cleared.vatNumber, isEmpty);
    expect(cleared.city, SaudiCity.riyadh);
    expect(cleared.zatcaEnabled, isTrue);
  });
}
