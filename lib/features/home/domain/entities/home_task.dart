import 'package:equatable/equatable.dart';

enum HomeTaskKind { call, meeting }

/// One entry of "today's tasks".
class HomeTask extends Equatable {
  const HomeTask({
    required this.id,
    required this.kind,
    required this.title,
    required this.customerName,
    required this.scheduledAt,
  });

  final String id;
  final HomeTaskKind kind;
  final String title;
  final String customerName;
  final DateTime scheduledAt;

  @override
  List<Object?> get props => [id, kind, title, customerName, scheduledAt];
}
