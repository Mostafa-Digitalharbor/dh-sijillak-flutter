import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/section_heading.dart';
import '../../../../shared/widgets/step_header.dart';
import '../constants/auth_dimens.dart';
import 'reg_action_bar.dart';

/// Shared frame of the registration steps: step header, title, scrolling
/// content and the pinned next button.
class RegStepScaffold extends StatelessWidget {
  const RegStepScaffold({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.nextLabel,
    required this.onNext,
    required this.children,
    required this.blobs,
    this.actionLabel,
    this.onAction,
    this.nextEnabled = true,
    this.gap = AuthDimens.regGap,
  });

  final int step;
  final String title;
  final String subtitle;
  final String nextLabel;
  final VoidCallback onNext;
  final List<Widget> children;
  final List<BackgroundBlob> blobs;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// False while the step cannot continue (invalid input or request running).
  final bool nextEnabled;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      blobs: blobs,
      bottomBar: RegActionBar(
        label: nextLabel,
        enabled: nextEnabled,
        onPressed: onNext,
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            context.topPad(AuthDimens.regTopPad),
            AppSpacing.gutter,
            AppSizes.bottomBarClearance,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StepHeader(
                step: step,
                actionLabel: actionLabel,
                onAction: onAction,
              ),
              SizedBox(height: gap),
              SectionHeading(title: title, subtitle: subtitle),
              SizedBox(height: gap),
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) SizedBox(height: gap),
                children[i],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
