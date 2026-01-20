// To parse this JSON data, do
//
//     final getPermissionModel = getPermissionModelFromJson(jsonString);

import 'dart:convert';

GetPermissionModel getPermissionModelFromJson(String str) =>
    GetPermissionModel.fromJson(json.decode(str));

String getPermissionModelToJson(GetPermissionModel data) =>
    json.encode(data.toJson());

class GetPermissionModel {
  bool? success;
  String? message;
  List<Datum>? data;

  GetPermissionModel({
    this.success,
    this.message,
    this.data,
  });

  factory GetPermissionModel.fromJson(Map<String, dynamic> json) =>
      GetPermissionModel(
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
  String? abilityName;
  int? roleId;

  Datum({
    this.abilityName,
    this.roleId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        abilityName: json["ability_name"],
        roleId: json["role_id"],
      );

  Map<String, dynamic> toJson() => {
        "ability_name": abilityName,
        "role_id": roleId,
      };
}
