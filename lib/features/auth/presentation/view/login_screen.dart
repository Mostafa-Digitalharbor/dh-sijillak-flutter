import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../../shared/widgets/section_heading.dart';
import '../constants/auth_blobs.dart';
import '../constants/auth_dimens.dart';
import '../cubit/login_cubit.dart';
import '../widgets/auth_header_slab.dart';
import '../widgets/auth_page.dart';
import '../widgets/login_failure_snack_bar.dart';
import '../widgets/workspace_url_chip.dart';

/// Sign-in screen of a company workspace.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>()..loadBiometricAvailability(),
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status.isSuccess) context.go(AppRoutes.home);
          final failure = state.failure;
          if (state.status.isFailure && failure != null) {
            showLoginFailureSnackBar(context, failure);
          }
        },
        child: const _LoginView(),
      ),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<LoginCubit>();
    final signingIn = context.select(
      (LoginCubit c) => c.state.status.isLoading,
    );
    final biometricsAvailable = context.select(
      (LoginCubit c) => c.state.biometricsAvailable,
    );
    return AuthPage(
      blobs: AuthBlobs.login,
      bodyBottomPad: AuthDimens.loginBodyBottomPad,
      header: AuthHeaderSlab(
        topPad: AuthDimens.loginTopPad,
        bottomPad: AuthDimens.loginSlabBottomPad,
        radius: AppRadius.r32,
        logoWidth: AuthDimens.loginLogoWidth,
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s18),
          child: WorkspaceUrlChip(
            url: AppConfig.workspaceUrl(AppConfig.sampleHandle),
            fontSize: AuthDimens.workspaceChipFont,
            dotSize: AuthDimens.workspaceDot,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s14,
              vertical: AppSpacing.s8,
            ),
          ),
        ),
      ),
      body: [
        SectionHeading(title: l10n.loginTitle, subtitle: l10n.loginSubtitle),
        const SizedBox(height: AppSpacing.s18),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: l10n.email,
                hint: l10n.authEmailHint,
                keyboardType: TextInputType.emailAddress,
                ltr: true,
                onChanged: cubit.emailChanged,
              ),
              const SizedBox(height: AppSpacing.s14),
              Row(
                children: [
                  Expanded(
                    child: Text(l10n.password, style: AppTextStyles.label),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      l10n.forgotPassword,
                      style: AppTextStyles.link.restyle(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                        fontSize: AuthDimens.forgotFont,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s6),
              AppTextField(obscureText: true, onChanged: cubit.passwordChanged),
              const SizedBox(height: AppSpacing.s18),
              PrimaryButton(
                label: l10n.signIn,
                height: AuthDimens.signInHeight,
                radius: AuthDimens.loginButtonRadius,
                enabled: !signingIn,
                onPressed: cubit.signIn,
              ),
              if (biometricsAvailable) ...[
                const SizedBox(height: AppSpacing.s14),
                SecondaryButton(
                  label: l10n.signInFaceId,
                  icon: AppIcons.faceId,
                  height: AuthDimens.faceIdHeight,
                  radius: AuthDimens.loginButtonRadius,
                  fontSize: AuthDimens.faceIdFont,
                  fontWeight: FontWeight.w700,
                  onPressed: signingIn ? null : cubit.signInWithBiometrics,
                ),
              ],
            ],
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppIcon(
              AppIcons.shieldCheck,
              size: AuthDimens.complianceIcon,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.s8),
            Flexible(
              child: Text(
                l10n.fatooraCompliant,
                style: AppTextStyles.caption.restyle(
                  fontSize: AuthDimens.complianceFont,
                  color: AppColors.textSubtle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s18),
        Center(
          child: Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              style: AppTextStyles.subtitle.restyle(
                fontSize: AuthDimens.noAccountFont,
                color: AppColors.textSubtle,
              ),
              children: [
                TextSpan(text: l10n.noAccountPrompt),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: GestureDetector(
                    onTap: () => context.push(AppRoutes.regCompany),
                    child: Text(
                      l10n.signUpFree,
                      style: AppTextStyles.link.restyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
