import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../constants/auth_blobs.dart';
import '../constants/auth_dimens.dart';
import '../widgets/auth_header_slab.dart';
import '../widgets/auth_page.dart';
import '../widgets/welcome_feature_tile.dart';

/// First screen: brand, benefits and the sign-up / sign-in entry points.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthPage(
      blobs: AuthBlobs.welcome,
      bodyBottomPad: AuthDimens.welcomeBodyBottomPad,
      header: AuthHeaderSlab(
        topPad: AuthDimens.welcomeTopPad,
        bottomPad: AuthDimens.welcomeSlabBottomPad,
        radius: AppRadius.r36,
        logoWidth: AuthDimens.welcomeLogoWidth,
        child: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.s22),
          child: Text(
            l10n.welcomeTagline,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyBold.restyle(
              fontSize: AuthDimens.taglineFontSize,
              height: AuthDimens.taglineHeight,
              color: AppColors.textStrong,
            ),
          ),
        ),
      ),
      body: [
        WelcomeFeatureTile(icon: AppIcons.gift, text: l10n.featureFree),
        const SizedBox(height: AppSpacing.s12),
        WelcomeFeatureTile(
          icon: AppIcons.shieldCheck,
          text: l10n.featureFatoora,
        ),
        const SizedBox(height: AppSpacing.s12),
        WelcomeFeatureTile(icon: AppIcons.link, text: l10n.featureOwnLink),
        const Spacer(),
        PrimaryButton(
          label: l10n.createCompanyAccountFree,
          onPressed: () => context.push(AppRoutes.regCompany),
        ),
        const SizedBox(height: AppSpacing.s12),
        SecondaryButton(
          label: l10n.haveAccountSignIn,
          onPressed: () => context.push(AppRoutes.login),
        ),
      ],
    );
  }
}
