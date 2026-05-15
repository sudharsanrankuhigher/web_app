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
        status: _toInt(json["status"]),
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

String getFormattedId(int? categoryId, int? id) {
  if (categoryId == null || id == null) return "UNKNOWN";

  String prefix;

  switch (categoryId) {
    case 1:
      prefix = "INF";
      break;
    case 2:
      prefix = "MOV";
      break;
    case 3:
      prefix = "TV";
      break;
    case 4:
      prefix = "SP";
      break;
    default:
      prefix = "UNK";
  }

  // pad id to 4 digits → 1 => 0001, 10 => 0010
  final paddedId = id.toString().padLeft(4, '0');

  return "$prefix$paddedId";
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
  int? refundStatus;
  int? reworkStatus;
  DateTime? refundInitiatedAt;
  DateTime? refundCompletedAt;
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
    this.refundStatus,
    this.reworkStatus,
    this.refundInitiatedAt,
    this.refundCompletedAt,
    this.link,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: _toInt(json["id"]),
        influencerId: getFormattedId(
            _toInt(json['influencer_category_id']), _toInt(json['inf_id'])),
        infId: _toInt(json["inf_id"]),
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
        status: json["status"]?.toString(),
        reworkStatus: _toInt(json["rework_status"]),
        refundStatus: _toInt(json["refund_status"]),
        refundInitiatedAt: parseDate(json["refund_at"]),
        refundCompletedAt: parseDate(json["refund_updated_at"]),
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
        "refund_status": refundStatus,
        "rework_status": reworkStatus,
        "refund_at": refundInitiatedAt?.toIso8601String(),
        "refund_updated_at": refundCompletedAt?.toIso8601String(),
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

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}
