// To parse this JSON data, do
//
//     final projectModel = projectModelFromJson(jsonString);
import 'dart:convert';

ProjectModel projectModelFromJson(String str) =>
    ProjectModel.fromJson(json.decode(str));

String projectModelToJson(ProjectModel data) => json.encode(data.toJson());

class ProjectModel {
  int? status;
  List<Message>? message;

  ProjectModel({
    this.status,
    this.message,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        status: json["status"],
        message: json["message"] == null
            ? []
            : List<Message>.from(
                json["message"].map((x) => Message.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message == null
            ? []
            : List<dynamic>.from(message!.map((x) => x.toJson())),
      };
}

class Message {
  int? id;
  String? projectCode;
  String? companyName;
  String? companyId;
  String? projectName;
  String? description;
  List<Influencer>? influencers;
  String? state;
  String? city;
  PaymentElement? payment;
  DateTime? createdAt;
  dynamic completedAt;
  List<ProjectImage>? image;
  List<int>? service;
  String? gender;
  LinkElement? link;

  Message(
      {this.id,
      this.projectCode,
      this.companyName,
      this.companyId,
      this.projectName,
      this.description,
      this.influencers,
      this.state,
      this.city,
      this.payment,
      this.createdAt,
      this.completedAt,
      this.image,
      this.service,
      this.gender,
      this.link});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        projectCode: json["project_code"],
        companyName: json["company_name"],
        companyId: json["company_id"],
        projectName: json["project_name"],
        description: json["description"],

        influencers: json["influencers"] == null
            ? []
            : List<Influencer>.from(
                json["influencers"].map((x) => Influencer.fromJson(x))),

        state: json["state"],
        city: json["city"],

        /// 🔥 SAFE PAYMENT HANDLING
        payment: _parsePayment(json["payment"]),

        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),

        completedAt: json["completed_at"],

        image: json["image"] == null
            ? []
            : List<ProjectImage>.from(
                json["image"].map((x) => ProjectImage.fromJson(x))),

        service: json["service"] == null
            ? []
            : List<int>.from(
                json["service"].map((x) => int.tryParse(x.toString()) ?? 0),
              ),

        gender: json["gender"],
        link: _parseLink(json["link"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_code": projectCode,
        "company_name": companyName,
        "company_id": companyId,
        "project_name": projectName,
        "description": description,
        "influencers": influencers == null
            ? []
            : List<dynamic>.from(influencers!.map((x) => x.toJson())),
        "state": state,
        "city": city,
        "payment": payment?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "completed_at": completedAt,
        "image": image == null
            ? []
            : List<dynamic>.from(image!.map((x) => x.toJson())),
        "service": service ?? [],
        "gender": gender,
        "link": link == null ? [] : [link!.toJson()],
      };

  /// ✅ Handles object OR list OR null
  static PaymentElement? _parsePayment(dynamic paymentJson) {
    if (paymentJson == null) return null;

    if (paymentJson is List) {
      if (paymentJson.isEmpty) return null;
      return PaymentElement.fromJson(paymentJson.first);
    }

    if (paymentJson is Map<String, dynamic>) {
      return PaymentElement.fromJson(paymentJson);
    }

    return null;
  }

  static LinkElement? _parseLink(dynamic linkJson) {
    if (linkJson == null) return null;

    if (linkJson is List) {
      if (linkJson.isEmpty) return null;
      return LinkElement.fromJson(
        Map<String, dynamic>.from(linkJson.first),
      );
    }

    if (linkJson is Map<String, dynamic>) {
      return LinkElement.fromJson(linkJson);
    }

    return null;
  }
}

class ProjectImage {
  int? id;
  String? image;

  ProjectImage({this.id, this.image});

  factory ProjectImage.fromJson(Map<String, dynamic> json) => ProjectImage(
        id: json["id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}

class Influencer {
  int? id;
  String? name;
  String? image;

  Influencer({this.id, this.name, this.image});

  factory Influencer.fromJson(Map<String, dynamic> json) => Influencer(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}

class PaymentElement {
  int? payment;
  int? commission;

  PaymentElement({this.payment, this.commission});

  factory PaymentElement.fromJson(Map<String, dynamic> json) => PaymentElement(
        payment: int.tryParse(json["payment"].toString()),
        commission: int.tryParse(json["commission"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "payment": payment,
        "commission": commission,
      };
}

class LinkElement {
  String? youtube;
  String? facebook;
  String? instagram;

  LinkElement({
    this.youtube,
    this.facebook,
    this.instagram,
  });

  factory LinkElement.fromJson(Map<String, dynamic> json) => LinkElement(
        youtube: json["youtube"],
        facebook: json["facebook"],
        instagram: json["instagram"],
      );

  Map<String, dynamic> toJson() => {
        "youtube": youtube,
        "facebook": facebook,
        "instagram": instagram,
      };
}
