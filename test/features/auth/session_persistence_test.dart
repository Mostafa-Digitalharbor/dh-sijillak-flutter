import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sijilak/core/network/auth_tokens.dart';
import 'package:sijilak/core/usecase/usecase.dart';
import 'package:sijilak/features/auth/data/models/auth_session_model.dart';
import 'package:sijilak/features/auth/data/repositories/secure_session_store.dart';
import 'package:sijilak/features/auth/data/repositories/session_storage_keys.dart';
import 'package:sijilak/features/auth/domain/entities/app_user.dart';
import 'package:sijilak/features/auth/domain/entities/auth_session.dart';
import 'package:sijilak/features/auth/domain/entities/workspace.dart';
import 'package:sijilak/features/auth/domain/usecases/get_session_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/sign_out_use_case.dart';

const _tokens = AuthTokens(accessToken: 'acc', refreshToken: 'ref');
const _session = AuthSession(
  user: AppUser(id: 'u', name: 'Sara', email: 's@a.sa'),
  workspace: Workspace(
    id: 'w',
    name: 'Acme',
    handle: 'acme',
    url: 'acme.sijillak.com',
  ),
  tokens: _tokens,
);

const _storage = FlutterSecureStorage();

String _json(AuthSession s) =>
    jsonEncode(AuthSessionModel.fromEntity(s).toJson());

Future<SecureSessionStore> _open({
  Map<String, String> secure = const {},
  Map<String, Object> prefs = const {},
}) async {
  FlutterSecureStorage.setMockInitialValues({...secure});
  SharedPreferences.setMockInitialValues(prefs);
  return _reopen();
}

Future<SecureSessionStore> _reopen() async => SecureSessionStore.open(
  storage: _storage,
  legacyPreferences: await SharedPreferences.getInstance(),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SecureSessionStore', () {
    test('starts empty', () async {
      final store = await _open();
      expect(store.current, isNull);
      expect(store.remembered, isNull);
    });

    test('a saved session, tokens included, survives a reopen', () async {
      final first = await _open();
      first.save(_session);
      expect(first.current, _session);
      await first.flush();
      final second = await _reopen();
      expect(second.current, _session);
      expect(second.current!.tokens, _tokens);
    });

    test('nothing is written to shared preferences', () async {
      final store = await _open();
      store.save(_session);
      await store.flush();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getKeys(), isEmpty);
    });

    test('clear signs out but keeps the remembered session', () async {
      final first = await _open();
      first
        ..save(_session)
        ..clear();
      expect(first.current, isNull);
      expect(first.remembered, _session);
      await first.flush();
      final second = await _reopen();
      expect(second.current, isNull);
      expect(second.remembered, _session);
    });

    test('forgetRemembered removes it for good', () async {
      final first = await _open();
      first
        ..save(_session)
        ..clear()
        ..forgetRemembered();
      await first.flush();
      final second = await _reopen();
      expect(second.remembered, isNull);
      expect(await _storage.read(key: SessionStorageKeys.remembered), isNull);
    });

    test('corrupt data is dropped', () async {
      final store = await _open(secure: {SessionStorageKeys.session: '{oops'});
      expect(store.current, isNull);
      expect(await _storage.read(key: SessionStorageKeys.session), isNull);
    });
  });

  group('legacy migration', () {
    test('moves a plain-text session into secure storage', () async {
      final legacy = _session.withTokens(_tokens);
      final store = await _open(
        prefs: {SessionStorageKeys.legacyPreferencesSession: _json(legacy)},
      );
      expect(store.current, legacy);
      expect(await _storage.read(key: SessionStorageKeys.session), isNotNull);
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.containsKey(SessionStorageKeys.legacyPreferencesSession),
        isFalse,
      );
      final reopened = await _reopen();
      expect(reopened.current, legacy);
    });

    test('a secure session wins over a stale legacy one', () async {
      final store = await _open(
        secure: {SessionStorageKeys.session: _json(_session)},
        prefs: {
          SessionStorageKeys.legacyPreferencesSession: _json(
            _session.withTokens(
              const AuthTokens(accessToken: 'old', refreshToken: 'old'),
            ),
          ),
        },
      );
      expect(store.current, _session);
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.containsKey(SessionStorageKeys.legacyPreferencesSession),
        isFalse,
      );
    });

    test('an unreadable legacy session is deleted', () async {
      final store = await _open(
        prefs: {SessionStorageKeys.legacyPreferencesSession: '{oops'},
      );
      expect(store.current, isNull);
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.containsKey(SessionStorageKeys.legacyPreferencesSession),
        isFalse,
      );
    });
  });

  group('session use cases', () {
    test('GetSessionUseCase returns the remembered session', () async {
      final store = await _open();
      final get = GetSessionUseCase(store);
      expect((await get(const NoParams())).dataOrNull, isNull);
      store.save(_session);
      expect((await get(const NoParams())).dataOrNull, _session);
    });

    test('SignOutUseCase clears the session from secure storage', () async {
      final store = await _open();
      store.save(_session);
      final result = await SignOutUseCase(store)(const NoParams());
      expect(result.isSuccess, isTrue);
      expect(store.current, isNull);
      await store.flush();
      expect(await _storage.read(key: SessionStorageKeys.session), isNull);
    });
  });
}
