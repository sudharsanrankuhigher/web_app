class ProjectModel {
  final int id;
  final String projectCode;
  final String clientName;
  final String projectTitle;
  final String note;
  final List<String> influencerImages;
  bool isCompleted;
  final DateTime assignedDate;

  bool isSelected;

  ProjectModel({
    required this.id,
    required this.projectCode,
    required this.clientName,
    required this.projectTitle,
    required this.note,
    required this.influencerImages,
    required this.isCompleted,
    required this.assignedDate,
    this.isSelected = false,
  });
}
