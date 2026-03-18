// To parse this JSON data, do
//
//     final promoteTableModel = promoteTableModelFromJson(jsonString);

import 'dart:convert';

PromoteTableModel promoteTableModelFromJson(String str) =>
    PromoteTableModel.fromJson(json.decode(str));

String promoteTableModelToJson(PromoteTableModel data) =>
    json.encode(data.toJson());

class PromoteTableModel {
  int? status;
  List<Datum>? data;
  String? projectCode;

  PromoteTableModel({
    this.status,
    this.data,
    this.projectCode,
  });

  factory PromoteTableModel.fromJson(Map<String, dynamic> json) =>
      PromoteTableModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        projectCode: json["project_code"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "project_code": projectCode,
      };
}

class Datum {
  int? id;
  String? influencerId;
  int? infId;
  String? influencerName;
  String? influencerPhone;
  String? subId;
  dynamic note;
  dynamic rejectNotes;
  dynamic paymentNotes;
  String? amount;
  String? commisionAmount;
  DateTime? createdAt;
  dynamic completedAt;
  dynamic infAcceptedDate;
  dynamic infCompleted;
  dynamic adminVerifiedAt;
  dynamic rejectedAt;
  Payment? payment;
  String? status;
  int? reworkStatus;
  Link? link;

  Datum({
    this.id,
    this.influencerId,
    this.infId,
    this.influencerName,
    this.influencerPhone,
    this.subId,
    this.note,
    this.rejectNotes,
    this.paymentNotes,
    this.amount,
    this.commisionAmount,
    this.createdAt,
    this.completedAt,
    this.infAcceptedDate,
    this.infCompleted,
    this.adminVerifiedAt,
    this.rejectedAt,
    this.payment,
    this.status,
    this.reworkStatus,
    this.link,
  });
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        influencerId: json["influencer_id"],
        infId: json["inf_id"],
        influencerName: json["influencer_name"],
        influencerPhone: json["influencer_phone"],
        subId: json["sub_id"],
        note: json["note"] ?? "-",
        rejectNotes: json["reject_notes"],
        amount: json["amount"]?.toString(),
        commisionAmount: json["commission"]?.toString(),
        paymentNotes: json["payment_notes"]?.toString(),
        createdAt: parseDate(json["created_at"]),
        completedAt: parseDate(json["completed_at"]),
        infAcceptedDate: parseDate(json["inf_accepted_date"]),
        infCompleted: parseDate(json["inf_completed"]),
        adminVerifiedAt: parseDate(json["admin_verified_at"]),
        rejectedAt: parseDate(json["rejected_at"]),
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
        status: json["status"],
        reworkStatus: json["rework_status"],
        link: _parseLink(json["link"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "influencer_id": influencerId,
        "influencer_name": influencerName,
        "influencer_phone": influencerPhone,
        "sub_id": subId,
        "note": note,
        "reject_notes": rejectNotes,
        "payment_notes": paymentNotes,
        "amount": amount,
        "commission": commisionAmount,
        "created_at": createdAt?.toIso8601String(),
        "completed_at": completedAt,
        "inf_accepted_date": infAcceptedDate,
        "inf_completed": infCompleted,
        "admin_verified_at": adminVerifiedAt,
        "rejected_at": rejectedAt,
        "payment": payment?.toJson(),
        "status": status,
        "rework_status": reworkStatus,
        "link": link?.toJson(),
      };

  static Link? _parseLink(dynamic linkData) {
    if (linkData == null) return null;

    // If API returns List
    if (linkData is List) {
      if (linkData.isEmpty) return null;
      return Link.fromJson(Map<String, dynamic>.from(linkData.first));
    }

    // If API returns Map
    if (linkData is Map<String, dynamic>) {
      return Link.fromJson(Map<String, dynamic>.from(linkData));
    }

    return null;
  }
}

class Link {
  dynamic youtube;
  dynamic instagram;
  dynamic facebook;

  Link({
    this.youtube,
    this.instagram,
    this.facebook,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        youtube: json["youtube"]?.toString(),
        instagram: json["instagram"]?.toString(),
        facebook: json["facebook"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "youtube": youtube,
        "instagram": instagram,
        "facebook": facebook,
      };
}

class Payment {
  String? accountNo;
  String? accountName;
  String? ifscCode;
  String? upi;

  Payment({
    this.accountNo,
    this.accountName,
    this.ifscCode,
    this.upi,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        accountNo: json["account_no"],
        accountName: json["account_name"],
        ifscCode: json["ifsc_code"],
        upi: json["upi"],
      );

  Map<String, dynamic> toJson() => {
        "account_no": accountNo,
        "account_name": accountName,
        "ifsc_code": ifscCode,
        "upi": upi,
      };
}

DateTime? parseDate(dynamic value) {
  if (value == null) return null;

  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }

  if (value is int) {
    // assuming timestamp (seconds or milliseconds)
    return value.toString().length == 10
        ? DateTime.fromMillisecondsSinceEpoch(value * 1000)
        : DateTime.fromMillisecondsSinceEpoch(value);
  }

  return null;
}
