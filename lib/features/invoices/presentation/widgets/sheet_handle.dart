import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../constants/invoices_dimens.dart';

/// Grab handle centred at the top of a frosted sheet.
class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: InvoicesDimens.handleWidth,
        height: InvoicesDimens.handleHeight,
        decoration: BoxDecoration(
          color: AppColors.switchOff,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );
  }
}
