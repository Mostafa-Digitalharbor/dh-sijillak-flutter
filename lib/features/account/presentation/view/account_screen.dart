import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/danger_button.dart';
import '../../../../shared/widgets/failure_snack_bar.dart';
import '../../../../shared/widgets/screen_header.dart';
import '../constants/account_dimens.dart';
import '../cubit/account_cubit.dart';
import '../widgets/language_card.dart';
import '../widgets/profile_card.dart';
import '../widgets/sign_out_dialog.dart';

/// Account and settings: profile, language and sign out.
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AccountCubit>()..load(),
      child: const _AccountView(),
    );
  }
}

class _AccountView extends StatelessWidget {
  const _AccountView();

  @override
  Widget build(BuildContext context) {
    final state = context.select((AccountCubit c) => c.state);
    return BlocListener<AccountCubit, AccountState>(
      listenWhen: (previous, current) =>
          current.signedOut || current.failure != previous.failure,
      listener: (context, state) {
        if (state.signedOut) {
          context.go(AppRoutes.welcome);
        } else if (state.failure != null) {
          showFailureSnackBar(context, state.failure!);
        }
      },
      child: AppBackground(
        blobs: AccountDimens.blobs,
        child: SafeArea(
          top: false,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              context.topPad(AccountDimens.topPadding),
              AppSpacing.gutter,
              AccountDimens.bottomPadding,
            ),
            children: [
              ScreenHeader(title: context.l10n.settingsTitle),
              const SizedBox(height: AppSpacing.s20),
              if (state.session != null) ...[
                ProfileCard(session: state.session!),
                const SizedBox(height: AppSpacing.s16),
              ],
              const LanguageCard(),
              const SizedBox(height: AppSpacing.s24),
              DangerButton(
                label: context.l10n.settingsSignOut,
                onPressed: () => _confirmAndSignOut(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmAndSignOut(BuildContext context) async {
    final cubit = context.read<AccountCubit>();
    if (await confirmSignOut(context)) await cubit.signOut();
  }
}
