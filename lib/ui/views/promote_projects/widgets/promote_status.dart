class PromoteStatus {
  static const assigned = 'assigned';
  static const infAccepted = 'inf_accepted';
  static const infCompleted = 'inf_completed';
  static const rejected = 'rejected';
  static const adminVerified = 'admin_verify_completed';
  static const promoteVerified = 'promote_verified';
  static const promotePay = 'promote_pay';
  static const promoteCommission = 'promote_commission';
  static const companyPaymentVerified = 'company_payment_verified';

  /// UI status → backend status code
  static const Map<String, int> statusCode = {
    assigned: 1,
    infAccepted: 2,
    infCompleted: 3,
    rejected: 4,
    adminVerified: 5,
    promoteVerified: 6,
    promotePay: 7,
    promoteCommission: 8,
    companyPaymentVerified: 9,
  };
}
