import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/app_back_button.dart';
import 'search_input_field.dart';

/// Back button and the query box.
class SearchHeader extends StatelessWidget {
  const SearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        AppBackButton(),
        SizedBox(width: AppSpacing.s12),
        Expanded(child: SearchInputField()),
      ],
    );
  }
}
