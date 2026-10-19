import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sijilak/core/usecase/usecase.dart';
import 'package:sijilak/features/auth/data/repositories/preferences_session_store.dart';
import 'package:sijilak/features/auth/data/repositories/session_preferences_keys.dart';
import 'package:sijilak/features/auth/domain/entities/app_user.dart';
import 'package:sijilak/features/auth/domain/entities/auth_session.dart';
import 'package:sijilak/features/auth/domain/entities/workspace.dart';
import 'package:sijilak/features/auth/domain/usecases/get_session_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/sign_out_use_case.dart';

const _session = AuthSession(
  user: AppUser(id: 'u', name: 'Sara', email: 's@a.sa'),
  workspace: Workspace(
    id: 'w',
    name: 'Acme',
    handle: 'acme',
    url: 'acme.sijillak.com',
  ),
);

Future<PreferencesSessionStore> _store([
  Map<String, Object> values = const {},
]) async {
  SharedPreferences.setMockInitialValues(values);
  return PreferencesSessionStore(await SharedPreferences.getInstance());
}

void main() {
  group('PreferencesSessionStore', () {
    test('starts empty', () async {
      expect((await _store()).current, isNull);
    });

    test(
      'a saved session survives a new store over the same storage',
      () async {
        final first = await _store();
        first.save(_session);
        expect(first.current, _session);
        final second = PreferencesSessionStore(
          await SharedPreferences.getInstance(),
        );
        expect(second.current, _session);
      },
    );

    test('clear forgets the session for good', () async {
      final first = await _store();
      first
        ..save(_session)
        ..clear();
      expect(first.current, isNull);
      final second = PreferencesSessionStore(
        await SharedPreferences.getInstance(),
      );
      expect(second.current, isNull);
    });

    test('corrupt data is dropped', () async {
      final store = await _store({SessionPreferencesKeys.session: '{oops'});
      expect(store.current, isNull);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey(SessionPreferencesKeys.session), isFalse);
    });
  });

  group('session use cases', () {
    test('GetSessionUseCase returns the remembered session', () async {
      final store = await _store();
      final get = GetSessionUseCase(store);
      expect((await get(const NoParams())).dataOrNull, isNull);
      store.save(_session);
      expect((await get(const NoParams())).dataOrNull, _session);
    });

    test('SignOutUseCase clears it', () async {
      final store = await _store();
      store.save(_session);
      final result = await SignOutUseCase(store)(const NoParams());
      expect(result.isSuccess, isTrue);
      expect(store.current, isNull);
    });
  });
}
