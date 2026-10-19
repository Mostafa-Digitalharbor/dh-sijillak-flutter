import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../constants/invoices_dimens.dart';

/// Square "+" / "-" button of the [QuantityStepper].
class QuantityStepButton extends StatelessWidget {
  const QuantityStepButton({
    super.key,
    required this.glyph,
    required this.label,
    required this.onTap,
  });

  final String glyph;

  /// Accessibility label.
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(InvoicesDimens.stepperRadius);
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: Colors.white,
        borderRadius: shape,
        child: InkWell(
          borderRadius: shape,
          onTap: onTap,
          child: SizedBox(
            width: InvoicesDimens.stepperButton,
            height: InvoicesDimens.stepperButton,
            child: Center(
              child: Text(
                glyph,
                style: AppFonts.tajawal(
                  fontSize: InvoicesDimens.stepperGlyphSize,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
