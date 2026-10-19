import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/status_body.dart';
import '../constants/home_dimens.dart';
import '../cubit/home_cubit.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_field.dart';
import '../widgets/home_stat_cards.dart';
import '../widgets/quick_actions.dart';
import '../widgets/sales_card.dart';
import '../widgets/today_tasks.dart';

/// Dashboard: greeting, sales summary, key figures, shortcuts and today's tasks.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final state = context.select((HomeCubit c) => c.state);
    return AppBackground(
      blobs: HomeDimens.blobs,
      child: SafeArea(
        top: false,
        bottom: false,
        child: StatusBody(
          status: state.status,
          failure: state.failure,
          onRetry: context.read<HomeCubit>().load,
          builder: (context) => ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              context.topPad(HomeDimens.topPadding),
              AppSpacing.gutter,
              HomeDimens.bottomPadding,
            ),
            children: const [
              HomeHeader(),
              SizedBox(height: AppSpacing.s16),
              HomeSearchField(),
              SizedBox(height: AppSpacing.s16),
              SalesCard(),
              SizedBox(height: AppSpacing.s16),
              HomeStatCards(),
              SizedBox(height: AppSpacing.s16),
              QuickActions(),
              SizedBox(height: AppSpacing.s16),
              TodayTasks(),
            ],
          ),
        ),
      ),
    );
  }
}
