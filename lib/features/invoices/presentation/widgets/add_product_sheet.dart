import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../domain/entities/document_line.dart';
import '../cubit/product_catalog_cubit.dart';
import 'add_product_sheet_content.dart';
import '../../../../shared/widgets/frosted_sheet.dart';

/// Bottom sheet to add a line to the invoice: pick a catalog product or type
/// a custom item. Resolves with the chosen line, or null when dismissed.
Future<DocumentLine?> showAddProductSheet(BuildContext context) {
  return showFrostedSheet<DocumentLine>(
    context,
    builder: (_) => BlocProvider(
      create: (_) => getIt<ProductCatalogCubit>()..load(),
      child: const AddProductSheetContent(),
    ),
  );
}
