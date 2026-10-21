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
import '../../../customer/domain/entities/customer_summary.dart';
import '../../../customer/presentation/widgets/customer_picker_sheet.dart';
import '../../../customer/presentation/widgets/new_customer_sheet.dart';
import '../../domain/entities/lead_party.dart';
import '../constants/pipeline_dimens.dart';
import '../cubit/new_lead_cubit.dart';
import 'lead_field_box.dart';

/// Customer selector of the new-deal form: tapping it opens the customer
/// picker, and the "new customer" shortcut opens the new-customer form and
/// selects the customer it creates.
class CustomerPicker extends StatelessWidget {
  const CustomerPicker({super.key});

  static LeadParty _party(CustomerSummary customer) => LeadParty(
    id: customer.id,
    name: customer.name,
    subtitle: customer.location.isEmpty ? null : customer.location,
  );

  static Future<void> _pick(BuildContext context) async {
    final cubit = context.read<NewLeadCubit>();
    final customer = await showCustomerPickerSheet(context);
    if (customer != null) cubit.selectCustomer(_party(customer));
  }

  static Future<void> _create(BuildContext context) async {
    final cubit = context.read<NewLeadCubit>();
    final customer = await showNewCustomerSheet(context);
    if (customer != null) cubit.selectCustomer(_party(customer));
  }

  @override
  Widget build(BuildContext context) {
    final customer = context.select((NewLeadCubit c) => c.state.customer!);
    return LabeledField(
      label: context.l10n.customerLabel,
      child: LeadFieldBox(
        onTap: () => _pick(context),
        child: Row(
          children: [
            InitialsBadge(
              text: initialsOf(customer.name),
              size: PipelineDimens.pickerBadge,
              radius: PipelineDimens.pickerBadgeRadius,
              fontSize: PipelineDimens.pickerBadgeFont,
            ),
            const SizedBox(width: AppSpacing.s10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyBold,
                  ),
                  if (customer.subtitle != null)
                    Text(
                      customer.subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption,
                    ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    context.screenWidth *
                    PipelineDimens.newCustomerMaxWidthFraction,
              ),
              child: InkWell(
                onTap: () => _create(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
                  child: Text(
                    context.l10n.newCustomerAction,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.link.restyle(
                      fontSize: PipelineDimens.newCustomerFont,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
