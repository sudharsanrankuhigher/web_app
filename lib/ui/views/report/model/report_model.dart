class ReportModel {
  final String project;
  final String influencer;
  final String client;
  final String amount;
  final String status;
  final String note;
  final String date;

  ReportModel({
    required this.amount,
    required this.client,
    required this.date,
    required this.influencer,
    required this.note,
    required this.project,
    required this.status,
  });
}
