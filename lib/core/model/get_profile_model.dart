// To parse this JSON data, do
//
//     final getAdminProfileResponse = getAdminProfileResponseFromJson(jsonString);

import 'dart:convert';

GetAdminProfileResponse getAdminProfileResponseFromJson(String str) =>
    GetAdminProfileResponse.fromJson(json.decode(str));

String getAdminProfileResponseToJson(GetAdminProfileResponse data) =>
    json.encode(data.toJson());

class GetAdminProfileResponse {
  int? status;
  String? message;
  Data? data;

  GetAdminProfileResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetAdminProfileResponse.fromJson(Map<String, dynamic> json) =>
      GetAdminProfileResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  int? roleId;
  String? name;
  String? email;
  String? mobileNumber;
  dynamic profilePic;
  DateTime? createdAt;
  DateTime? updatedAt;

  Data({
    this.id,
    this.roleId,
    this.name,
    this.email,
    this.mobileNumber,
    this.profilePic,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        roleId: json["role_id"],
        name: json["name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        profilePic: json["profile_pic"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "name": name,
        "email": email,
        "mobile_number": mobileNumber,
        "profile_pic": profilePic,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
