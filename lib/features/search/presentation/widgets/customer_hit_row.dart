import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/initials.dart';
import '../../../../shared/widgets/initials_badge.dart';
import '../../../customer/presentation/constants/customer_dimens.dart';
import '../../../customer/presentation/widgets/customer_row_card.dart';
import '../../domain/entities/customer_hit.dart';
import '../extensions/search_navigation.dart';

/// A customer result: initials badge, name, location and open deals.
class CustomerHitRow extends StatelessWidget {
  const CustomerHitRow({super.key, required this.hit});

  final CustomerHit hit;

  @override
  Widget build(BuildContext context) {
    return CustomerRowCard(
      onTap: () => context.openSearchResult(AppRoutes.customer, hit.id),
      leading: InitialsBadge(
        text: initialsOf(hit.name),
        size: CustomerDimens.rowBadgeSize,
        radius: AppRadius.r14,
        fontSize: CustomerDimens.rowBadgeFont,
      ),
      title: hit.name,
      subtitle: hit.location,
      trailing: Text(
        context.l10n.customerOpenDealsCount(context.digits('${hit.openDeals}')),
        style: AppTextStyles.caption,
      ),
    );
  }
}
