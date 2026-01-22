// To parse this JSON data, do
//
//     final clientModel = clientModelFromJson(jsonString);

import 'dart:convert';

ClientModel clientModelFromJson(String str) =>
    ClientModel.fromJson(json.decode(str));

String clientModelToJson(ClientModel data) => json.encode(data.toJson());

class ClientModel {
  int? status;
  String? message;
  List<Datum>? data;

  ClientModel({
    this.status,
    this.message,
    this.data,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
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
  String? name;
  String? city;
  String? state;
  String? mobile;
  String? alternativeNo;
  String? note;
  String? description;
  String? status;
  bool isSelected = false;

  Datum({
    this.id,
    this.name,
    this.city,
    this.state,
    this.mobile,
    this.alternativeNo,
    this.note,
    this.description,
    this.status,
    this.isSelected = false, // default false
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        city: json["city"],
        state: json["state"],
        mobile: json["mobile"],
        alternativeNo: json["alternative_no"],
        note: json["note"],
        description: json["description"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "city": city,
        "state": state,
        "mobile": mobile,
        "alternative_no": alternativeNo,
        "note": note,
        "description": description,
        "status": status,
      };
}
