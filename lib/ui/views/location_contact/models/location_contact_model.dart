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
  String? code;
  String? city;
  String? state;
  String? mobileNumber;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.code,
    this.city,
    this.state,
    this.mobileNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        code: json["code"],
        city: json["city"],
        state: json["state"],
        mobileNumber: json["mobile_number"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "city": city,
        "state": state,
        "mobile_number": mobileNumber,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
