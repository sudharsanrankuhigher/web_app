class SubAdminModel {
  final int sNo;
  final String name;
  final String phone;
  final String email;
  final String gender;
  final DateTime dob;

  String state;
  String city;

  final List<String> access;

  final String imageUrl; // profile image
  final String idImageUrl;

  final DateTime? loginTime;
  final DateTime? logoutTime;
  final DateTime? onlineAt;

  final bool isActive;

  SubAdminModel({
    required this.sNo,
    required this.name,
    required this.phone,
    required this.email,
    required this.gender,
    required this.dob,
    required this.state,
    required this.city,
    required this.access,
    required this.imageUrl,
    required this.idImageUrl,
    this.loginTime,
    this.logoutTime,
    this.onlineAt,
    required this.isActive,
  });
}
