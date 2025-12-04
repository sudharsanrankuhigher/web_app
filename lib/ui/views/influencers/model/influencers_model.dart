class InfluencerModel {
  String name;
  int id;
  String? email;
  String phone;
  String? dob;
  String? altPhone;
  String? idNumber;
  String? state;
  String? password;
  String? service;
  String? city;
  String? instagram;
  String? instagramFollowers;
  String? instagramDesc;
  String? facebook;
  String? facebookFollowers;
  String? youtube;
  String? youtubeFollowers;
  String? bankAccount;
  String? bankHolder;
  String? ifsc;
  String? upi;
  String category; // ✅ required field
  String? image;
  bool isActive;

  InfluencerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.category, // ✅ required
    this.email,
    this.dob,
    this.altPhone,
    this.idNumber,
    this.state,
    this.password,
    this.service,
    this.city,
    this.instagram,
    this.instagramFollowers,
    this.instagramDesc,
    this.facebook,
    this.facebookFollowers,
    this.youtube,
    this.youtubeFollowers,
    this.bankAccount,
    this.bankHolder,
    this.ifsc,
    this.upi,
    this.image,
    this.isActive = true,
  });
}
