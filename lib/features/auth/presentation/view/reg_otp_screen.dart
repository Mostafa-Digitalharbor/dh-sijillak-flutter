import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/layout/screen_insets.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/app_background.dart';
import '../../../../shared/widgets/failure_snack_bar.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/step_header.dart';
import '../constants/auth_blobs.dart';
import '../constants/auth_dimens.dart';
import '../cubit/otp_cubit.dart';
import '../cubit/registration_cubit.dart';
import '../widgets/otp_code_boxes.dart';
import '../widgets/otp_intro.dart';
import '../widgets/otp_keypad.dart';
import '../widgets/otp_resend_line.dart';
import '../widgets/scroll_fill_view.dart';

/// Registration step 3: verify the mobile number with a one-time code.
class RegOtpScreen extends StatelessWidget {
  const RegOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OtpCubit>(
        param1: context.read<RegistrationCubit>().state.draft.phone,
      ),
      child: const _RegOtpView(),
    );
  }
}

class _RegOtpView extends StatelessWidget {
  const _RegOtpView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OtpCubit>().state;
    final phone = context.select((RegistrationCubit c) => c.state.draft.phone);
    return BlocListener<OtpCubit, OtpState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSuccess) context.push(AppRoutes.regTax);
        final failure = state.failure;
        if (state.status.isFailure && failure != null) {
          showFailureSnackBar(context, failure);
        }
      },
      child: AppBackground(
        blobs: AuthBlobs.otp,
        child: SafeArea(
          top: false,
          bottom: false,
          child: ScrollFillView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              context.topPad(AuthDimens.regTopPad),
              AppSpacing.gutter,
              context.bottomPad(AuthDimens.otpBottomPad),
            ),
            child: Column(
              children: [
                const StepHeader(step: 3),
                const SizedBox(height: AppSpacing.s20),
                OtpIntro(phone: phone),
                const SizedBox(height: AppSpacing.s20),
                OtpCodeBoxes(code: state.code),
                const SizedBox(height: AppSpacing.s20),
                OtpResendLine(secondsLeft: state.secondsLeft),
                const Spacer(),
                PrimaryButton(
                  label: context.l10n.verifyAndContinue,
                  enabled: state.isComplete && !state.status.isLoading,
                  onPressed: context.read<OtpCubit>().verify,
                ),
                const SizedBox(height: AppSpacing.s20),
                const OtpKeypad(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
