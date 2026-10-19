import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/status_body.dart';
import '../constants/invoices_dimens.dart';
import '../cubit/product_catalog_cubit.dart';
import 'custom_item_form.dart';
import 'product_tile.dart';
import 'sheet_handle.dart';

/// Scrollable content of the add-product sheet: the catalog to pick from and
/// a form for a custom line. Pops the chosen `DocumentLine`.
class AddProductSheetContent extends StatelessWidget {
  const AddProductSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ProductCatalogCubit>();
    final state = context.watch<ProductCatalogCubit>().state;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.s10,
        AppSpacing.gutter,
        AppSpacing.s30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SheetHandle(),
          const SizedBox(height: AppSpacing.s14),
          Text(
            l10n.addProduct,
            style: AppTextStyles.title.restyle(
              fontSize: InvoicesDimens.sheetTitleSize,
            ),
          ),
          const SizedBox(height: AppSpacing.s14),
          Text(l10n.productCatalogTitle, style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.s8),
          StatusBody(
            status: state.status,
            failure: state.failure,
            onRetry: cubit.load,
            builder: (_) => state.products.isEmpty
                ? Text(l10n.noProducts, style: AppTextStyles.subtitle)
                : Column(
                    children: [
                      for (final product in state.products) ...[
                        ProductTile(
                          product: product,
                          onTap: () =>
                              Navigator.of(context).pop(product.toLine()),
                        ),
                        const SizedBox(height: AppSpacing.s8),
                      ],
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.s10),
          Text(l10n.customItemTitle, style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.s8),
          CustomItemForm(onSubmit: (line) => Navigator.of(context).pop(line)),
        ],
      ),
    );
  }
}
