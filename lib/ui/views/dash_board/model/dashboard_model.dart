// To parse this JSON data, do
//
//     final dashboardViewModel = dashboardViewModelFromJson(jsonString);

import 'dart:convert';

DashboardViewModel dashboardViewModelFromJson(String str) =>
    DashboardViewModel.fromJson(json.decode(str));

String dashboardViewModelToJson(DashboardViewModel data) =>
    json.encode(data.toJson());

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    return int.tryParse(value) ?? double.tryParse(value)?.toInt();
  }
  return null;
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

class DashboardViewModel {
  ClientSide? clientSide;
  PromoteSide? promoteSide;
  InfluencersCount? influencersCount;
  ProjectsCount? projectsCount;
  Commissions? commissions;
  PackageAndBannerRevenue? packageAndBannerRevenue;
  ClientProjectsStatus? clientProjectsStatus;
  PromoteProjectsStatus? promoteProjectsStatus;
  ChartData? chartData;

  DashboardViewModel({
    this.clientSide,
    this.promoteSide,
    this.influencersCount,
    this.projectsCount,
    this.commissions,
    this.packageAndBannerRevenue,
    this.clientProjectsStatus,
    this.promoteProjectsStatus,
    this.chartData,
  });

  factory DashboardViewModel.fromJson(Map<String, dynamic> json) =>
      DashboardViewModel(
        clientSide: json["client_side"] == null
            ? null
            : ClientSide.fromJson(json["client_side"]),
        promoteSide: json["promote_side"] == null
            ? null
            : PromoteSide.fromJson(json["promote_side"]),
        influencersCount: json["influencers_count"] == null
            ? null
            : InfluencersCount.fromJson(json["influencers_count"]),
        projectsCount: json["projects_count"] == null
            ? null
            : ProjectsCount.fromJson(json["projects_count"]),
        commissions: json["commissions"] == null
            ? null
            : Commissions.fromJson(json["commissions"]),
        packageAndBannerRevenue: json["package_and_banner_revenue"] == null
            ? null
            : PackageAndBannerRevenue.fromJson(
                json["package_and_banner_revenue"]),
        clientProjectsStatus: json["client_projects_status"] == null
            ? null
            : ClientProjectsStatus.fromJson(json["client_projects_status"]),
        promoteProjectsStatus: json["promote_projects_status"] == null
            ? null
            : PromoteProjectsStatus.fromJson(json["promote_projects_status"]),
        chartData: json["chart_data"] == null
            ? null
            : ChartData.fromJson(json["chart_data"]),
      );

  Map<String, dynamic> toJson() => {
        "client_side": clientSide?.toJson(),
        "promote_side": promoteSide?.toJson(),
        "influencers_count": influencersCount?.toJson(),
        "projects_count": projectsCount?.toJson(),
        "commissions": commissions?.toJson(),
        "package_and_banner_revenue": packageAndBannerRevenue?.toJson(),
        "client_projects_status": clientProjectsStatus?.toJson(),
        "promote_projects_status": promoteProjectsStatus?.toJson(),
        "chart_data": chartData?.toJson(),
      };
}

class ChartData {
  List<double>? monthlyClientCommissions;
  List<double>? monthlyPromoteCommissions;

  ChartData({
    this.monthlyClientCommissions,
    this.monthlyPromoteCommissions,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
        monthlyClientCommissions: json["monthly_client_commissions"] == null
            ? []
            : List<double>.from(
                (json["monthly_client_commissions"] as List)
                    .map((x) => _toDouble(x) ?? 0.0),
              ),
        monthlyPromoteCommissions: json["monthly_promote_commissions"] == null
            ? []
            : List<double>.from(
                (json["monthly_promote_commissions"] as List)
                    .map((x) => _toDouble(x) ?? 0.0),
              ),
      );

  Map<String, dynamic> toJson() => {
        "monthly_client_commissions": monthlyClientCommissions ?? [],
        "monthly_promote_commissions": monthlyPromoteCommissions ?? [],
      };
}

class ClientProjectsStatus {
  int? clientPendingCount;
  int? clientOngoingCount;
  int? clientCompletedCount;
  int? clientMonthlyCount;

  ClientProjectsStatus({
    this.clientPendingCount,
    this.clientOngoingCount,
    this.clientCompletedCount,
    this.clientMonthlyCount,
  });

  factory ClientProjectsStatus.fromJson(Map<String, dynamic> json) =>
      ClientProjectsStatus(
        clientPendingCount: _toInt(json["client_pending_count"]),
        clientOngoingCount: _toInt(json["client_ongoing_count"]),
        clientCompletedCount: _toInt(json["client_completed_count"]),
        clientMonthlyCount: _toInt(json["client_monthly_count"]),
      );

  Map<String, dynamic> toJson() => {
        "client_pending_count": clientPendingCount,
        "client_ongoing_count": clientOngoingCount,
        "client_completed_count": clientCompletedCount,
        "client_monthly_count": clientMonthlyCount,
      };
}

class ClientSide {
  int? clientCount;
  int? clientProjects;
  int? clientRevenue;

  ClientSide({
    this.clientCount,
    this.clientProjects,
    this.clientRevenue,
  });

  factory ClientSide.fromJson(Map<String, dynamic> json) => ClientSide(
        clientCount: _toInt(json["client_count"]),
        clientProjects: _toInt(json["client_projects"]),
        clientRevenue: _toInt(json["client_revenue"]),
      );

