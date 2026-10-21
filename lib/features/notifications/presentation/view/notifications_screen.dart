import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/failure_snack_bar.dart';
import '../../../../shared/widgets/screen_header.dart';
import '../../../../shared/widgets/status_body.dart';
import '../constants/notifications_dimens.dart';
import '../cubit/notifications_cubit.dart';
import '../widgets/mark_all_read_button.dart';
import '../widgets/notifications_list.dart';

/// Full-screen list of notifications grouped by day.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationsCubit>()..load(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();
    final state = context.watch<NotificationsCubit>().state;
    return BlocListener<NotificationsCubit, NotificationsState>(
      listenWhen: (previous, current) =>
          current.actionFailure != null &&
          previous.actionFailure != current.actionFailure,
      listener: (context, state) =>
          showFailureSnackBar(context, state.actionFailure!),
      child: AppBackground(
        blobs: NotificationsDimens.blobs,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              context.topPad(NotificationsDimens.topPadding),
              AppSpacing.gutter,
              0,
            ),
            child: Column(
              children: [
                ScreenHeader(
                  title: context.l10n.notifications,
                  trailing: const MarkAllReadButton(),
                ),
                Expanded(
                  child: StatusBody(
                    status: state.status,
                    failure: state.failure,
                    onRetry: cubit.load,
                    builder: (_) =>
                        NotificationsList(notifications: state.notifications),
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
