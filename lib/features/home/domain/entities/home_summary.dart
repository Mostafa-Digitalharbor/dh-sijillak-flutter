import 'dart:math' as math;

import 'package:equatable/equatable.dart';

/// Headline numbers shown on the dashboard.
class HomeSummary extends Equatable {
  const HomeSummary({
    required this.monthlySales,
    required this.salesGrowthPercent,
    required this.recentSales,
    required this.dueAmount,
    required this.overdueInvoices,
    required this.openDeals,
    required this.expectedDealsValue,
  });

  final int monthlySales;
  final int salesGrowthPercent;

  /// Sales amount of each of the last periods, oldest first (the mini chart).
  final List<int> recentSales;
  final int dueAmount;
  final int overdueInvoices;
  final int openDeals;
  final int expectedDealsValue;

  /// [recentSales] scaled to 0-1 against the largest period.
  List<double> get salesBarFractions {
    final peak = recentSales.fold<int>(0, math.max);
    if (peak <= 0) return [for (final _ in recentSales) 0];
    return [for (final sales in recentSales) sales / peak];
  }

  @override
  List<Object?> get props => [
    monthlySales,
    salesGrowthPercent,
    recentSales,
    dueAmount,
    overdueInvoices,
    openDeals,
    expectedDealsValue,
  ];
}
