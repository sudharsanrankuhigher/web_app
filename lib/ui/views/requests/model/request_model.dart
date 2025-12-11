class ProjectRequestModel {
  final int? sNo;
  final String? projectCode;

  final String? clientName;
  final String? clientPhone;

  final String? influencerName;
  final String? influencerId;
  final String? influencerPhone;

  final String? requestedDate;
  final String? completedDate;
  final String? cancelledDate;
  final String? assignedDate;

  final String? influencerBankDetails;
  final String? paymentAmount;
  final String? commissionAmount;

  final String?
      status; // requested, pending, accepted, completed, cancelled, rejected, promoteVerified, promotePay, promoteCommission

  ProjectRequestModel({
    this.sNo,
    this.projectCode,
    this.clientName,
    this.clientPhone,
    this.influencerName,
    this.influencerId,
    this.influencerPhone,
    this.requestedDate,
    this.completedDate,
    this.cancelledDate,
    this.assignedDate,
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
      influencerName: json['influencerName'],
      influencerId: json['influencerId'],
      influencerPhone: json['influencerPhone'],
      requestedDate: json['requestedDate'],
      completedDate: json['completedDate'],
      cancelledDate: json['cancelledDate'],
      assignedDate: json['assignedDate'],
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
        "influencerName": influencerName,
        "influencerId": influencerId,
        "influencerPhone": influencerPhone,
        "requestedDate": requestedDate,
        "completedDate": completedDate,
        "cancelledDate": cancelledDate,
        "assignedDate": assignedDate,
        "influencerBankDetails": influencerBankDetails,
        "paymentAmount": paymentAmount,
        "commissionAmount": commissionAmount,
        "status": status,
      };
}
