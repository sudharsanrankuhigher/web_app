class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String type;
  final String city;
  final String state;
  final String plan;
  final int connections;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.type,
      required this.city,
      required this.state,
      required this.plan,
      required this.connections,
      required this.id});
}
