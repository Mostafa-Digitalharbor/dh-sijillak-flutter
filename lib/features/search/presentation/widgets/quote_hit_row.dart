import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/icons/app_icons.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../customer/presentation/widgets/customer_row_card.dart';
import '../../domain/entities/quote_hit.dart';
import '../constants/search_dimens.dart';
import '../extensions/quote_hit_status_style.dart';
import '../extensions/search_navigation.dart';

/// A quote result: number, customer and status pill.
class QuoteHitRow extends StatelessWidget {
  const QuoteHitRow({super.key, required this.hit});

  final QuoteHit hit;

  @override
  Widget build(BuildContext context) {
    return CustomerRowCard(
      onTap: () => context.openSearchResult(AppRoutes.quote, hit.number),
      leading: const IconTile(
        icon: AppIcons.listPlus,
        size: SearchDimens.rowIconTile,
        iconSize: SearchDimens.rowIconSize,
        radius: AppRadius.r14,
      ),
      title: hit.customer,
      subtitle: context.l10n.quoteNo(context.digits('${hit.number}')),
      trailing: StatusPill(
        text: hit.status.label(context),
        background: hit.status.background,
        foreground: hit.status.foreground,
      ),
    );
  }
}