  Map<String, dynamic> toJson() => {
        "client_count": clientCount,
        "client_projects": clientProjects,
        "client_revenue": clientRevenue,
      };
}

class Commissions {
  int? clientProjectCommission;
  int? promoteProjectCommission;

  Commissions({
    this.clientProjectCommission,
    this.promoteProjectCommission,
  });

  factory Commissions.fromJson(Map<String, dynamic> json) => Commissions(
        clientProjectCommission: _toInt(json["client_project_commission"]),
        promoteProjectCommission: _toInt(json["promote_project_commission"]),
      );

  Map<String, dynamic> toJson() => {
        "client_project_commission": clientProjectCommission,
        "promote_project_commission": promoteProjectCommission,
      };
}

class InfluencersCount {
  int? tvStarsCount;
  int? sportStarsCount;
  int? movieStarsCount;
  int? regularInfluencersCount;
  int? totalInfluencersCount;

  InfluencersCount({
    this.tvStarsCount,
    this.sportStarsCount,
    this.movieStarsCount,
    this.regularInfluencersCount,
    this.totalInfluencersCount,
  });

  factory InfluencersCount.fromJson(Map<String, dynamic> json) =>
      InfluencersCount(
        tvStarsCount: _toInt(json["tv_stars_count"]),
        sportStarsCount: _toInt(json["sport_stars_count"]),
        movieStarsCount: _toInt(json["movie_stars_count"]),
        regularInfluencersCount: _toInt(json["regular_influencers_count"]),
        totalInfluencersCount: _toInt(json["total_influencers_count"]),
      );

  Map<String, dynamic> toJson() => {
        "tv_stars_count": tvStarsCount,
        "sport_stars_count": sportStarsCount,
        "movie_stars_count": movieStarsCount,
        "regular_influencers_count": regularInfluencersCount,
        "total_influencers_count": totalInfluencersCount,
      };
}

class PackageAndBannerRevenue {
  double? packageRevenue;
  int? bannerRevenue;
  int? clientCount;
  int? influencerCount;

  PackageAndBannerRevenue({
    this.packageRevenue,
    this.bannerRevenue,
    this.clientCount,
    this.influencerCount,
  });

  factory PackageAndBannerRevenue.fromJson(Map<String, dynamic> json) =>
      PackageAndBannerRevenue(
        packageRevenue: _toDouble(json["package_revenue"]),
        bannerRevenue: _toInt(json["banner_revenue"]),
        clientCount: _toInt(json["client_count"]),
        influencerCount: _toInt(json["influencer_count"]),
      );

  Map<String, dynamic> toJson() => {
        "package_revenue": packageRevenue,
        "banner_revenue": bannerRevenue,
        "client_count": clientCount,
        "influencer_count": influencerCount,
      };
}

class ProjectsCount {
  int? tvStarsProjects;
  int? sportStarsProjects;
  int? movieStarsProjects;
  int? regularInfluencerProjects;
  int? totalProjectsCount;

  ProjectsCount({
    this.tvStarsProjects,
    this.sportStarsProjects,
    this.movieStarsProjects,
    this.regularInfluencerProjects,
    this.totalProjectsCount,
  });

  factory ProjectsCount.fromJson(Map<String, dynamic> json) => ProjectsCount(
        tvStarsProjects: _toInt(json["tv_stars_projects"]),
        sportStarsProjects: _toInt(json["sport_stars_projects"]),
        movieStarsProjects: _toInt(json["movie_stars_projects"]),
        regularInfluencerProjects: _toInt(json["regular_influencer_projects"]),
        totalProjectsCount: _toInt(json["total_projects_count"]),
      );

  Map<String, dynamic> toJson() => {
        "tv_stars_projects": tvStarsProjects,
        "sport_stars_projects": sportStarsProjects,
        "movie_stars_projects": movieStarsProjects,
        "regular_influencer_projects": regularInfluencerProjects,
        "total_projects_count": totalProjectsCount,
      };
}

class PromoteProjectsStatus {
  int? promoteInProgressCount;
  int? promoteCompletedCount;
  int? promoteMonthlyCount;

  PromoteProjectsStatus({
    this.promoteInProgressCount,
    this.promoteCompletedCount,
    this.promoteMonthlyCount,
  });

  factory PromoteProjectsStatus.fromJson(Map<String, dynamic> json) =>
      PromoteProjectsStatus(
        promoteInProgressCount: _toInt(json["promote_in_progress_count"]),
        promoteCompletedCount: _toInt(json["promote_completed_count"]),
        promoteMonthlyCount: _toInt(json["promote_monthly_count"]),
      );

  Map<String, dynamic> toJson() => {
        "promote_in_progress_count": promoteInProgressCount,
        "promote_completed_count": promoteCompletedCount,
        "promote_monthly_count": promoteMonthlyCount,
      };
}

class PromoteSide {
  int? companyCount;
  int? companyProjects;
  int? companyRevenue;

  PromoteSide({
    this.companyCount,
    this.companyProjects,
    this.companyRevenue,
  });

  factory PromoteSide.fromJson(Map<String, dynamic> json) => PromoteSide(
        companyCount: _toInt(json["company_count"]),
        companyProjects: _toInt(json["company_projects"]),
        companyRevenue: _toInt(json["company_revenue"]),
      );

  Map<String, dynamic> toJson() => {
        "company_count": companyCount,
        "company_projects": companyProjects,
        "company_revenue": companyRevenue,
      };
}
