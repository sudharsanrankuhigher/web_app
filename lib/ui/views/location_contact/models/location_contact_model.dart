// To parse this JSON data, do
//
//     final locationContactModel = locationContactModelFromJson(jsonString);

import 'dart:convert';

LocationContactModel locationContactModelFromJson(String str) =>
    LocationContactModel.fromJson(json.decode(str));

String locationContactModelToJson(LocationContactModel data) =>
    json.encode(data.toJson());

class LocationContactModel {
  int? status;
  String? message;
  List<Datum>? data;

  LocationContactModel({
    this.status,
    this.message,
    this.data,
  });

  factory LocationContactModel.fromJson(Map<String, dynamic> json) =>
      LocationContactModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  List<City>? city;
  String? state;
  String? mobileNumber;
  int? isHeadOffice;
  DateTime? createdAt;
  bool? isHeadoffice;

  Datum({
    this.id,
    this.city,
    this.state,
    this.isHeadOffice,
    this.mobileNumber,
    this.createdAt,
    this.isHeadoffice,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    bool? parseBool(dynamic val) {
      if (val == null) return null;
      if (val is bool) return val;
      if (val is int) return val == 1;
      final str = val.toString().toLowerCase().trim();
      return str == '1' || str == 'true';
    }

    final rawHeadOffice =
        json["head_office"] ?? json["is_head_office"] ?? json["isheadoffice"];
    final parsedIsHeadOffice = parseBool(rawHeadOffice) ?? false;

    return Datum(
      id: json["id"],
      city: json["city"] == null
          ? []
          : List<City>.from(json["city"]!.map((x) => City.fromJson(x))),
      state: json["state"],
      mobileNumber: json["mobile_number"] == null
          ? null
          : json["mobile_number"] is List
              ? (json["mobile_number"] as List).join(", ")
              : json["mobile_number"].toString(),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.tryParse(json["created_at"].toString()),
      isHeadOffice: parsedIsHeadOffice ? 1 : 0,
      isHeadoffice: parsedIsHeadOffice,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "city": city == null
            ? []
            : List<dynamic>.from(city!.map((x) => x.toJson())),
        "state": state,
        "mobile_number": mobileNumber,
        "created_at": createdAt?.toIso8601String(),
        "head_office": isHeadOffice,
        "isheadoffice": isHeadoffice,
      };
}

class City {
  String? id;
  String? name;

  City({
    this.id,
    this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
