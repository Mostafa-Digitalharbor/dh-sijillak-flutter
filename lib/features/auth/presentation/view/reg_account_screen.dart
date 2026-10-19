import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/failure_snack_bar.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../constants/auth_blobs.dart';
import '../constants/auth_dimens.dart';
import '../cubit/account_cubit.dart';
import '../cubit/registration_cubit.dart';
import '../widgets/password_strength_field.dart';
import '../widgets/phone_number_field.dart';
import '../widgets/reg_step_scaffold.dart';
import '../widgets/terms_checkbox_row.dart';

/// Registration step 2: the owner's account details.
class RegAccountScreen extends StatelessWidget {
  const RegAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AccountCubit>(),
      child: const _RegAccountView(),
    );
  }
}

class _RegAccountView extends StatelessWidget {
  const _RegAccountView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final registration = context.read<RegistrationCubit>();
    final sending = context.select(
      (AccountCubit c) => c.state.status.isLoading,
    );
    final termsAccepted = context.select(
      (RegistrationCubit c) => c.state.draft.termsAccepted,
    );
    const gap = SizedBox(height: AuthDimens.fieldGap);
    return BlocListener<AccountCubit, AccountState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSuccess) context.push(AppRoutes.regOtp);
        final failure = state.failure;
        if (state.status.isFailure && failure != null) {
          showFailureSnackBar(context, failure);
        }
      },
      child: RegStepScaffold(
        step: 2,
        title: l10n.accountTitle,
        subtitle: l10n.accountSubtitle,
        nextLabel: l10n.sendOtp,
        nextEnabled: termsAccepted && !sending,
        onNext: () => context.read<AccountCubit>().sendOtp(
          registration.state.draft.phone,
        ),
        blobs: AuthBlobs.account,
        children: [
          GlassCard(
            child: Column(
              children: [
                AppTextField(
                  label: l10n.fullName,
                  hint: l10n.fullNameHint,
                  onChanged: (value) =>
                      registration.edit((d) => d.copyWith(ownerName: value)),
                ),
                gap,
                AppTextField(
                  label: l10n.workEmail,
                  hint: l10n.authEmailHint,
                  keyboardType: TextInputType.emailAddress,
                  ltr: true,
                  onChanged: (value) =>
                      registration.edit((d) => d.copyWith(email: value)),
                ),
                gap,
                PhoneNumberField(
                  onChanged: (value) =>
                      registration.edit((d) => d.copyWith(phone: value)),
                ),
                gap,
                const PasswordStrengthField(),
                gap,
                const TermsCheckboxRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
