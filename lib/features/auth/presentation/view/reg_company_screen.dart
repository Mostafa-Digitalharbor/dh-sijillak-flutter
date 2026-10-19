import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/app_dropdown_field.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/entities/business_sector.dart';
import '../constants/auth_blobs.dart';
import '../cubit/company_cubit.dart';
import '../cubit/registration_cubit.dart';
import '../extensions/business_sector_l10n.dart';
import '../widgets/reg_step_scaffold.dart';
import '../widgets/workspace_handle_field.dart';
import '../widgets/workspace_handle_preview.dart';

/// Registration step 1: company name, sector and workspace link.
class RegCompanyScreen extends StatelessWidget {
  const RegCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CompanyCubit>(),
      child: const _RegCompanyView(),
    );
  }
}

class _RegCompanyView extends StatelessWidget {
  const _RegCompanyView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final registration = context.read<RegistrationCubit>();
    final taken = context.select(
      (CompanyCubit c) => c.state.status == HandleStatus.taken,
    );
    final sectors = [for (final s in BusinessSector.values) s.localized(l10n)];
    return RegStepScaffold(
      step: 1,
      title: l10n.companyTitle,
      subtitle: l10n.companySubtitle,
      nextLabel: l10n.continueLabel,
      nextEnabled: !taken,
      onNext: () => context.push(AppRoutes.regAccount),
      blobs: AuthBlobs.company,
      children: [
        GlassCard(
          child: Column(
            children: [
              AppTextField(
                label: l10n.companyName,
                hint: l10n.companyNameHint,
                onChanged: (value) =>
                    registration.edit((d) => d.copyWith(companyName: value)),
              ),
              const SizedBox(height: AppSpacing.s16),
              AppDropdownField(
                label: l10n.companySector,
                items: sectors,
                onChanged: (value) => registration.edit(
                  (d) => d.copyWith(
                    sector: BusinessSector.values[sectors.indexOf(value)],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s16),
              const WorkspaceHandleField(),
            ],
          ),
        ),
        const WorkspaceHandlePreview(),
      ],
    );
  }
}
