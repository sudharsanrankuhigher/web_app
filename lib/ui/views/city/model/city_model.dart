// To parse this JSON data, do
//
//     final cityShowModel = cityShowModelFromJson(jsonString);

import 'dart:convert';

CityShowModel cityShowModelFromJson(String str) =>
    CityShowModel.fromJson(json.decode(str));

String cityShowModelToJson(CityShowModel data) => json.encode(data.toJson());

class CityShowModel {
  bool? success;
  String? message;
  List<Datum>? data;

  CityShowModel({
    this.success,
    this.message,
    this.data,
  });

  factory CityShowModel.fromJson(Map<String, dynamic> json) => CityShowModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  int? stateId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? stateName;

  Datum({
    this.id,
    this.stateId,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.stateName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        stateId: json["state_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        name: json["name"],
        stateName: (json["state_name"] == null) ? null : json["state_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state_id": stateId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "name": name,
        "state_name": stateName,
      };
}
