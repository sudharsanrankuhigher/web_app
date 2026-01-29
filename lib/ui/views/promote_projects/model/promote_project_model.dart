class ProjectModel {
  final int id;

  final String projectCode;
  final String clientName;
  final String companyName;
  final String projectTitle;

  final String gender;
  final String state;
  final String city;
  final String service;

  List<dynamic> influencers;
  final List<String> projectImages;

  final String note;

  final double payment;
  final double commission;

  bool isCompleted;
  final DateTime assignedDate;
  DateTime? completedDate;

  bool isSelected;

  ProjectModel({
    required this.id,
    required this.projectCode,
    required this.clientName,
    required this.companyName,
    required this.projectTitle,
    required this.gender,
    required this.state,
    required this.city,
    required this.service,
    required this.influencers,
    required this.projectImages,
    required this.note,
    required this.payment,
    required this.commission,
    required this.isCompleted,
    required this.assignedDate,
    this.completedDate,
    this.isSelected = false,
  });

  ProjectModel copyWith({
    String? note,
    double? payment,
    double? commission,
    List<String>? projectImages,
    List<String>? influencers,
    bool? isCompleted,
    DateTime? completedDate,
    required String projectCode,
    required String companyName,
    required String service,
    required String gender,
    required String state,
    required String city,
  }) {
    return ProjectModel(
      id: id,
      projectCode: projectCode,
      clientName: clientName,
      companyName: companyName,
      projectTitle: projectTitle,
      gender: gender,
      state: state,
      city: city,
      service: service,
      influencers: influencers ?? this.influencers,
      projectImages: projectImages ?? this.projectImages,
      note: note ?? this.note,
      payment: payment ?? this.payment,
      commission: commission ?? this.commission,
      isCompleted: isCompleted ?? this.isCompleted,
      assignedDate: assignedDate,
      completedDate: completedDate ?? this.completedDate,
      isSelected: isSelected,
    );
  }

  factory ProjectModel.empty(int id) {
    return ProjectModel(
      id: id,
      projectCode: '',
      clientName: '',
      companyName: '',
      projectTitle: '',
      gender: '',
      state: '',
      city: '',
      service: '',
      influencers: [],
      note: '',
      payment: 0,
      commission: 0,
      projectImages: [],
      assignedDate: DateTime.now(),
      isCompleted: true,
    );
  }
}
