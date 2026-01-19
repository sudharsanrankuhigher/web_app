// To parse this JSON data, do
//
//     final getPermissionModel = getPermissionModelFromJson(jsonString);

import 'dart:convert';

GetPermissionModel getPermissionModelFromJson(String str) => GetPermissionModel.fromJson(json.decode(str));

String getPermissionModelToJson(GetPermissionModel data) => json.encode(data.toJson());

class GetPermissionModel {
    bool? success;
    String? message;
    List<String>? data;

    GetPermissionModel({
        this.success,
        this.message,
        this.data,
    });

    factory GetPermissionModel.fromJson(Map<String, dynamic> json) => GetPermissionModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<String>.from(json["data"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
    };
}
