class CityModel {
  final int id;
  final String name;
  final String state;

  CityModel({required this.id, required this.name, required this.state});

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
        name: json['name'],
        state: json['state'],
      );
}
