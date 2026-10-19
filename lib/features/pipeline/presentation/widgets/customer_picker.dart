import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/responsive.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/initials.dart';
import '../../../../shared/widgets/initials_badge.dart';
import '../../../../shared/widgets/labeled_field.dart';
import '../constants/pipeline_dimens.dart';
import '../cubit/new_lead_cubit.dart';
import 'lead_field_box.dart';

/// Customer selector of the new-deal form, with a "new customer" shortcut.
class CustomerPicker extends StatelessWidget {
  const CustomerPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final customer = context.select(
      (NewLeadCubit c) => c.state.defaults!.customer.name,
    );
    return LabeledField(
      label: context.l10n.customerLabel,
      child: LeadFieldBox(
        onTap: () {},
        child: Row(
          children: [
            InitialsBadge(
              text: initialsOf(customer),
              size: PipelineDimens.pickerBadge,
              radius: PipelineDimens.pickerBadgeRadius,
              fontSize: PipelineDimens.pickerBadgeFont,
            ),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
              child: Text(
                customer,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyBold,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    context.screenWidth *
                    PipelineDimens.newCustomerMaxWidthFraction,
              ),
              child: Text(
                context.l10n.newCustomerAction,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.link.restyle(
                  fontSize: PipelineDimens.newCustomerFont,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
