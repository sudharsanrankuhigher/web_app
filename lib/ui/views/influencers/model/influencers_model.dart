// To parse this JSON data, do
//
//     final influencerModel = influencerModelFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/foundation.dart';

String sanitizeApiText(dynamic value) {
  if (value == null) return '';
  return value.toString().replaceAll('\uFFFD', '').trim();
}

int? _safeInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed);
  }
  return null;
}

String? _safeString(dynamic value) {
  if (value == null) return null;
  if (value is List || value is Map) return null;
  return value.toString();
}

DateTime? _safeDateTime(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

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

  factory InfluencerModel.fromJson(Map<String, dynamic> json) {
    final list = json["data"];
    final parsedData = <Datum>[];
    if (list is List) {
      for (final item in list) {
        try {
          if (item is Map<String, dynamic>) {
            parsedData.add(Datum.fromJson(item));
          }
        } catch (e, stackTrace) {
          debugPrint('Influencer parsing error: $e');
          debugPrintStack(stackTrace: stackTrace);
        }
      }
    }
    return InfluencerModel(
      success: _safeInt(json["success"]),
      message: _safeString(json["message"]),
      data: parsedData,
    );
  }

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
        id: _safeInt(json["id"]),
        name: sanitizeApiText(json["name"]),
        category: _safeInt(json["category"]),
        image: _safeString(json["image"]),
        email: _safeString(json["email"]),
        phone: _safeString(json["phone"]),
        altPhone: _safeString(json["alt_phone"]),
        dob: _safeDateTime(json["dob"]),
        infId: _safeString(json["inf_id"]),
        state: sanitizeApiText(json["state"]),
        service: _parseService(json["service"]),
        city: sanitizeApiText(json["city"]),
        gender: _safeString(json["gender"]),
        instagramName: sanitizeApiText(json["instagram_name"]),
        youtubeName: sanitizeApiText(json["youtube_name"]),
        facebookName: sanitizeApiText(json["facebook_name"]),
        instagramLink: _safeString(json["instagram_link"]),
        facebookLink: _safeString(json["facebook_link"]),
        youtubeLink: _safeString(json["youtube_link"]),
        instagramFollowers: _parseInt(json["instagram_followers"]),
        facebookFollowers: _parseInt(json["facebook_followers"]),
        youtubeFollowers: _parseInt(json["youtube_followers"]),
        accountNo: _safeString(json["account_no"]),
        accountHolderName: _safeString(json["account_holder_name"]),
        ifscCode: _safeString(json["ifsc_code"]),
        upiId: _safeString(json["upi_id"]),
        description: sanitizeApiText(json["description"]),
        status: _safeInt(json["status"]),
        createdAt: _safeDateTime(json["created_at"]),
        updatedAt: _safeDateTime(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "categoryid": category,
        "image": image,
        "email": email,
        "phone": phone,
        "alt_phone": altPhone,
        "gender": gender,
        "dob": dob == null
            ? null
            : "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
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

  static List<int> _parseService(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((e) => _safeInt(e)).whereType<int>().toList();
    }
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return [];
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        try {
          final decoded = json.decode(trimmed);
          if (decoded is List) {
            return decoded.map((e) => _safeInt(e)).whereType<int>().toList();
          }
        } catch (_) {}
      }
      return trimmed
          .split(',')
          .map((e) => int.tryParse(e.trim()))
          .whereType<int>()
          .toList();
    }
    if (value is int) {
      return [value];
    }
    return [];
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return 0;
      return int.tryParse(trimmed) ?? 0;
    }
    return 0;
  }
}
