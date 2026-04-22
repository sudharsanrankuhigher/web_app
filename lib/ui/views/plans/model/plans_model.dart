// To parse this JSON data, do
//
//     final planModel = planModelFromJson(jsonString);

import 'dart:convert';

PlanModel planModelFromJson(String str) => PlanModel.fromJson(json.decode(str));

String planModelToJson(PlanModel data) => json.encode(data.toJson());

class PlanModel {
  bool? success;
  String? message;
  List<Datum>? data;

  PlanModel({
    this.success,
    this.message,
    this.data,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
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
  String? name;
  int? connections;
  String? amount;
  String? saleAmount;
  String? gst;
  String? badge;
  String? selectedPlan;
  String? category;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.name,
    this.connections,
    this.amount,
    this.badge,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.selectedPlan,
    this.gst,
    this.saleAmount,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        connections: json["connections"],
        amount: json["regular_price"] == null
            ? '0'
            : json["regular_price"].toString(),
        saleAmount:
            json["sale_price"] == null ? '0' : json["sale_price"].toString(),
        gst: json["gst"] == null ? '0' : json["gst"].toString(),
        badge: json["badge"],
        selectedPlan: json["selected_plan"],
        category: json["category_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "connections": connections,
        "regular_price": amount,
        "sale_price": saleAmount,
        "gst": gst,
        "badge": badge,
        "selected_plan": selectedPlan,
        "category_id": category,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
