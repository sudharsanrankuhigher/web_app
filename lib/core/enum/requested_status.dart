enum RequestStatus {
  requested,
  waiting,
  waitingAccept,
  completedPending,
  completed,
  influencerCancelled,
  rejected,
  promoteVerified,
  promotePay,
  promoteCommission,
}

extension RequestStatusX on RequestStatus {
  String get value {
    switch (this) {
      case RequestStatus.waitingAccept:
        return "waiting_accept";
      case RequestStatus.completedPending:
        return "completed_pending";
      case RequestStatus.influencerCancelled:
        return "influencer_cancelled";
      case RequestStatus.promoteVerified:
        return "promote_verified";
      case RequestStatus.promotePay:
        return "promote_pay";
      case RequestStatus.promoteCommission:
        return "promote_commission";
      default:
        return name;
    }
  }
}
