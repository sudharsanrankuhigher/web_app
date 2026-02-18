enum RequestStatus {
  requested,
  waiting,
  waitingAccept,
  completedPending, // 👈 includes 4 & 5
  completed,
  influencerCancelled,
  rejected,
  promoteVerified,
  promotePay,
  promoteCommission,
  clientPaymentVerified,
}

extension RequestStatusMapper on RequestStatus {
  /// backend status codes grouped by TAB
  List<int> get backendCodes {
    switch (this) {
      case RequestStatus.requested:
        return [1];
      case RequestStatus.waiting:
        return [2];
      case RequestStatus.waitingAccept:
        return [3];
      case RequestStatus.completedPending:
        return [4, 5]; // ✅ SAME TAB
      case RequestStatus.completed:
        return [6];
      case RequestStatus.influencerCancelled:
        return [7];
      case RequestStatus.rejected:
        return [8];
      case RequestStatus.promoteVerified:
        return [9];
      case RequestStatus.promotePay:
        return [10];
      case RequestStatus.promoteCommission:
        return [11];
      case RequestStatus.clientPaymentVerified:
        return [12];
      default:
        return [];
    }
  }

  int get apiCode => backendCodes.first;
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
      case RequestStatus.clientPaymentVerified:
        return "client_payment_verified";
      default:
        return name;
    }
  }
}

extension RequestStatusFilter on RequestStatus {
  /// backend status codes used for TABLE FILTERING
  List<int> get filterBackendCodes {
    switch (this) {
      case RequestStatus.completedPending:
        // click 4 → show 4 & 5
        return [4, 5];
      case RequestStatus.promoteVerified:
        // promote_verified tab shows client_payment_verified also
        return [9, 12];

      case RequestStatus.clientPaymentVerified:
        // client_payment_verified shows ONLY itself
        return [12];

      default:
        return backendCodes;
    }
  }
}
