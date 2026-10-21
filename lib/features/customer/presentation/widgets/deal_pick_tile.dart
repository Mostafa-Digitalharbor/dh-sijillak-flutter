import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../shared/widgets/picker_tile.dart';
import '../../../pipeline/presentation/extensions/deal_stage_l10n.dart';
import '../../domain/entities/customer_deal.dart';
import '../constants/customer_dimens.dart';

/// One open deal in the deal picker: title, stage and expected value.
class DealPickTile extends StatelessWidget {
  const DealPickTile({super.key, required this.deal, required this.onTap});

  final CustomerDeal deal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PickerTile(
      title: deal.title,
      subtitle: deal.stage.localized(context),
      onTap: onTap,
      trailing: Text(
        context.l10n.amountSar(context.amount(deal.value)),
        style: AppFonts.tajawal(
          fontSize: CustomerDimens.pickValueFont,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
