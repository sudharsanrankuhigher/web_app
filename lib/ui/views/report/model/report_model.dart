// To parse this JSON data, do
//
//     final reportModel = reportModelFromJson(jsonString);

import 'dart:convert';

ReportModel reportModelFromJson(String str) =>
    ReportModel.fromJson(json.decode(str));

String reportModelToJson(ReportModel data) => json.encode(data.toJson());

class ReportModel {
  bool? status;
  String? month;
  int? totalAmount;
  List<SubscriptionPlan>? subscriptionPlan;
  List<InfluencerProfileHighlight>? influencersProfileHighlight;
  // DashboardMonthlyCountSummary? dashboardMonthlyCountSummary;
  DashboardTotal? dashboardTotal;
  List<CompanyWiseProjectCountReport>? companyWiseProjectCountReport;
  List<InfluencersProjectCount>? influencersProjectCount;
  ClientProjectDetailedReport? clientProjectDetailedReport;
  List<TotalMonthlyIncomeReport>? totalMonthlyIncomeReport;
  int? grandTotal;
  List<PromoteProjecte>? promoteProjectes;

  ReportModel({
    this.status,
    this.month,
    this.totalAmount,
    this.subscriptionPlan,
    this.influencersProfileHighlight,
    // this.dashboardMonthlyCountSummary,
    this.dashboardTotal,
    this.companyWiseProjectCountReport,
    this.influencersProjectCount,
    this.clientProjectDetailedReport,
    this.totalMonthlyIncomeReport,
    this.grandTotal,
    this.promoteProjectes,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        status: json["status"],
        month: json["month"],
        totalAmount: json["totalAmount"],
        subscriptionPlan: json["Subscription_Plan"] == null
            ? []
            : List<SubscriptionPlan>.from(json["Subscription_Plan"]!
                .map((x) => SubscriptionPlan.fromJson(x))),
        influencersProfileHighlight:
            json["influencers_profile_highlight"] == null
                ? []
                : List<InfluencerProfileHighlight>.from(
                    json["influencers_profile_highlight"]!
                        .map((x) => InfluencerProfileHighlight.fromJson(x))),
        // dashboardMonthlyCountSummary:
        //     json["dashboard_monthly_count_summary"] == null
        //         ? null
        //         : DashboardMonthlyCountSummary.fromJson(
        //             json["dashboard_monthly_count_summary"]),
        dashboardTotal: json["dashboardTotal"] == null
            ? null
            : DashboardTotal.fromJson(json["dashboardTotal"]),
        companyWiseProjectCountReport:
            json["company_wise_project_count_report"] == null
                ? []
                : List<CompanyWiseProjectCountReport>.from(
                    json["company_wise_project_count_report"]!
                        .map((x) => CompanyWiseProjectCountReport.fromJson(x))),
        influencersProjectCount: json["influencers_project_count"] == null
            ? []
            : List<InfluencersProjectCount>.from(
                json["influencers_project_count"]!
                    .map((x) => InfluencersProjectCount.fromJson(x))),
        clientProjectDetailedReport:
            json["client_project_detailed_report"] == null
                ? null
                : ClientProjectDetailedReport.fromJson(
                    json["client_project_detailed_report"]),
        totalMonthlyIncomeReport: json["total_monthly_income_report"] == null
            ? []
            : List<TotalMonthlyIncomeReport>.from(
                json["total_monthly_income_report"]!
                    .map((x) => TotalMonthlyIncomeReport.fromJson(x))),
        grandTotal: json["grandTotal"],
        promoteProjectes: json["promote_projectes"] == null
            ? []
            : List<PromoteProjecte>.from(json["promote_projectes"]!
                .map((x) => PromoteProjecte.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "month": month,
        "totalAmount": totalAmount,
        "Subscription_Plan": subscriptionPlan == null
            ? []
            : List<dynamic>.from(subscriptionPlan!.map((x) => x.toJson())),
        "influencers_profile_highlight": influencersProfileHighlight == null
            ? []
            : List<dynamic>.from(
                influencersProfileHighlight!.map((x) => x.toJson())),
        // "dashboard_monthly_count_summary":
        //     dashboardMonthlyCountSummary?.toJson(),
        "dashboardTotal": dashboardTotal?.toJson(),
        "company_wise_project_count_report":
            companyWiseProjectCountReport == null
                ? []
                : List<dynamic>.from(
                    companyWiseProjectCountReport!.map((x) => x.toJson())),
        "influencers_project_count": influencersProjectCount == null
            ? []
            : List<dynamic>.from(
                influencersProjectCount!.map((x) => x.toJson())),
        "client_project_detailed_report": clientProjectDetailedReport?.toJson(),
        "total_monthly_income_report": totalMonthlyIncomeReport == null
            ? []
            : List<dynamic>.from(
                totalMonthlyIncomeReport!.map((x) => x.toJson())),
        "grandTotal": grandTotal,
        "promote_projectes": promoteProjectes == null
            ? []
            : List<dynamic>.from(promoteProjectes!.map((x) => x.toJson())),
      };
}

class ClientProjectDetailedReport {
  bool? status;
  Total? total;
  List<Datum>? data;

  ClientProjectDetailedReport({
    this.status,
    this.total,
    this.data,
  });

  factory ClientProjectDetailedReport.fromJson(Map<String, dynamic> json) =>
      ClientProjectDetailedReport(
        status: json["status"],
        total: json["total"] == null ? null : Total.fromJson(json["total"]),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "total": total?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? sno;
  String? cpCode;
  String? clientName;
  String? clientMobile;
  String? influencerId;
  String? influencerName;
  int? clientPayment;
  int? clientCommission;
  int? influencerPaid;

  Datum({
    this.sno,
    this.cpCode,
    this.clientName,
    this.clientMobile,
    this.influencerId,
    this.influencerName,
    this.clientPayment,
    this.clientCommission,
    this.influencerPaid,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        sno: json["sno"],
        cpCode: json["cpCode"],
        clientName: json["clientName"],
        clientMobile: json["clientMobile"],
        influencerId: json["influencerId"],
        influencerName: json["influencerName"],
        clientPayment: json["clientPayment"],
        clientCommission: json["clientCommission"],
        influencerPaid: json["influencerPaid"],
      );

  Map<String, dynamic> toJson() => {
        "sno": sno,
        "cpCode": cpCode,
        "clientName": clientName,
        "clientMobile": clientMobile,
        "influencerId": influencerId,
        "influencerName": influencerName,
        "clientPayment": clientPayment,
        "clientCommission": clientCommission,
        "influencerPaid": influencerPaid,
      };
}

class Total {
  int? clientPayment;
  int? clientCommission;
  int? influencerPaid;

  Total({
    this.clientPayment,
    this.clientCommission,
    this.influencerPaid,
  });

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        clientPayment: json["clientPayment"],
        clientCommission: json["clientCommission"],
        influencerPaid: json["influencerPaid"],
      );

  Map<String, dynamic> toJson() => {
        "clientPayment": clientPayment,
        "clientCommission": clientCommission,
        "influencerPaid": influencerPaid,
      };
}

class CompanyWiseProjectCountReport {
  int? sno;
  String? companyId;
  String? companyName;
  int? projectCount;

  CompanyWiseProjectCountReport({
    this.sno,
    this.companyId,
    this.companyName,
    this.projectCount,
  });

  factory CompanyWiseProjectCountReport.fromJson(Map<String, dynamic> json) =>
      CompanyWiseProjectCountReport(
        sno: json["sno"],
        companyId: json["companyId"],
        companyName: json["companyName"],
        projectCount: json["projectCount"],
      );

  Map<String, dynamic> toJson() => {
        "sno": sno,
        "companyId": companyId,
        "companyName": companyName,
        "projectCount": projectCount,
      };
}

class DashboardMonthlyCountSummary {
  Summary? summary;

  DashboardMonthlyCountSummary({
    this.summary,
  });

  factory DashboardMonthlyCountSummary.fromJson(Map<String, dynamic> json) =>
      DashboardMonthlyCountSummary(
        summary:
            json["summary"] == null ? null : Summary.fromJson(json["summary"]),
      );

  Map<String, dynamic> toJson() => {
        "summary": summary?.toJson(),
      };
}

class Summary {
  int? clientProject;
  int? promoteProject;
  IncomingProfiles? incomingProfiles;
  int? incomingClients;
  int? incomingCompanies;

  Summary({
    this.clientProject,
    this.promoteProject,
    this.incomingProfiles,
    this.incomingClients,
    this.incomingCompanies,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        clientProject: json["clientProject"],
        promoteProject: json["promoteProject"],
        incomingProfiles: json["incomingProfiles"] == null
            ? null
            : IncomingProfiles.fromJson(json["incomingProfiles"]),
        incomingClients: json["incomingClients"],
        incomingCompanies: json["incomingCompanies"],
      );

  Map<String, dynamic> toJson() => {
        "clientProject": clientProject,
        "promoteProject": promoteProject,
        "incomingProfiles": incomingProfiles?.toJson(),
        "incomingClients": incomingClients,
        "incomingCompanies": incomingCompanies,
      };
}

class IncomingProfiles {
  int? influencers;
  int? movies;
  int? tvStars;
  int? sportsStars;

  IncomingProfiles({
    this.influencers,
    this.movies,
    this.tvStars,
    this.sportsStars,
  });

  factory IncomingProfiles.fromJson(Map<String, dynamic> json) =>
      IncomingProfiles(
        influencers: json["influencers"],
        movies: json["movies"],
        tvStars: json["tvStars"],
        sportsStars: json["sportsStars"],
      );

  Map<String, dynamic> toJson() => {
        "influencers": influencers,
        "movies": movies,
        "tvStars": tvStars,
        "sportsStars": sportsStars,
      };
}

class DashboardTotal {
  int? clients;
  int? companies;
  int? influencers;
  int? movieStars;
  int? tvStars;
  int? sportsStars;

  DashboardTotal({
    this.clients,
    this.companies,
    this.influencers,
    this.movieStars,
    this.tvStars,
    this.sportsStars,
  });

  factory DashboardTotal.fromJson(Map<String, dynamic> json) => DashboardTotal(
        clients: json["clients"],
        companies: json["companies"],
        influencers: json["influencers"],
        movieStars: json["movieStars"],
        tvStars: json["tvStars"],
        sportsStars: json["sportsStars"],
      );

  Map<String, dynamic> toJson() => {
        "clients": clients,
        "companies": companies,
        "influencers": influencers,
        "movieStars": movieStars,
        "tvStars": tvStars,
        "sportsStars": sportsStars,
      };
}

class SubscriptionPlan {
  int? sno;
  String? clientId;
  String? clientName;
  String? mobile;
  String? packageName;
  String? paymentStatus;
  int? amount;
  DateTime? date;

  SubscriptionPlan({
    this.sno,
    this.clientId,
    this.clientName,
    this.mobile,
    this.packageName,
    this.paymentStatus,
    this.amount,
    this.date,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlan(
        sno: json["sno"],
        clientId: json["clientId"],
        clientName: json["clientName"],
        mobile: json["mobile"],
        packageName: json["packageName"],
        paymentStatus: json["paymentStatus"],
        amount: json["amount"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "sno": sno,
        "clientId": clientId,
        "clientName": clientName,
        "mobile": mobile,
        "packageName": packageName,
        "paymentStatus": paymentStatus,
        "amount": amount,
        "date": date?.toIso8601String(),
      };
}

class InfluencerProfileHighlight {
  int? sno;
  String? influencerId;
  String? influencerName;
  String? mobile;
  String? packageName;
  String? paymentStatus;
  int? amount;
  DateTime? date;

  InfluencerProfileHighlight({
    this.sno,
    this.influencerId,
    this.influencerName,
    this.mobile,
    this.packageName,
    this.paymentStatus,
    this.amount,
    this.date,
  });

  factory InfluencerProfileHighlight.fromJson(Map<String, dynamic> json) =>
      InfluencerProfileHighlight(
        sno: json["sno"],
        influencerId: json["influencerId"],
        influencerName: json["influencerName"],
        mobile: json["mobile"],
        packageName: json["packageName"],
        paymentStatus: json["paymentStatus"],
        amount: json["amount"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "sno": sno,
        "influencerId": influencerId,
        "influencerName": influencerName,
        "mobile": mobile,
        "packageName": packageName,
        "paymentStatus": paymentStatus,
        "amount": amount,
        "date": date?.toIso8601String(),
      };
}

class InfluencersProjectCount {
  int? sno;
  String? influencerId;
  String? influencerName;
  int? clientProject;
  int? promoteProject;
  int? totalProject;

  InfluencersProjectCount({
    this.sno,
    this.influencerId,
    this.influencerName,
    this.clientProject,
    this.promoteProject,
    this.totalProject,
  });

  factory InfluencersProjectCount.fromJson(Map<String, dynamic> json) =>
      InfluencersProjectCount(
        sno: json["sno"],
        influencerId: json["influencerId"],
        influencerName: json["influencerName"],
        clientProject: json["clientProject"],
        promoteProject: json["promoteProject"],
        totalProject: json["totalProject"],
      );

  Map<String, dynamic> toJson() => {
        "sno": sno,
        "influencerId": influencerId,
        "influencerName": influencerName,
        "clientProject": clientProject,
        "promoteProject": promoteProject,
        "totalProject": totalProject,
      };
}

class PromoteProjecte {
  int? id;
  int? ppCode;
  String? companyName;
  int? infId;
  String? infName1;
  int? companyPayment;
  int? companyCommission;
  int? influencerPaid;

  PromoteProjecte({
    this.id,
    this.ppCode,
    this.companyName,
    this.infId,
    this.infName1,
    this.companyPayment,
    this.companyCommission,
    this.influencerPaid,
  });

  factory PromoteProjecte.fromJson(Map<String, dynamic> json) =>
      PromoteProjecte(
        id: json["id"],
        ppCode: json["pp_code"],
        companyName: json["company_name"],
        infId: json["inf_id"],
        infName1: json["inf_name1"],
        companyPayment: json["company_payment"],
        companyCommission: json["company_commission"],
        influencerPaid: json["influencer_paid"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pp_code": ppCode,
        "company_name": companyName,
        "inf_id": infId,
        "inf_name1": infName1,
        "company_payment": companyPayment,
        "cpmmapany_commission": companyCommission,
        "influencer_paid": influencerPaid,
      };
}

class TotalMonthlyIncomeReport {
  int? sno;
  String? particular;
  int? totalIncome;

  TotalMonthlyIncomeReport({
    this.sno,
    this.particular,
    this.totalIncome,
  });

  factory TotalMonthlyIncomeReport.fromJson(Map<String, dynamic> json) =>
      TotalMonthlyIncomeReport(
        sno: json["sno"],
        particular: json["particular"],
        totalIncome: json["totalIncome"],
      );

  Map<String, dynamic> toJson() => {
        "sno": sno,
        "particular": particular,
        "totalIncome": totalIncome,
      };
}
