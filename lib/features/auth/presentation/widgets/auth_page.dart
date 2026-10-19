import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../shared/widgets/app_background.dart';
import '../constants/auth_dimens.dart';

/// Welcome / login frame: a [header] slab over a [body] whose last widgets
/// are pushed to the bottom (a `Spacer` in [body]) when the screen is tall,
/// and which scrolls as a whole when it is not.
class AuthPage extends StatelessWidget {
  const AuthPage({
    super.key,
    required this.blobs,
    required this.header,
    required this.bodyBottomPad,
    required this.body,
  });

  final List<BackgroundBlob> blobs;
  final Widget header;
  final double bodyBottomPad;

  /// Children of the body column (may contain a `Spacer`).
  final List<Widget> body;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      blobs: blobs,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: header),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.gutter,
                AuthDimens.bodyTopPad,
                AppSpacing.gutter,
                context.bottomPad(bodyBottomPad),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
