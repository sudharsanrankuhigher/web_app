class ClientModel {
  final int id;
  final String name;
  final String city;
  final String state;
  final String phone;
  final String contactNo;
  final String note;

  bool isSelected; // 🔥 selection flag

  ClientModel({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.phone,
    required this.contactNo,
    required this.note,
    this.isSelected = false,
  });
}
