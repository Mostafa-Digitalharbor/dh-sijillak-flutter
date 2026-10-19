import 'dart:ui';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/invoice_summary.dart';

/// Pill colours of each [InvoiceStatus].
extension InvoiceStatusStyle on InvoiceStatus {
  Color get background => switch (this) {
    InvoiceStatus.paid => AppColors.paidBg,
    InvoiceStatus.due => AppColors.dueBg,
    InvoiceStatus.late => AppColors.overdueBg,
  };

  Color get foreground => switch (this) {
    InvoiceStatus.paid => AppColors.primary,
    InvoiceStatus.due => AppColors.dueFg,
    InvoiceStatus.late => AppColors.error,
  };
}
