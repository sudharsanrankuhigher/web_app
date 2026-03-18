// To parse this JSON data, do
//
//     final getUsersResponse = getUsersResponseFromJson(jsonString);

import 'dart:convert';

GetUsersResponse getUsersResponseFromJson(String str) =>
    GetUsersResponse.fromJson(json.decode(str));

String getUsersResponseToJson(GetUsersResponse data) =>
    json.encode(data.toJson());

class GetUsersResponse {
  int? status;
  String? message;
  List<Datum>? data;

  GetUsersResponse({
    this.status,
    this.message,
    this.data,
  });

  factory GetUsersResponse.fromJson(Map<String, dynamic> json) =>
      GetUsersResponse(
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
  String? email;
  dynamic emailVerifiedAt;
  dynamic createdAt;
  dynamic updatedAt;
  String? mobileNumber;
  String? type;
  DateTime? dob;
  String? state;
  String? city;
  String? plan;
  int? connections;

  Datum({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.mobileNumber,
    this.type,
    this.dob,
    this.state,
    this.city,
    this.plan,
    this.connections,
  });
  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"]?.toString() ?? ""),
        name: json["name"]?.toString(),
        email: json["email"]?.toString(),
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        mobileNumber: json["mobile_number"]?.toString(),
        type: json["type"]?.toString(),
        dob: json["dob"] == null
            ? null
            : DateTime.tryParse(json["dob"].toString()),
        state: json["state"]?.toString() ?? "",
        city: json["city"]?.toString() ?? "",
        plan: json["plan"]?.toString(),
        connections: json["connections"] is int
            ? json["connections"]
            : int.tryParse(json["connections"]?.toString() ?? ""),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "mobile_number": mobileNumber,
        "type": type,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "state": state,
        "city": city,
        "plan": plan,
        "connections": connections,
      };
}
