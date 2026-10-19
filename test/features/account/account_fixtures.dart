import 'package:sijilak/features/auth/domain/entities/app_user.dart';
import 'package:sijilak/features/auth/domain/entities/auth_session.dart';
import 'package:sijilak/features/auth/domain/entities/workspace.dart';

/// A signed-in session used across the account tests.
const accountSession = AuthSession(
  user: AppUser(id: 'u1', name: 'Sara Ahmed', email: 'sara@acme.sa'),
  workspace: Workspace(
    id: 'w1',
    name: 'Acme Trading',
    handle: 'acme',
    url: 'acme.sijillak.com',
  ),
);
