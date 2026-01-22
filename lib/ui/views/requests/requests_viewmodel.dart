import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/core/enum/requested_status.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/ui/views/requests/model/request_model.dart';
import 'package:webapp/ui/views/requests/widgets/request_table_source.dart';

class RequestsViewModel extends BaseViewModel with NavigationMixin {
  RequestsViewModel() {
    setSelected(0);
  }
  String? _selectedString;
  int _isSelected = 0;
  int get isSelected => _isSelected;
  String? get selectedString => _selectedString;

  bool? _isRequest = false;
  bool? get isRequest => _isRequest;

  final List<RequestStatus> _tabs = [
    RequestStatus.requested,
    RequestStatus.waiting,
    RequestStatus.waitingAccept,
    RequestStatus.completedPending,
    RequestStatus.completed,
    RequestStatus.influencerCancelled,
    RequestStatus.rejected,
    RequestStatus.promoteVerified,
    RequestStatus.promotePay,
    RequestStatus.promoteCommission,
  ];

  void setSelected(int index) {
    _isRequest = true;
    _isSelected = index;

    final status = _tabs[index].value;
    loadTable(status);

    notifyListeners();
  }

  // Data list
  List<ProjectRequestModel> requests = [];

  late RequestTableSource tableSource;

  Future<void> loadTable(String status) async {
    setBusy(true);
    _selectedString = status;

    try {
      await Future.delayed(const Duration(seconds: 1));

      requests = [
        ProjectRequestModel(
          sNo: 1,
          projectCode: "PR001",
          clientName: "ABC Corp",
          clientPhone: "9999999999",
          influencerId: "INF001",
          influencerName: "John Doe",
          influencerPhone: "9898984562",
          status: RequestStatus.requested.value,
          requestedDate: "10-12-2025",
          assignedDate: "11-12-2025",
          completedDate: "12-12-2025",
          influencerBankDetails: "Bank XYZ",
          paymentAmount: "5000",
          commissionAmount: "500",
        ),
        ProjectRequestModel(
          sNo: 2,
          projectCode: "PR002",
          clientName: "ABC Corps",
          clientPhone: "9999999999",
          influencerId: "INF002",
          influencerName: "John",
          influencerPhone: "9898986532",
          status: RequestStatus.waiting.value,
          requestedDate: "10-12-2025",
        ),
      ];

      tableSource = RequestTableSource(
          requests.where((e) => e.status == status).toList(), status, onReject);

      _isRequest = false;
    } catch (e) {
      requests = [];
      tableSource = RequestTableSource([], status, onReject);
      _isRequest = false;
    }

    setBusy(false);
    notifyListeners();
  }

  onReject(ProjectRequestModel model) {}

  List<DataColumn> getColumnsByStatus(String status) {
    switch (status) {
      // 1. Requested
      case "requested":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Client Phone")),
          DataColumn(label: Text("Influencer ID")),
          DataColumn(label: Text("Requested Date")),
          DataColumn(
              label: Text("Action"),
              headingRowAlignment: MainAxisAlignment.center),
        ];

      // 2. Waiting
      case "waiting":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Client Phone")),
          DataColumn(label: Text("Influencer ID")),
          DataColumn(label: Text("Requested Date")),
          DataColumn(
              label: Text("Action"),
              headingRowAlignment: MainAxisAlignment.center),
        ];

      // 3. Waiting Accept
      case "waiting_accept":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Client Phone")),
          DataColumn(label: Text("Influencer Phone")),
          DataColumn(label: Text("Requested Date")),
          DataColumn(label: Text("Action")),
        ];

      // 4. Complete Pending
      case "completed_pending":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Requested Date")),
          DataColumn(label: Text("View Link")),
          DataColumn(label: Text("Action")),
        ];

      // 5. Completed
      case "completed":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Requested Date")),
          DataColumn(label: Text("Completed Date")),
          DataColumn(label: Text("Action")),
        ];

      // 6. Influencer Cancelled
      case "influencer_cancelled":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Client Phone")),
          DataColumn(label: Text("Influencer Phone")),
          DataColumn(label: Text("Requested Date")),
          DataColumn(label: Text("Action")),
        ];

      // 7. Rejected
      case "rejected":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Client Phone")),
          DataColumn(label: Text("Influencer Phone")),
          DataColumn(label: Text("Requested Date")),
          DataColumn(label: Text("Rejected Date")),
        ];

      // 8. Promote Verified
      case "promote_verified":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("CP Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Client Phone")),
          DataColumn(label: Text("Influencer Phone")),
          DataColumn(label: Text("Assigned Date")),
          DataColumn(label: Text("Action")),
        ];

      // 9. Promote Pay
      case "promote_pay":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("CP Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Completed Date")),
          DataColumn(label: Text("Bank Details")),
          DataColumn(label: Text("Payment Amount")),
          DataColumn(label: Text("Action")),
        ];

      // 10. Promote Commission
      case "promote_commission":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("CP Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Completed Date")),
          DataColumn(label: Text("Bank Details")),
          DataColumn(label: Text("Commission Amount")),
        ];

      default:
        return [];
    }
  }
}
