// To parse this JSON data, do
//
//     final companyModel = companyModelFromJson(jsonString);

import 'dart:convert';

CompanyModel companyModelFromJson(String str) =>
    CompanyModel.fromJson(json.decode(str));

String companyModelToJson(CompanyModel data) => json.encode(data.toJson());

class CompanyModel {
  bool? success;
  String? message;
  List<Datum>? data;

  CompanyModel({
    this.success,
    this.message,
    this.data,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
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
  String? companyName;
  String? clientName;
  String? phone;
  String? altPhoneNo;
  String? state;
  String? city;
  String? gstNo;
  int? projectCount;
  String? companyImage;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.companyName,
    this.clientName,
    this.phone,
    this.altPhoneNo,
    this.state,
    this.city,
    this.gstNo,
    this.projectCount,
    this.companyImage,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        companyName: json["company_name"],
        clientName: json["client_name"],
        phone: json["phone"],
        altPhoneNo: json["alt_phone_no"],
        state: json["state"],
        city: json["city"],
        gstNo: json["gst_no"],
        projectCount: json["project_count"],
        companyImage: json["company_image"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "client_name": clientName,
        "phone": phone,
        "alt_phone_no": altPhoneNo,
        "state": state,
        "city": city,
        "gst_no": gstNo,
        "project_count": projectCount,
        "company_image": companyImage,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
