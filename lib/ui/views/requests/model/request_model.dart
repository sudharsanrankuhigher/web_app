// To parse this JSON data, do
//
// final projectRequestModel = projectRequestModelFromJson(jsonString);

import 'dart:convert';

ProjectRequestModel projectRequestModelFromJson(String str) =>
    ProjectRequestModel.fromJson(json.decode(str));

String projectRequestModelToJson(ProjectRequestModel data) =>
    json.encode(data.toJson());

class ProjectRequestModel {
  bool? success;
  List<Datum>? data;
  String? message;

  ProjectRequestModel({
    this.success,
    this.data,
    this.message,
  });

  factory ProjectRequestModel.fromJson(Map<String, dynamic> json) =>
      ProjectRequestModel(
        success: json["success"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(
                json["data"].map((x) => Datum.fromJson(x)),
              ),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  int? id;
  String? projectId;
  Client? client;
  Inf? inf;
  Dates? dates;
  Payment? payment;
  Promotion? promotion;
  int? status;
  String? category;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.projectId,
    this.client,
    this.inf,
    this.dates,
    this.payment,
    this.promotion,
    this.status,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        projectId: json["project_id"],
        client: json["client"] == null ? null : Client.fromJson(json["client"]),
        inf: json["inf"] == null ? null : Inf.fromJson(json["inf"]),
        dates: json["dates"] == null ? null : Dates.fromJson(json["dates"]),
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
        promotion: _parsePromotion(json["promotion"]),
        status: json["status"] != null
            ? int.tryParse(json["status"].toString())
            : null,
        category: json["category_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_id": projectId,
        "client": client?.toJson(),
        "inf": inf?.toJson(),
        "dates": dates?.toJson(),
        "payment": payment?.toJson(),
        "promotion": promotion?.toJson(),
        "status": status,
        "category_id": category,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  /// Handles:
  /// - null
  /// - {}
  /// - []
  /// - [{}]
  static Promotion? _parsePromotion(dynamic promoData) {
    if (promoData == null) return null;

    if (promoData is List) {
      if (promoData.isEmpty) return null;
      return Promotion.fromJson(Map<String, dynamic>.from(promoData.first));
    }

    if (promoData is Map<String, dynamic>) {
      return Promotion.fromJson(promoData);
    }

    return null;
  }
}

class Client {
  String? name;
  String? mobileNumber;
  int? id;

  Client({
    this.name,
    this.mobileNumber,
    this.id,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        name: json["name"]?.toString(),
        mobileNumber: json["mobile_number"]?.toString(),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile_number": mobileNumber,
        "id": id,
      };
}

class Dates {
  DateTime? requestedAt;
  dynamic assignedAt;
  dynamic completed;
  dynamic payment;
  dynamic cancelled;

  Dates({
    this.requestedAt,
    this.assignedAt,
    this.completed,
    this.payment,
    this.cancelled,
  });

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        requestedAt: json["requested_at"] == null
            ? null
            : DateTime.tryParse(json["requested_at"]),
        assignedAt: json["assigned_at"],
        completed: json["completed"],
        payment: json["payment"],
        cancelled: json["cancelled"],
      );

  Map<String, dynamic> toJson() => {
        "requested_at": requestedAt?.toIso8601String(),
        "assigned_at": assignedAt,
        "completed": completed,
        "payment": payment,
        "cancelled": cancelled,
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

class Inf {
  dynamic infId;
  String? name;
  String? phone;
  String? accountNumber;
  String? ifscCode;
  String? holderName;
  String? upiId;
  int? ids;

  Inf(
      {this.infId,
      this.name,
      this.phone,
      this.ids,
      this.accountNumber,
      this.ifscCode,
      this.holderName,
      this.upiId});

  factory Inf.fromJson(Map<String, dynamic> json) => Inf(
        infId: getFormattedId(json["category_id"], json["id"]),
        name: json["name"]?.toString(),
        phone: json["phone"]?.toString(),
        ids: json["id"],
        accountNumber: json["account_no"]?.toString(),
        ifscCode: json["ifsc_code"]?.toString(),
        holderName: json["account_holder_name"]?.toString(),
        upiId: json["upi_id"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "inf_id": infId,
        "name": name,
        "phone": phone,
        "id": ids,
        "account_no": accountNumber,
        "ifsc_code": ifscCode,
        "account_holder_name": holderName,
        "upi_id": upiId,
      };
}

class Payment {
  int? amount;
  String? status;
  String? note;
  DateTime? paidDate;
  int? commission;
  String? bankDetails;

  Payment({
    this.amount,
    this.status,
    this.note,
    this.paidDate,
    this.commission,
    this.bankDetails,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        amount: _parseInt(json["payment"]),
        status: json["payment_status"]?.toString(),
        note: json["note"]?.toString(),
        paidDate: json["paid_date"] == null
            ? null
            : DateTime.tryParse(json["paid_date"]),
        commission: json["commission"] == null
            ? null
            : int.tryParse(json["commission"].toString()),
        bankDetails: json["bank_details"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "payment": amount,
        "payment_status": status,
        "paid_date": paidDate?.toIso8601String(),
        "commission": commission,
        "bank_details": bankDetails,
        "note": note,
      };
}

int? _parseInt(dynamic value) {
  if (value == null) return null;

  if (value is int) return value;

  if (value is String) {
    if (value.trim().isEmpty) return null;
    return int.tryParse(value);
  }

  return null;
}

class Promotion {
  String? youtube;
  String? facebook;
  String? instagram;

  // ✅ ADD THIS
  Map<String, dynamic> raw;

  Promotion({
    this.youtube,
    this.facebook,
    this.instagram,
    required this.raw,
  });

  factory Promotion.fromJson(dynamic json) {
    // Handle [] case
    if (json == null || json is List) {
      return Promotion(
        youtube: null,
        facebook: null,
        instagram: null,
        raw: {},
      );
    }

    final map = Map<String, dynamic>.from(json);

    return Promotion(
      youtube: map["youtube"]?.toString(),
      facebook: map["facebook"]?.toString(),
      instagram: map["instagram"]?.toString(),
      raw: map, // ✅ store original keys
    );
  }

  Map<String, dynamic> toJson() => {
        if (raw.containsKey("youtube")) "youtube": youtube,
        if (raw.containsKey("facebook")) "facebook": facebook,
        if (raw.containsKey("instagram")) "instagram": instagram,
      };
}
