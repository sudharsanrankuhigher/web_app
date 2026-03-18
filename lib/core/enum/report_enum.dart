enum ReportType {
  subscription,
  clientDetailed,
  promoteDetailed,
  influencerHighlight,
  companyReport,
  influencerReport,
}

extension ReportTypeExtension on ReportType {
  String get title {
    switch (this) {
      case ReportType.subscription:
        return "Subscription Plans Report";
      case ReportType.clientDetailed:
        return "Client Project Detailed Report";
      case ReportType.promoteDetailed:
        return "Promote Projectes Detailed Report";
      case ReportType.influencerHighlight:
        return "Influencer HighLight Report";
      case ReportType.companyReport:
        return "Company Wise Project Report";
      case ReportType.influencerReport:
        return "Influencer Project Report";
    }
  }
}
