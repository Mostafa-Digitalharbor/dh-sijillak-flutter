import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/failure_l10n.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/view_status.dart';
import '../../../../shared/widgets/app_dropdown_field.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/failure_snack_bar.dart';
import '../../../../shared/widgets/frosted_sheet_body.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../auth/domain/entities/business_sector.dart';
import '../../../auth/presentation/extensions/business_sector_l10n.dart';
import '../constants/customer_dimens.dart';
import '../cubit/new_customer_cubit.dart';

/// Form of the new-customer sheet: name (required), phone, email, city and
/// sector. Pops the created `CustomerSummary`.
class NewCustomerSheetContent extends StatelessWidget {
  const NewCustomerSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<NewCustomerCubit>();
    final state = context.watch<NewCustomerCubit>().state;
    final noSector = l10n.newCustomerSectorNone;
    final failure = state.failure;
    return BlocListener<NewCustomerCubit, NewCustomerState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ViewStatus.success) {
          Navigator.of(context).pop(state.created!.toSummary());
        } else if (state.failure != null) {
          showFailureSnackBar(context, state.failure!);
        }
      },
      child: FrostedSheetBody(
        title: l10n.newCustomerTitle,
        children: [
          AppTextField(
            label: l10n.newCustomerNameLabel,
            hint: l10n.newCustomerNameHint,
            onChanged: cubit.nameChanged,
            height: CustomerDimens.formFieldHeight,
          ),
          const SizedBox(height: AppSpacing.s12),
          AppTextField(
            label: l10n.mobileNumber,
            keyboardType: TextInputType.phone,
            onChanged: cubit.phoneChanged,
            height: CustomerDimens.formFieldHeight,
          ),
          const SizedBox(height: AppSpacing.s12),
          AppTextField(
            label: l10n.email,
            keyboardType: TextInputType.emailAddress,
            onChanged: cubit.emailChanged,
            height: CustomerDimens.formFieldHeight,
          ),
          const SizedBox(height: AppSpacing.s12),
          AppTextField(
            label: l10n.city,
            onChanged: cubit.cityChanged,
            height: CustomerDimens.formFieldHeight,
          ),
          const SizedBox(height: AppSpacing.s12),
          AppDropdownField(
            label: l10n.customerSector,
            items: [
              noSector,
              for (final sector in BusinessSector.values)
                sector.localized(l10n),
            ],
            onChanged: (value) =>
                cubit.sectorChanged(value == noSector ? '' : value),
          ),
          if (failure != null) ...[
            const SizedBox(height: AppSpacing.s12),
            Text(
              failure.localized(l10n),
              style: AppTextStyles.caption.restyle(color: AppColors.error),
            ),
          ],
          const SizedBox(height: AppSpacing.s16),
          PrimaryButton(
            label: l10n.newCustomerSave,
            enabled: state.canSubmit,
            onPressed: cubit.submit,
          ),
        ],
      ),
    );
  }
}
