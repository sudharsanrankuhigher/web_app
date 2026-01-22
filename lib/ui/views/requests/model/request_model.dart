class ProjectRequestModel {
  final int? sNo;
  final String? projectCode; // PR code / CP code

  final String? clientName;
  final String? clientPhone;

  final String? influencerId;
  final String? influencerName;
  final String? influencerPhone;

  final String? requestedDate;
  final String? assignedDate;
  final String? completedDate;
  final String? cancelledDate;
  final String? rejectedDate;

  final String? viewLink;

  final String? influencerBankDetails;
  final String? paymentAmount;
  final String? commissionAmount;

  final String? status;

  ProjectRequestModel({
    this.sNo,
    this.projectCode,
    this.clientName,
    this.clientPhone,
    this.influencerId,
    this.influencerName,
    this.influencerPhone,
    this.requestedDate,
    this.assignedDate,
    this.completedDate,
    this.cancelledDate,
    this.rejectedDate,
    this.viewLink,
    this.influencerBankDetails,
    this.paymentAmount,
    this.commissionAmount,
    this.status,
  });

  factory ProjectRequestModel.fromJson(Map<String, dynamic> json) {
    return ProjectRequestModel(
      sNo: json['sNo'],
      projectCode: json['projectCode'],
      clientName: json['clientName'],
      clientPhone: json['clientPhone'],
      influencerId: json['influencerId'],
      influencerName: json['influencerName'],
      influencerPhone: json['influencerPhone'],
      requestedDate: json['requestedDate'],
      assignedDate: json['assignedDate'],
      completedDate: json['completedDate'],
      cancelledDate: json['cancelledDate'],
      rejectedDate: json['rejectedDate'],
      viewLink: json['viewLink'],
      influencerBankDetails: json['influencerBankDetails'],
      paymentAmount: json['paymentAmount'],
      commissionAmount: json['commissionAmount'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
        "sNo": sNo,
        "projectCode": projectCode,
        "clientName": clientName,
        "clientPhone": clientPhone,
        "influencerId": influencerId,
        "influencerName": influencerName,
        "influencerPhone": influencerPhone,
        "requestedDate": requestedDate,
        "assignedDate": assignedDate,
        "completedDate": completedDate,
        "cancelledDate": cancelledDate,
        "rejectedDate": rejectedDate,
        "viewLink": viewLink,
        "influencerBankDetails": influencerBankDetails,
        "paymentAmount": paymentAmount,
        "commissionAmount": commissionAmount,
        "status": status,
      };
}
