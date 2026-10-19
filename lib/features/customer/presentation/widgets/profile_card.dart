import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/initials.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/initials_badge.dart';
import '../constants/customer_dimens.dart';
import '../cubit/customer_cubit.dart';
import 'contact_action.dart';

/// Customer identity (badge, name, location, VAT number) and the contact
/// shortcuts.
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final customer = context.select((CustomerCubit c) => c.state.customer!);
    final l10n = context.l10n;
    return GlassCard(
      radius: AppRadius.r24,
      fill: AppColors.white74,
      child: Column(
        children: [
          Row(
            children: [
              InitialsBadge(
                text: initialsOf(customer.name),
                size: CustomerDimens.badgeSize,
                radius: CustomerDimens.badgeRadius,
                fontSize: CustomerDimens.badgeFont,
              ),
              const SizedBox(width: AppSpacing.s14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: AppTextStyles.title.restyle(
                        fontSize: CustomerDimens.nameFont,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      customer.location,
                      style: AppTextStyles.subtitle.restyle(
                        fontSize: CustomerDimens.locationFont,
                      ),
                    ),
                    Text(
                      l10n.vatNumberLine(customer.vatNumber),
                      style: AppTextStyles.caption.restyle(
                        fontSize: CustomerDimens.vatFont,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          Row(
            children: [
              Expanded(
                child: ContactAction(icon: AppIcons.phone, label: l10n.call),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: ContactAction(
                  icon: AppIcons.message,
                  label: l10n.message,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: ContactAction(icon: AppIcons.mail, label: l10n.mail),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: ContactAction(icon: AppIcons.pin, label: l10n.location),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
