import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/notification_day_bucket.dart';
import '../constants/notifications_dimens.dart';
import '../extensions/notification_l10n.dart';

/// Title above the notifications of one day bucket.
class NotificationGroupHeading extends StatelessWidget {
  const NotificationGroupHeading({super.key, required this.bucket});

  final NotificationDayBucket bucket;

  @override
  Widget build(BuildContext context) {
    return Text(
      bucket.label(context),
      style: AppTextStyles.label.restyle(
        fontSize: NotificationsDimens.groupHeadingSize,
        fontWeight: FontWeight.w800,
        color: AppColors.textSubtle,
      ),
    );
  }
}
