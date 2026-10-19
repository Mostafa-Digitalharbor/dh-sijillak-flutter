import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../domain/entities/invoice_period.dart';
import '../constants/invoices_dimens.dart';
import '../extensions/invoice_l10n.dart';

/// Pill showing the reporting period; tapping it opens a menu to change it.
class InvoicesPeriodButton extends StatelessWidget {
  const InvoicesPeriodButton({
    super.key,
    required this.period,
    required this.onSelected,
  });

  static const double _labelSize = 14;

  final InvoicePeriod period;
  final ValueChanged<InvoicePeriod> onSelected;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppRadius.r14);
    return Material(
      color: AppColors.white72,
      shape: RoundedRectangleBorder(
        borderRadius: shape,
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      child: PopupMenuButton<InvoicePeriod>(
        tooltip: context.l10n.selectPeriod,
        initialValue: period,
        onSelected: onSelected,
        borderRadius: shape,
        shape: RoundedRectangleBorder(borderRadius: shape),
        color: Colors.white,
        padding: EdgeInsets.zero,
        itemBuilder: (_) => [
          for (final option in InvoicePeriod.values)
            PopupMenuItem(
              value: option,
              child: Text(
                option.localized(context),
                style: AppFonts.tajawal(
                  fontSize: _labelSize,
                  fontWeight: option == period
                      ? FontWeight.w800
                      : FontWeight.w600,
                  color: option == period ? AppColors.primary : AppColors.ink,
                ),
              ),
            ),
        ],
        child: Container(
          constraints: const BoxConstraints(
            minHeight: InvoicesDimens.periodButtonHeight,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppIcon(
                AppIcons.calendar,
                size: InvoicesDimens.periodIconSize,
                color: AppColors.ink,
              ),
              const SizedBox(width: AppSpacing.s6),
              Flexible(
                child: Text(
                  period.localized(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.tajawal(
                    fontSize: _labelSize,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
