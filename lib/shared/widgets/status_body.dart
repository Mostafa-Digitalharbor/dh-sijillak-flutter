import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/error/failure.dart';
import '../../core/l10n/failure_l10n.dart';
import '../../core/l10n/l10n.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/view_status.dart';
import 'secondary_button.dart';

/// Shows a spinner while [status] is loading, an error with a retry button on
/// failure, and [builder]'s content otherwise.
class StatusBody extends StatelessWidget {
  const StatusBody({
    super.key,
    required this.status,
    required this.builder,
    this.failure,
    this.onRetry,
  });

  static const double _retryWidth = 200;

  final ViewStatus status;
  final Failure? failure;
  final VoidCallback? onRetry;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ViewStatus.initial:
      case ViewStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      case ViewStatus.failure:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (failure ?? const UnknownFailure()).localized(context.l10n),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle,
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: AppSpacing.s16),
                  SizedBox(
                    width: _retryWidth,
                    child: SecondaryButton(
                      label: context.l10n.retry,
                      onPressed: onRetry,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      case ViewStatus.success:
        return builder(context);
    }
  }
}
