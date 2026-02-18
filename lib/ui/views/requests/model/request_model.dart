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

  Client({
    this.name,
    this.mobileNumber,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        name: json["name"]?.toString(),
        mobileNumber: json["mobile_number"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile_number": mobileNumber,
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

class Inf {
  dynamic infId;
  String? name;
  String? phone;
  int? ids;

  Inf({this.infId, this.name, this.phone, this.ids});

  factory Inf.fromJson(Map<String, dynamic> json) => Inf(
        infId: json["inf_id"],
        name: json["name"]?.toString(),
        phone: json["phone"]?.toString(),
        ids: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "inf_id": infId,
        "name": name,
        "phone": phone,
        "id": ids,
      };
}

class Payment {
  int? amount;
  String? status;
  DateTime? paidDate;
  int? commission;
  String? bankDetails;

  Payment({
    this.amount,
    this.status,
    this.paidDate,
    this.commission,
    this.bankDetails,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        amount: json["amount"],
        status: json["payment_status"]?.toString(),
        paidDate: json["paid_date"] == null
            ? null
            : DateTime.tryParse(json["paid_date"]),
        commission: json["commission"] == null
            ? null
            : int.tryParse(json["commission"].toString()),
        bankDetails: json["bank_details"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "payment_status": status,
        "paid_date": paidDate?.toIso8601String(),
        "commission": commission,
        "bank_details": bankDetails,
      };
}

class Promotion {
  String? youtube;
  String? facebook;
  String? instagram;

  Promotion({
    this.youtube,
    this.facebook,
    this.instagram,
  });

  factory Promotion.fromJson(Map<String, dynamic> json) => Promotion(
        youtube: json["youtube"]?.toString(),
        facebook: json["facebook"]?.toString(),
        instagram: json["instagram"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "youtube": youtube,
        "facebook": facebook,
        "instagram": instagram,
      };
}
