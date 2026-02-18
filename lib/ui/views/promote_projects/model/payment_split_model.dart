import 'dart:convert';

PaymentSplitModel paymentSplitModelFromJson(String str) =>
    PaymentSplitModel.fromJson(json.decode(str));

String paymentSplitModelToJson(PaymentSplitModel data) =>
    json.encode(data.toJson());

class PaymentSplitModel {
  int? status;
  List<Datum>? data;
  String? totalAmount; // numeric is better

  PaymentSplitModel({
    this.status,
    this.data,
    this.totalAmount,
  });

  factory PaymentSplitModel.fromJson(Map<String, dynamic> json) {
    return PaymentSplitModel(
      status: json["status"] as int?,
      data: json["data"] == null
          ? []
          : List<Datum>.from(
              (json["data"] as List).map((x) => Datum.fromJson(x))),
      totalAmount: json["total_amount"]?.toString(), // 🔥 FIX
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total_amount": totalAmount,
      };
}

class Datum {
  int? id;
  int? infId;
  String? influencerId; // numeric
  String? influencerName;
  String? influencerPhone; // keep as String
  String? influencerImage;
  String? payment; // numeric
  String? status;

  Datum({
    this.id,
    this.infId,
    this.influencerId,
    this.influencerName,
    this.influencerPhone,
    this.influencerImage,
    this.payment,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"] as int?,
      infId: json["inf_id"] as int?,
      influencerId: json["influencer_id"].toString(),
      influencerName: json["influencer_name"]?.toString(),
      influencerPhone: json["influencer_phone"]?.toString(),
      influencerImage: json["influencer_image"]?.toString(),
      payment: json["payment"]?.toString(),
      status: json["status"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "inf_id": infId,
        "influencer_id": influencerId,
        "influencer_name": influencerName,
        "influencer_phone": influencerPhone,
        "influencer_image": influencerImage,
        "payment": payment,
        "status": status,
      };
}
