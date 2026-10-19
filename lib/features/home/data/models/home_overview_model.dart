import '../../domain/entities/home_overview.dart';
import '../../domain/entities/home_summary.dart';
import '../../domain/entities/home_task.dart';
import '../../domain/entities/home_user.dart';

/// Wire format of `GET /home/overview`.
class HomeOverviewModel {
  const HomeOverviewModel({
    required this.user,
    required this.summary,
    required this.tasks,
  });

  factory HomeOverviewModel.fromJson(Map<String, dynamic> json) =>
      HomeOverviewModel(
        user: HomeUserModel.fromJson(json['user'] as Map<String, dynamic>),
        summary: HomeSummaryModel.fromJson(
          json['summary'] as Map<String, dynamic>,
        ),
        tasks: [
          for (final task in json['tasks'] as List)
            HomeTaskModel.fromJson(task as Map<String, dynamic>),
        ],
      );

  final HomeUserModel user;
  final HomeSummaryModel summary;
  final List<HomeTaskModel> tasks;

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'summary': summary.toJson(),
    'tasks': [for (final task in tasks) task.toJson()],
  };

  HomeOverview toEntity() => HomeOverview(
    user: user.toEntity(),
    summary: summary.toEntity(),
    tasks: [for (final task in tasks) task.toEntity()],
  );
}

/// Wire format of the signed-in user.
class HomeUserModel {
  const HomeUserModel({
    required this.id,
    required this.name,
    required this.firstName,
  });

  factory HomeUserModel.fromJson(Map<String, dynamic> json) => HomeUserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    firstName: json['firstName'] as String,
  );

  final String id;
  final String name;
  final String firstName;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'firstName': firstName,
  };

  HomeUser toEntity() => HomeUser(id: id, name: name, firstName: firstName);
}

/// Wire format of the dashboard figures.
class HomeSummaryModel {
  const HomeSummaryModel({
    required this.monthlySales,
    required this.salesGrowthPercent,
    required this.recentSales,
    required this.dueAmount,
    required this.overdueInvoices,
    required this.openDeals,
    required this.expectedDealsValue,
  });

  factory HomeSummaryModel.fromJson(Map<String, dynamic> json) =>
      HomeSummaryModel(
        monthlySales: (json['monthlySales'] as num).toInt(),
        salesGrowthPercent: (json['salesGrowthPercent'] as num).toInt(),
        recentSales: [
          for (final sales in json['recentSales'] as List)
            (sales as num).toInt(),
        ],
        dueAmount: (json['dueAmount'] as num).toInt(),
        overdueInvoices: (json['overdueInvoices'] as num).toInt(),
        openDeals: (json['openDeals'] as num).toInt(),
        expectedDealsValue: (json['expectedDealsValue'] as num).toInt(),
      );

  final int monthlySales;
  final int salesGrowthPercent;
  final List<int> recentSales;
  final int dueAmount;
  final int overdueInvoices;
  final int openDeals;
  final int expectedDealsValue;

  Map<String, dynamic> toJson() => {
    'monthlySales': monthlySales,
    'salesGrowthPercent': salesGrowthPercent,
    'recentSales': recentSales,
    'dueAmount': dueAmount,
    'overdueInvoices': overdueInvoices,
    'openDeals': openDeals,
    'expectedDealsValue': expectedDealsValue,
  };

  HomeSummary toEntity() => HomeSummary(
    monthlySales: monthlySales,
    salesGrowthPercent: salesGrowthPercent,
    recentSales: recentSales,
    dueAmount: dueAmount,
    overdueInvoices: overdueInvoices,
    openDeals: openDeals,
    expectedDealsValue: expectedDealsValue,
  );
}

/// Wire format of one task.
class HomeTaskModel {
  const HomeTaskModel({
    required this.id,
    required this.kind,
    required this.title,
    required this.customerName,
    required this.scheduledAt,
  });

  factory HomeTaskModel.fromJson(Map<String, dynamic> json) => HomeTaskModel(
    id: json['id'] as String,
    kind: HomeTaskKind.values.byName(json['kind'] as String),
    title: json['title'] as String,
    customerName: json['customerName'] as String,
    scheduledAt: DateTime.parse(json['scheduledAt'] as String),
  );

  final String id;
  final HomeTaskKind kind;
  final String title;
  final String customerName;
  final DateTime scheduledAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'title': title,
    'customerName': customerName,
    'scheduledAt': scheduledAt.toIso8601String(),
  };

  HomeTask toEntity() => HomeTask(
    id: id,
    kind: kind,
    title: title,
    customerName: customerName,
    scheduledAt: scheduledAt,
  );
}
