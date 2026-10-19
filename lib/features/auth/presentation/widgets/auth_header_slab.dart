import 'package:flutter/material.dart';

import '../../../../core/layout/responsive.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../shared/widgets/sijilak_logo.dart';
import '../constants/auth_dimens.dart';

/// White rounded slab at the top of welcome and login: the logo plus
/// whatever sits under it ([child]).
class AuthHeaderSlab extends StatelessWidget {
  const AuthHeaderSlab({
    super.key,
    required this.topPad,
    required this.bottomPad,
    required this.radius,
    required this.logoWidth,
    required this.child,
  });

  /// Design top padding (grows when the status bar is taller).
  final double topPad;
  final double bottomPad;
  final double radius;
  final double logoWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Never wider than the slab's content box on narrow phones.
    final maxLogo = context.screenWidth - 2 * AuthDimens.slabSidePad;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AuthDimens.slabSidePad,
        context.topPad(topPad),
        AuthDimens.slabSidePad,
        bottomPad,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(radius)),
        boxShadow: AppShadows.slab,
      ),
      child: Column(
        children: [
          SijilakLogo(width: logoWidth > maxLogo ? maxLogo : logoWidth),
          child,
        ],
      ),
    );
  }
}
