import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/status_body.dart';
import '../constants/customer_dimens.dart';
import '../cubit/section_state.dart';

/// Body of a lazily loaded profile tab: spinner, error with retry, an
/// [emptyText] message, or one row per item.
class CustomerSectionList<T> extends StatelessWidget {
  const CustomerSectionList({
    super.key,
    required this.section,
    required this.onRetry,
    required this.emptyText,
    required this.itemBuilder,
  });

  final SectionState<T> section;
  final VoidCallback onRetry;
  final String emptyText;
  final Widget Function(BuildContext context, T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return StatusBody(
      status: section.status,
      failure: section.failure,
      onRetry: onRetry,
      builder: (context) {
        if (section.items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: CustomerDimens.emptyTopSpace,
            ),
            child: Text(
              emptyText,
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle,
            ),
          );
        }
        return Column(
          children: [
            for (final item in section.items) ...[
              itemBuilder(context, item),
              const SizedBox(height: AppSpacing.s10),
            ],
          ],
        );
      },
    );
  }
}
