import 'package:flutter_test/flutter_test.dart';
import 'package:sijilak/core/usecase/usecase.dart';
import 'package:sijilak/core/utils/view_status.dart';
import 'package:sijilak/features/account/presentation/cubit/account_cubit.dart';
import 'package:sijilak/features/auth/data/repositories/session_store_impl.dart';
import 'package:sijilak/features/auth/domain/usecases/get_session_use_case.dart';
import 'package:sijilak/features/auth/domain/usecases/sign_out_use_case.dart';

import 'account_fixtures.dart';

AccountCubit _cubit(InMemorySessionStore store) =>
    AccountCubit(GetSessionUseCase(store), SignOutUseCase(store));

void main() {
  test('load exposes the stored session', () async {
    final store = InMemorySessionStore()..save(accountSession);
    final cubit = _cubit(store);
    await cubit.load();
    expect(cubit.state.status, ViewStatus.success);
    expect(cubit.state.session, accountSession);
    expect(cubit.state.signedOut, isFalse);
    await cubit.close();
  });

  test('signOut clears the session store and flags signedOut', () async {
    final store = InMemorySessionStore()..save(accountSession);
    final cubit = _cubit(store);
    await cubit.load();
    await cubit.signOut();
    expect(store.current, isNull);
    expect(cubit.state.signedOut, isTrue);
    await cubit.close();
  });

  test('SignOutUseCase clears the store', () async {
    final store = InMemorySessionStore()..save(accountSession);
    final result = await SignOutUseCase(store)(const NoParams());
    expect(result.isSuccess, isTrue);
    expect(store.current, isNull);
  });
}
