import 'package:flutter/material.dart';

import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_back_button.dart';
import '../../../../shared/widgets/glass_icon_button.dart';
import '../constants/customer_dimens.dart';

/// Back button, screen title and the options button.
class CustomerTopBar extends StatelessWidget {
  const CustomerTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppBackButton(),
        Flexible(
          child: Text(
            context.l10n.customerProfile,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.title.restyle(
              fontSize: CustomerDimens.barTitleFont,
            ),
          ),
        ),
        GlassIconButton(
          icon: AppIcons.dots,
          fillIcon: true,
          label: context.l10n.options,
          onPressed: () {},
        ),
      ],
    );
  }
}
