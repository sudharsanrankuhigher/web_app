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
  BankDetail? bankDetails;
  int? projectCount;
  String? companyImage;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum(
      {this.id,
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
      this.bankDetails});

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
        bankDetails: _parseBankDetails(json["bank_details"]),
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
        "bank_details": bankDetails,
        "project_count": projectCount,
        "company_image": companyImage,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  static BankDetail? _parseBankDetails(dynamic data) {
    if (data == null) return null;

    // Case 1: List
    if (data is List && data.isNotEmpty) {
      if (data.first is Map<String, dynamic>) {
        return BankDetail.fromJson(data.first);
      }
    }

    // Case 2: Direct Map
    if (data is Map<String, dynamic>) {
      return BankDetail.fromJson(data);
    }

    return null;
  }
}

class BankDetail {
  String? accountName;
  String? accountNo;
  String? ifscCode;
  String? upi;

  BankDetail({
    this.accountName,
    this.accountNo,
    this.ifscCode,
    this.upi,
  });

  factory BankDetail.fromJson(Map<String, dynamic> json) {
    return BankDetail(
      accountName: json['holder_name']?.toString(),
      accountNo: json['account_no']?.toString(),
      ifscCode: json['ifsc_code']?.toString(),
      upi: json['upi_id']?.toString(),
    );
  }
}
