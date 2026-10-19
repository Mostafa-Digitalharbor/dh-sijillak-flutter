import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../constants/auth_blobs.dart';
import '../constants/auth_dimens.dart';
import '../cubit/registration_cubit.dart';
import '../widgets/done_success_header.dart';
import '../widgets/next_steps_card.dart';
import '../widgets/scroll_fill_view.dart';

/// Final registration screen: workspace created, share the link, next steps.
class RegDoneScreen extends StatelessWidget {
  const RegDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final workspaceUrl = context.select(
      (RegistrationCubit c) => c.state.workspace?.url,
    );
    return AppBackground(
      blobs: AuthBlobs.done,
      child: SafeArea(
        top: false,
        bottom: false,
        child: ScrollFillView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            context.topPad(AuthDimens.doneTopPad),
            AppSpacing.gutter,
            context.bottomPad(AuthDimens.doneBottomPad),
          ),
          child: Column(
            children: [
              DoneSuccessHeader(workspaceUrl: workspaceUrl),
              const SizedBox(height: AuthDimens.doneHeaderGap),
              const NextStepsCard(),
              const Spacer(),
              PrimaryButton(
                label: l10n.enterWorkspace,
                onPressed: () => context.go(AppRoutes.home),
              ),
              const SizedBox(height: AppSpacing.s12),
              SecondaryButton(
                label: l10n.inviteTeam,
                icon: AppIcons.userPlus,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
