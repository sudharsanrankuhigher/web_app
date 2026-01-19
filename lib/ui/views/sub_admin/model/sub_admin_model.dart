// To parse this JSON data, do
//
//     final subAdminModel = subAdminModelFromJson(jsonString);

import 'dart:convert';

SubAdminModel subAdminModelFromJson(String str) =>
    SubAdminModel.fromJson(json.decode(str));

String subAdminModelToJson(SubAdminModel data) => json.encode(data.toJson());

class SubAdminModel {
  int? success;
  String? message;
  List<Datum>? data;

  SubAdminModel({
    this.success,
    this.message,
    this.data,
  });

  factory SubAdminModel.fromJson(Map<String, dynamic> json) => SubAdminModel(
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
  int? roleId;
  String? name;
  String? email;
  String? password;
  String? mobileNumber;
  String? gender;
  DateTime? dateOfBirth;
  String? state;
  String? city;
  String? profileImage;
  String? docImg;
  int? status;
  String? loginTime;
  String? logoutTime;
  int? isOnline;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.roleId,
    this.name,
    this.email,
    this.password,
    this.mobileNumber,
    this.gender,
    this.dateOfBirth,
    this.state,
    this.city,
    this.profileImage,
    this.docImg,
    this.status,
    this.loginTime,
    this.logoutTime,
    this.isOnline,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] ?? 0, // default 0 if missing
        roleId: json["role_id"] ?? 0,
        name: json["name"] ?? '',
        email: json["email"] ?? '',
        password: json["password"] ?? '',
        mobileNumber: json["mobile_number"] ?? '',
        gender: json["gender"] ?? '',
        dateOfBirth:
            json["date_of_birth"] == null || json["date_of_birth"].isEmpty
                ? null
                : DateTime.tryParse(json["date_of_birth"]),
        state: json["state"] ?? '',
        city: json["city"] ?? '',
        profileImage: json["profile_image"] ?? '',
        docImg: json["doc_img"] ?? '',
        status: json["status"] ?? '',
        loginTime: json["login_time"] ?? '',
        logoutTime: json["logout_time"] ?? '',
        isOnline: json["is_online"] ?? false,
        createdAt: json["created_at"] == null || json["created_at"].isEmpty
            ? null
            : DateTime.tryParse(json["created_at"]),
        updatedAt: json["updated_at"] == null || json["updated_at"].isEmpty
            ? null
            : DateTime.tryParse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "name": name,
        "email": email,
        "password": password,
        "mobile_number": mobileNumber,
        "gender": gender,
        "date_of_birth":
            "${dateOfBirth!.year.toString().padLeft(4, '0')}-${dateOfBirth!.month.toString().padLeft(2, '0')}-${dateOfBirth!.day.toString().padLeft(2, '0')}",
        "state": state,
        "city": city,
        "profile_image": profileImage,
        "doc_img": docImg,
        "status": status,
        "login_time": loginTime,
        "logout_time": logoutTime,
        "is_online": isOnline,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
