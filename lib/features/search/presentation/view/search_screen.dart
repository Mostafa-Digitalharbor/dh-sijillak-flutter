import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../shared/widgets/app_background.dart';
import '../constants/search_dimens.dart';
import '../cubit/search_cubit.dart';
import '../widgets/search_body.dart';
import '../widgets/search_header.dart';

/// Full-screen global search over customers, deals, invoices and quotes.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>()..load(),
      child: AppBackground(
        blobs: SearchDimens.blobs,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              context.topPad(SearchDimens.topPadding),
              AppSpacing.gutter,
              0,
            ),
            child: const Column(
              children: [
                SearchHeader(),
                SizedBox(height: AppSpacing.s16),
                Expanded(child: SearchBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
