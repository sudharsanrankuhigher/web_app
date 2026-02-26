// To parse this JSON data, do
//
//     final reportModel = reportModelFromJson(jsonString);

import 'dart:convert';

ReportModel reportModelFromJson(String str) =>
    ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  List<SubscriptionPlan>? subscriptionPlan;
  List<InfBanner>? infBanner;
  List<CompanyProject>? companyProject;
  List<InfProject>? infProject;
  ClientProjectDetails? clientProjectDetails;
  MonthlyIncome? monthlyIncome;
  String? grantTotal;
  List<PromoteProject>? promoteProject;

  ReportModel({
    this.subscriptionPlan,
    this.infBanner,
    this.companyProject,
    this.infProject,
    this.clientProjectDetails,
    this.monthlyIncome,
    this.grantTotal,
    this.promoteProject,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        subscriptionPlan: json["subscription_plan"] == null
            ? []
            : List<SubscriptionPlan>.from(json["subscription_plan"]!
                .map((x) => SubscriptionPlan.fromJson(x))),
        infBanner: json["inf_banner"] == null
            ? []
            : List<InfBanner>.from(
                json["inf_banner"]!.map((x) => InfBanner.fromJson(x))),
        companyProject: json["company_project"] == null
            ? []
            : List<CompanyProject>.from(json["company_project"]!
                .map((x) => CompanyProject.fromJson(x))),
        infProject: json["inf_project"] == null
            ? []
            : List<InfProject>.from(
                json["inf_project"]!.map((x) => InfProject.fromJson(x))),
        clientProjectDetails: json["client_project_details"] == null
            ? null
            : ClientProjectDetails.fromJson(json["client_project_details"]),
        monthlyIncome: json["monthly_income"] == null
            ? null
            : MonthlyIncome.fromJson(json["monthly_income"]),
        grantTotal: json["grant_total"]?.toString(),
        promoteProject: json["promote_project"] == null
            ? []
            : List<PromoteProject>.from(json["promote_project"]!
                .map((x) => PromoteProject.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subscription_plan": subscriptionPlan == null
            ? []
            : List<dynamic>.from(subscriptionPlan!.map((x) => x.toJson())),
        "inf_banner": infBanner == null
            ? []
            : List<dynamic>.from(infBanner!.map((x) => x.toJson())),
        "company_project": companyProject == null
            ? []
            : List<dynamic>.from(companyProject!.map((x) => x.toJson())),
        "inf_project": infProject == null
            ? []
            : List<dynamic>.from(infProject!.map((x) => x.toJson())),
        "client_project_details": clientProjectDetails?.toJson(),
        "monthly_income": monthlyIncome?.toJson(),
        "grant_total": grantTotal,
        "promote_project": promoteProject == null
            ? []
            : List<dynamic>.from(promoteProject!.map((x) => x.toJson())),
      };
}

class ClientProjectDetails {
  List<Datum>? data;
  Total? total;

  ClientProjectDetails({
    this.data,
    this.total,
  });

  factory ClientProjectDetails.fromJson(Map<String, dynamic> json) =>
      ClientProjectDetails(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        total: json["total"] == null ? null : Total.fromJson(json["total"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total": total?.toJson(),
      };
}

class Datum {
  int? id;
  String? clientName;
  String? clientPhone;
  String? infId;
  String? infName;
  int? clientPayment;
  dynamic clientCommission;
  dynamic infPayment;

  Datum({
    this.id,
    this.clientName,
    this.clientPhone,
    this.infId,
    this.infName,
    this.clientPayment,
    this.clientCommission,
    this.infPayment,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        clientName: json["client_name"],
        clientPhone: json["client_phone"],
        infId: json["inf_id"],
        infName: json["inf_name"],
        clientPayment: json["client_payment"],
        clientCommission: json["client_commission"],
        infPayment: json["inf_payment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_name": clientName,
        "client_phone": clientPhone,
        "inf_id": infId,
        "inf_name": infName,
        "client_payment": clientPayment,
        "client_commission": clientCommission,
        "inf_payment": infPayment,
      };
}

class Total {
  int? clientPayment;
  int? infPayment;
  int? commission;

  Total({
    this.clientPayment,
    this.infPayment,
    this.commission,
  });

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        clientPayment: json["client_payment"],
        infPayment: json["inf_payment"],
        commission: json["commission"],
      );

  Map<String, dynamic> toJson() => {
        "client_payment": clientPayment,
        "inf_payment": infPayment,
        "commission": commission,
      };
}

class CompanyProject {
  String? id;
  String? companyName;
  int? companyCount;

  CompanyProject({
    this.id,
    this.companyName,
    this.companyCount,
  });

  factory CompanyProject.fromJson(Map<String, dynamic> json) => CompanyProject(
        id: json["id"],
        companyName: json["company_name"],
        companyCount: json["company_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "company_count": companyCount,
      };
}

class InfBanner {
  int? id;
  String? infId;
  String? name;
  String? phone;
  String? paymentStatus;
  String? amount;
  DateTime? createdAt;

  InfBanner({
    this.id,
    this.infId,
    this.name,
    this.phone,
    this.paymentStatus,
    this.amount,
    this.createdAt,
  });

  factory InfBanner.fromJson(Map<String, dynamic> json) => InfBanner(
        id: json["id"],
        infId: json["inf_id"],
        name: json["name"],
        phone: json["phone"],
        paymentStatus: json["payment_status"],
        amount: json["amount"]?.toString(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "inf_id": infId,
        "name": name,
        "phone": phone,
        "payment_status": paymentStatus,
        "amount": amount,
        "created_at": createdAt?.toIso8601String(),
      };
}

class InfProject {
  String? id;
  String? infName;
  int? clientProjectCount;
  int? promoteProjectCount;
  int? totalProjectCount;

  InfProject({
    this.id,
    this.infName,
    this.clientProjectCount,
    this.promoteProjectCount,
    this.totalProjectCount,
  });

  factory InfProject.fromJson(Map<String, dynamic> json) => InfProject(
        id: json["id"],
        infName: json["inf_name"],
        clientProjectCount: json["client_project_count"],
        promoteProjectCount: json["promote_project_count"],
        totalProjectCount: json["total_project_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "inf_name": infName,
        "client_project_count": clientProjectCount,
        "promote_project_count": promoteProjectCount,
        "total_project_count": totalProjectCount,
      };
}

class MonthlyIncome {
  String? subscription;
  String? bannerAmount;
  int? clientProjectCommission;
  int? promoteProjectCommission;

  MonthlyIncome({
    this.subscription,
    this.bannerAmount,
    this.clientProjectCommission,
    this.promoteProjectCommission,
  });

  factory MonthlyIncome.fromJson(Map<String, dynamic> json) => MonthlyIncome(
        subscription: (json["subscription"] != null)
            ? json["subscription"].toString()
            : "0",
        bannerAmount: (json["banner_amount"] != null)
            ? json["banner_amount"].toString()
            : "0",
        clientProjectCommission: json["client_project_commission"],
        promoteProjectCommission: json["promote_project_commission"],
      );

  Map<String, dynamic> toJson() => {
        "subscription": subscription,
        "banner_amount": bannerAmount,
        "client_project_commission": clientProjectCommission,
        "promote_project_commission": promoteProjectCommission,
      };
}

class PromoteProject {
  int? id;
  String? projectCode;
  String? companyName;
  String? companyMobile;
  int? infCount;
  int? companyPayment;
  int? companyCommission;
  int? infPayment;

  PromoteProject({
    this.id,
    this.projectCode,
    this.companyName,
    this.companyMobile,
    this.infCount,
    this.companyPayment,
    this.companyCommission,
    this.infPayment,
  });

  factory PromoteProject.fromJson(Map<String, dynamic> json) => PromoteProject(
        id: json["id"],
        projectCode: json["project_code"],
        companyName: json["company_name"],
        companyMobile: json["company_mobile"],
        infCount: json["inf_count"],
        companyPayment: json["company_payment"],
        companyCommission: json["company_commission"],
        infPayment: json["inf_payment"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "project_code": projectCode,
        "company_name": companyName,
        "company_mobile": companyMobile,
        "inf_count": infCount,
        "company_payment": companyPayment,
        "company_commission": companyCommission,
        "inf_payment": infPayment,
      };
}

class SubscriptionPlan {
  int? id;
  int? clientId;
  String? clientName;
  String? clientMobileNumber;
  String? packageName;
  String? packageStatus;
  String? amount;
  DateTime? paymentDate;

  SubscriptionPlan({
    this.id,
    this.clientId,
    this.clientName,
    this.clientMobileNumber,
    this.packageName,
    this.packageStatus,
    this.amount,
    this.paymentDate,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlan(
        id: json["id"],
        clientId: json["client_id"],
        clientName: json["client_name"],
        clientMobileNumber: json["client_mobile_number"],
        packageName: json["package_name"],
        packageStatus: json["package_status"],
        amount: json["amount"],
        paymentDate: json["payment_date"] == null
            ? null
            : DateTime.parse(json["payment_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_id": clientId,
        "client_name": clientName,
        "client_mobile_number": clientMobileNumber,
        "package_name": packageName,
        "package_status": packageStatus,
        "amount": amount,
        "payment_date": paymentDate?.toIso8601String(),
      };
}
