import '../../../../core/utils/result.dart';
import '../entities/home_overview.dart';

/// Source of the dashboard data.
abstract interface class HomeRepository {
  Future<Result<HomeOverview>> getOverview();
}
