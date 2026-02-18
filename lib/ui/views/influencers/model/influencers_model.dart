// To parse this JSON data, do
//
//     final influencerModel = influencerModelFromJson(jsonString);

import 'dart:convert';

InfluencerModel influencerModelFromJson(String str) =>
    InfluencerModel.fromJson(json.decode(str));

String influencerModelToJson(InfluencerModel data) =>
    json.encode(data.toJson());

class InfluencerModel {
  int? success;
  String? message;
  List<Datum>? data;

  InfluencerModel({
    this.success,
    this.message,
    this.data,
  });

  factory InfluencerModel.fromJson(Map<String, dynamic> json) =>
      InfluencerModel(
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
  int? category;
  String? name;
  String? image;
  String? email;
  String? phone;
  String? altPhone;
  DateTime? dob;
  String? infId;
  String? state;
  String? gender;
  List<int>? service;
  String? city;
  String? instagramName;
  String? youtubeName;
  String? facebookName;
  String? instagramLink;
  int? instagramFollowers;
  String? facebookLink;
  int? facebookFollowers;
  String? youtubeLink;
  int? youtubeFollowers;
  String? accountNo;
  String? accountHolderName;
  String? ifscCode;
  String? upiId;
  String? description;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Datum({
    this.id,
    this.name,
    this.image,
    this.email,
    this.phone,
    this.altPhone,
    this.dob,
    this.infId,
    this.state,
    this.gender,
    this.service,
    this.city,
    this.instagramLink,
    this.youtubeName,
    this.facebookName,
    this.instagramName,
    this.instagramFollowers,
    this.facebookLink,
    this.facebookFollowers,
    this.youtubeLink,
    this.youtubeFollowers,
    this.accountNo,
    this.accountHolderName,
    this.ifscCode,
    this.upiId,
    this.description,
    this.status,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        category: json["category"] == null
            ? null
            : int.tryParse(json["category"].toString()),
        image: json["image"],
        email: json["email"],
        phone: json["phone"],
        altPhone: json["alt_phone"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        infId: json["inf_id"],
        state: json["state"],
        service: json["service"] == null
            ? []
            : List<int>.from(json["service"]!.map((x) => x)),
        city: json["city"],
        gender: json["gender"],
        instagramName: json["instagram_name"],
        youtubeName: json["youtube_name"],
        facebookName: json["facebook_name"],
        instagramLink: json["instagram_link"],
        facebookLink: json["facebook_link"],
        youtubeLink: json["youtube_link"],
        instagramFollowers: _parseInt(json["instagram_followers"]),
        facebookFollowers: _parseInt(json["facebook_followers"]),
        youtubeFollowers: _parseInt(json["youtube_followers"]),
        accountNo: json["account_no"],
        accountHolderName: json["account_holder_name"],
        ifscCode: json["ifsc_code"],
        upiId: json["upi_id"],
        description: json["description"],
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
        "name": name,
        "category": category,
        "image": image,
        "email": email,
        "phone": phone,
        "alt_phone": altPhone,
        "gender": gender,
        "dob":
            "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
        "inf_id": infId,
        "state": state,
        "service":
            service == null ? [] : List<dynamic>.from(service!.map((x) => x)),
        "city": city,
        "instagram_name": instagramName,
        "youtube_name": youtubeName,
        "facebook_name": facebookName,
        "instagram_link": instagramLink,
        "instagram_followers": instagramFollowers,
        "facebook_link": facebookLink,
        "facebook_followers": facebookFollowers,
        "youtube_link": youtubeLink,
        "youtube_followers": youtubeFollowers,
        "account_no": accountNo,
        "account_holder_name": accountHolderName,
        "ifsc_code": ifscCode,
        "upi_id": upiId,
        "description": description,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      if (value.trim().isEmpty) return 0;
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }
}
