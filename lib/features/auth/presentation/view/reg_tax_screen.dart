import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_dropdown_field.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/entities/saudi_city.dart';
import '../constants/auth_blobs.dart';
import '../constants/auth_dimens.dart';
import '../cubit/registration_cubit.dart';
import '../extensions/saudi_city_l10n.dart';
import '../widgets/compact_labeled_field.dart';
import '../widgets/reg_step_scaffold.dart';
import '../widgets/zatca_toggle_card.dart';

/// Registration step 4: commercial / tax identifiers and e-invoicing.
class RegTaxScreen extends StatelessWidget {
  const RegTaxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final registration = context.read<RegistrationCubit>();
    final cities = [for (final c in SaudiCity.values) c.localized(l10n)];
    return RegStepScaffold(
      step: 4,
      title: l10n.taxTitle,
      subtitle: l10n.taxSubtitle,
      nextLabel: l10n.continueLabel,
      gap: AuthDimens.regCompactGap,
      actionLabel: l10n.later,
      onAction: () {
        registration.skipTax();
        context.push(AppRoutes.regBrand);
      },
      onNext: () => context.push(AppRoutes.regBrand),
      blobs: AuthBlobs.tax,
      children: [
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: l10n.commercialRegNo,
                hint: l10n.digits10,
                keyboardType: TextInputType.number,
                onChanged: (value) => registration.edit(
                  (d) => d.copyWith(commercialRegNo: value),
                ),
              ),
              const SizedBox(height: AppSpacing.s14),
              AppTextField(
                label: l10n.vatNumber,
                hint: l10n.vatNumberHint,
                keyboardType: TextInputType.number,
                onChanged: (value) =>
                    registration.edit((d) => d.copyWith(vatNumber: value)),
              ),
              const SizedBox(height: AppSpacing.s14),
              Text(l10n.nationalAddress, style: AppTextStyles.label),
              const SizedBox(height: AppSpacing.s6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppDropdownField(
                      label: l10n.city,
                      compact: true,
                      items: cities,
                      onChanged: (value) => registration.edit(
                        (d) => d.copyWith(
                          city: SaudiCity.values[cities.indexOf(value)],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: CompactLabeledField(
                      label: l10n.postalCode,
                      hint: l10n.digits5,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => registration.edit(
                        (d) => d.copyWith(postalCode: value),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s8),
              AppTextField(
                hint: l10n.addressHint,
                height: AuthDimens.compactFieldHeight,
                fontSize: AuthDimens.compactFieldFont,
                onChanged: (value) =>
                    registration.edit((d) => d.copyWith(address: value)),
              ),
            ],
          ),
        ),
        const ZatcaToggleCard(),
      ],
    );
  }
}
