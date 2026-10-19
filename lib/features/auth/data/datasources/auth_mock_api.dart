import 'dart:convert';

import '../../../../core/constants/app_config.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/mock/mock_assets.dart';
import '../../../../core/network/mock/mock_route.dart';
import '../models/registration_request_model.dart';
import 'auth_api_fields.dart';
import 'auth_endpoints.dart';

/// Fake auth endpoints served by the mock backend.
class AuthMockApi implements MockApiModule {
  AuthMockApi(this._assets);

  static final _otpPattern = RegExp(r'^\d{6}$');

  /// The one code the mock backend rejects.
  static const _rejectedOtp = '000000';

  final MockAssets _assets;

  /// Handles claimed through the mock during this run.
  final Set<String> _claimedHandles = {};

  @override
  List<MockRoute> get routes => [
    MockRoute(HttpMethod.get, AuthEndpoints.handleAvailability, (r) {
      final handle = r.query[AuthApiFields.handle] ?? '';
      return {AuthApiFields.available: _isFree(handle)};
    }),
    MockRoute(HttpMethod.post, AuthEndpoints.requestOtp, (_) => const {}),
    MockRoute(HttpMethod.post, AuthEndpoints.verifyOtp, (r) {
      final code = r.body[AuthApiFields.code] as String? ?? '';
      if (!_otpPattern.hasMatch(code) || code == _rejectedOtp) {
        throw const ValidationException(
          fields: {AuthApiFields.code: AuthApiFields.invalidCode},
        );
      }
      return const {};
    }),
    MockRoute(HttpMethod.post, AuthEndpoints.workspaces, _register),
    MockRoute(HttpMethod.post, AuthEndpoints.login, _login),
    MockRoute(HttpMethod.post, AuthEndpoints.loginBiometric, _loginBiometric),
  ];

  bool _isFree(String handle) =>
      handle.isNotEmpty &&
      !AppConfig.reservedHandles.contains(handle) &&
      !_claimedHandles.contains(handle);

  /// The session of the latest sign-in or registration: what the device
  /// would have remembered for biometric sign-in.
  Json? _remembered;

  Future<Json> _session() async =>
      (await _assets.json(AuthApiFields.sessionFixture)).asJson;

  /// Remembers [session] for biometric sign-in and hands it back.
  Json _remember(Json session) {
    _remembered = jsonDecode(jsonEncode(session)) as Json;
    return session;
  }

  Future<Object?> _register(MockRequest request) async {
    final draft = RegistrationRequestModel.fromJson(request.body).toEntity();
    final handle = draft.handle.isEmpty ? AppConfig.sampleHandle : draft.handle;
    if (!_isFree(handle)) {
      throw const ValidationException(
        fields: {AuthApiFields.handle: AuthApiFields.takenCode},
      );
    }
    _claimedHandles.add(handle);
    final session = await _session();
    (session['user'] as Json)
      ..['name'] = draft.ownerName
      ..['email'] = draft.email;
    (session['workspace'] as Json)
      ..['name'] = draft.companyName
      ..['handle'] = handle
      ..['url'] = AppConfig.workspaceUrl(handle);
    return _remember(session);
  }

  Future<Object?> _login(MockRequest request) async {
    final email = (request.body[AuthApiFields.email] as String? ?? '').trim();
    final password = request.body[AuthApiFields.password] as String? ?? '';
    if (email.isEmpty || password.isEmpty) {
      throw ValidationException(
        fields: {
          if (email.isEmpty) AuthApiFields.email: AuthApiFields.requiredCode,
          if (password.isEmpty)
            AuthApiFields.password: AuthApiFields.requiredCode,
        },
      );
    }
    final session = await _session();
    (session['user'] as Json)['email'] = email;
    return _remember(session);
  }

  Future<Object?> _loginBiometric(MockRequest request) async {
    final remembered = _remembered;
    if (remembered == null) {
      throw const ValidationException(
        fields: {AuthApiFields.biometric: AuthApiFields.noCredentialCode},
      );
    }
    return jsonDecode(jsonEncode(remembered));
  }
}
