import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_switch.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../constants/auth_dimens.dart';
import '../cubit/registration_cubit.dart';

/// Card with the e-invoicing (ZATCA) integration switch.
class ZatcaToggleCard extends StatelessWidget {
  const ZatcaToggleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final on = context.select(
      (RegistrationCubit c) => c.state.draft.zatcaEnabled,
    );
    final radius = BorderRadius.circular(AuthDimens.zatcaCardRadius);
    return Semantics(
      toggled: on,
      label: l10n.fatooraLinkSemantic,
      child: Material(
        color: AppColors.white78,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: () => context.read<RegistrationCubit>().edit(
            (d) => d.copyWith(zatcaEnabled: !d.zatcaEnabled),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s14),
            child: Row(
              children: [
                const IconTile(
                  icon: AppIcons.shieldCheck,
                  size: AuthDimens.zatcaTileSize,
                  radius: AuthDimens.zatcaTileRadius,
                  iconSize: AuthDimens.zatcaTileIcon,
                ),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.fatooraLink,
                        style: AppTextStyles.bodyBold.restyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s2),
                      Text(l10n.fatooraLinkDesc, style: AppTextStyles.caption),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                AppSwitch(value: on),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
