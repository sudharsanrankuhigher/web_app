// To parse this JSON data, do
//
//     final rolesModel = rolesModelFromJson(jsonString);

import 'dart:convert';

RolesModel rolesModelFromJson(String str) =>
    RolesModel.fromJson(json.decode(str));

String rolesModelToJson(RolesModel data) => json.encode(data.toJson());

class RolesModel {
  bool? success;
  String? message;
  List<Datum>? data;

  RolesModel({
    this.success,
    this.message,
    this.data,
  });

  factory RolesModel.fromJson(Map<String, dynamic> json) => RolesModel(
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
  String? name;
  String? slug;
  int? status;
  dynamic createdAt;
  dynamic updatedAt;

  Datum({
    this.id,
    this.name,
    this.slug,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
