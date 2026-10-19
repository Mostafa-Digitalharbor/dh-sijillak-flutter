import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/failure_snack_bar.dart';
import '../constants/auth_blobs.dart';
import '../constants/auth_dimens.dart';
import '../cubit/registration_cubit.dart';
import '../widgets/login_preview_card.dart';
import '../widgets/logo_upload_box.dart';
import '../widgets/reg_step_scaffold.dart';

/// Registration step 5: the company logo and a preview of its login page.
/// Finishing it creates the workspace.
class RegBrandScreen extends StatelessWidget {
  const RegBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final registration = context.read<RegistrationCubit>();
    final draft = context.select((RegistrationCubit c) => c.state.draft);
    final submitting = context.select(
      (RegistrationCubit c) => c.state.status.isLoading,
    );
    return BlocListener<RegistrationCubit, RegistrationState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSuccess) context.go(AppRoutes.regDone);
        final failure = state.failure;
        if (state.status.isFailure && failure != null) {
          showFailureSnackBar(context, failure);
        }
      },
      child: RegStepScaffold(
        step: 5,
        title: l10n.companyLogo,
        subtitle: l10n.logoSubtitle,
        nextLabel: l10n.createWorkspace,
        nextEnabled: !submitting,
        gap: AuthDimens.regCompactGap,
        actionLabel: l10n.skip,
        onAction: () {
          registration.edit((d) => d.copyWith(hasLogo: false));
          registration.submit();
        },
        onNext: registration.submit,
        blobs: AuthBlobs.brand,
        children: [
          LogoUploadBox(hasLogo: draft.hasLogo),
          Text(
            l10n.loginPreview,
            style: AppTextStyles.label.restyle(fontWeight: FontWeight.w800),
          ),
          Center(
            child: LoginPreviewCard(
              hasLogo: draft.hasLogo,
              handle: draft.handle,
            ),
          ),
        ],
      ),
    );
  }
}
