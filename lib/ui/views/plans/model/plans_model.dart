class PlanModel {
  final int id;
  final String planName;
  final int connections;
  final int amount;
  final String badge; // Custom badge text

  PlanModel({
    required this.id,
    required this.planName,
    required this.connections,
    required this.amount,
    required this.badge,
  });
}
