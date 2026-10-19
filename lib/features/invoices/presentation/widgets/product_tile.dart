import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../domain/entities/product.dart';
import '../constants/invoices_dimens.dart';

/// One catalog entry of the add-product sheet: name and unit price; tapping
/// it picks the product.
class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(AppRadius.r16);
    return Semantics(
      button: true,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: shape,
          side: const BorderSide(
            color: AppColors.border,
            width: AppSizes.borderThin,
          ),
        ),
        child: InkWell(
          borderRadius: shape,
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: InvoicesDimens.productTileMinHeight,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s14,
              vertical: AppSpacing.s10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.tajawal(
                      fontSize: InvoicesDimens.productNameSize,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s10),
                Text(
                  context.l10n.amountSar(context.amount(product.unitPrice)),
                  style: AppFonts.tajawal(
                    fontSize: InvoicesDimens.methodLabelSize,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
