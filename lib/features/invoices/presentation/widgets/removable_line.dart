import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../domain/entities/document_line.dart';
import '../constants/invoices_dimens.dart';

/// Lets the user swipe an invoice [line] away (or use the accessibility
/// "remove" action) while [removable]; otherwise it shows [child] as is.
/// At rest the child looks exactly the same either way.
class RemovableLine extends StatelessWidget {
  const RemovableLine({
    super.key,
    required this.line,
    required this.removable,
    required this.onRemove,
    required this.child,
  });

  final DocumentLine line;
  final bool removable;
  final VoidCallback onRemove;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!removable) return child;
    final l10n = context.l10n;
    return Semantics(
      customSemanticsActions: {
        CustomSemanticsAction(label: l10n.removeLine): onRemove,
      },
      child: Dismissible(
        key: ObjectKey(line),
        onDismissed: (_) => onRemove(),
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s18),
          decoration: BoxDecoration(
            color: AppColors.overdueBg,
            borderRadius: BorderRadius.circular(AppRadius.r18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [_RemoveHint(), _RemoveHint()],
          ),
        ),
        child: child,
      ),
    );
  }
}

class _RemoveHint extends StatelessWidget {
  const _RemoveHint();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppIcon(
          AppIcons.close,
          size: InvoicesDimens.removeIconSize,
          color: AppColors.overdue,
        ),
        const SizedBox(width: AppSpacing.s6),
        Text(
          context.l10n.delete,
          style: AppFonts.tajawal(
            fontSize: InvoicesDimens.removeLabelSize,
            fontWeight: FontWeight.w800,
            color: AppColors.overdue,
          ),
        ),
      ],
    );
  }
}
