class CityModel {
  final String id;
  final String name;
  final String state;

  CityModel({required this.id, required this.name, required this.state});

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        id: json['id'],
        name: json['name'],
        state: json['state'],
      );
}
