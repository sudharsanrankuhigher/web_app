// To parse this JSON data, do
//
//     final allBannerModel = allBannerModelFromJson(jsonString);

import 'dart:convert';

AllBannerModel allBannerModelFromJson(String str) =>
    AllBannerModel.fromJson(json.decode(str));

String allBannerModelToJson(AllBannerModel data) => json.encode(data.toJson());

class AllBannerModel {
  int? status;
  String? message;
  List<Datum>? data;

  AllBannerModel({
    this.status,
    this.message,
    this.data,
  });

  factory AllBannerModel.fromJson(Map<String, dynamic> json) => AllBannerModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  int? priority;
  String? image;
  int? infId;
  String? amount;
  String? status;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.priority,
    this.image,
    this.infId,
    this.amount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.startDate,
    this.endDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        priority: json["priority"],
        image: json["image"],
        infId: json["inf_id"],
        amount: json["amount"]?.toString(),
        status: json["status"]?.toString(),
        startDate: json["start_date"] == null
            ? null
            : DateTime.tryParse(json["start_date"].toString()),
        endDate: json["end_date"] == null
            ? null
            : DateTime.tryParse(json["end_date"].toString()),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "priority": priority,
        "image": image,
        "inf_id": infId,
        "amount": amount,
        "status": status,
        "start_date": startDate?.toIso8601String(),
        "end_date": endDate?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
