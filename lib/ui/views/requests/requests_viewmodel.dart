import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/enum/requested_status.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/requests/model/request_model.dart'
    as request_model;
import 'package:webapp/ui/views/requests/widgets/confirmation_dialog.dart';
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

  int? request = 1;
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

  final _dialogService = locator<DialogService>();
  final _apiService = locator<ApiService>();

  void setSelected(int index) {
    _isRequest = true;
    _isSelected = index;

    final selectedTab = _tabs[index];
    loadTable(selectedTab);

    notifyListeners();
  }

  // Data list
  List<request_model.Datum> requests = [];

  RequestTableSource? tableSource;

  // 1:Request, 2:Request-Waiting, 3:Waiting-Accept, 4:Completed-Pending, 5:Rework, 6:Completed, 7:inf-cancelled, 8:Admin-Rejected, 9:Promote-Verified, 10:Promote-Pay, 11:Promote-Commission,
  Future<void> loadTable(RequestStatus tabStatus) async {
    _isRequest = true;
    print(tabStatus.value);
    setBusy(true);
    _selectedString = tabStatus.value;

    try {
      final res = await _apiService.getClientRequest(tabStatus.apiCode);
      requests = res.data ?? [];

      final filteredData = requests.where((e) {
        final apiStatus = e.status; // INT from backend
        return tabStatus.backendCodes.contains(apiStatus);
      }).toList();

      tableSource = RequestTableSource(
        filteredData,
        tabStatus.value,
        onReject,
        onWaiting,
        onProceed,
        onPreparing,
        onGoToPromoteVerified,
        onRevoke,
        onGotoPromotePay,
      );

      _isRequest = false;
    } catch (e) {
      requests = [];
      tableSource = RequestTableSource(
        [],
        tabStatus.value,
        onReject,
        onWaiting,
        onProceed,
        onPreparing,
        onGoToPromoteVerified,
        onRevoke,
        onGotoPromotePay,
      );
      _isRequest = false;
    }

    setBusy(false);
    notifyListeners();
  }

  List<DataColumn> getColumnsByStatus(String status) {
    switch (status) {
      // 1. Requested
      case "requested":
        return const [
          DataColumn(
            label: SizedBox(
              width: 40, // 👈 small width
              child: Text("S.No"),
            ),
          ),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Client Phone")),
          DataColumn(
              label: Text("Inf_ID / Inf_No"),
              headingRowAlignment: MainAxisAlignment.center),
          DataColumn(label: Text("Requested Date")),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.center,
            label: SizedBox(
              width: 260,
              child: Text(
                "Action",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ];

      // 2. Waiting
      case "waiting":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Client Phone")),
          DataColumn(
              label: Text("Inf_ID / Inf_No"),
              headingRowAlignment: MainAxisAlignment.center),
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
          DataColumn(label: Text("Client Phone")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Inf_No")),
          DataColumn(label: Text("Requested Date")),
          DataColumn(
              label: Text(
                "Action",
              ),
              headingRowAlignment: MainAxisAlignment.center),
        ];

      // 4. Complete Pending
      case "completed_pending":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Client phone")),
          DataColumn(label: Text("Inf_Id / inf_phone")),
          DataColumn(label: Text("Requested Date")),
          DataColumn(label: Text("accepted Date")),
          DataColumn(label: Text("link")),
          DataColumn(
              label: Text("Action"),
              headingRowAlignment: MainAxisAlignment.center),
        ];

      // 5. Completed
      case "completed":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Client phone")),
          DataColumn(label: Text("Inf_Id / inf_phone")),
          DataColumn(label: Text("Requested Date")),
          DataColumn(label: Text("Completed Date")),
          DataColumn(
              label: Text("Action"),
              headingRowAlignment: MainAxisAlignment.center),
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
          DataColumn(label: Text("Client Phone")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Inf_Id / Inf_Phone")),
          DataColumn(label: Text("Assigned Date")),
          DataColumn(label: Text("Completed Date")),
          DataColumn(
              label: Text("Action"),
              headingRowAlignment: MainAxisAlignment.center),
        ];

      // 9. Promote Pay
      case "promote_pay":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Inf_name / Ind_ID")),
          DataColumn(label: Text("Inf_phone")),
          DataColumn(label: Text("Completed Date")),
          DataColumn(label: Text("Bank Details")),
          DataColumn(label: Text("Payment Amount")),
          DataColumn(label: Text("Commision Amount")),
          DataColumn(label: Text("Action")),
        ];

      // 10. Promote Commission
      case "promote_commission":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Inf_name / Ind_ID")),
          DataColumn(label: Text("Inf_Phone")),
          DataColumn(label: Text("Inf_Payment date")),
          DataColumn(label: Text("Commission Amount")),
          DataColumn(label: Text("Action")),
        ];

      default:
        return [];
    }
  }

  /// functions
  /// request & waiting
  onReject(request_model.Datum model) {
    showRejectConfirmationDialog(
        context: StackedService.navigatorKey!.currentContext!,
        itemName: "${model.projectId}",
        onConfirm: () {});
  }

  //waiting
  onWaiting(request_model.Datum model) {
    showActionConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      title: 'Move to Waiting',
      confirmText: "Move",
      message:
          "Are you sure you want to move the ${model.projectId} to the waiting section?",
      icon: Icons.hourglass_top,
      confirmColor: Colors.green,
      onConfirm: () => {},
    );
  }

  //waiting accept
  onProceed(request_model.Datum model) {
    showAdminPaymentConfigDialog(
      context: StackedService.navigatorKey!.currentContext!,
      onSave: (data) {
        debugPrint(data.toString());
      },
    );
  }

  //completed-pending
  onPreparing(request_model.Datum model) async {
    final result = await showStatusDialog(
      StackedService.navigatorKey!.currentContext!,
    );

    if (result != null) {
      print("Selected status: ${result['name']}");
    }
  }

  onGoToPromoteVerified(request_model.Datum model) {
    showActionConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      title: 'Move to Promote Verified',
      confirmText: "Move",
      message:
          "Are you sure you want to move the ${model.projectId} to the Promote Verified section?",
      icon: Icons.hourglass_top,
      confirmColor: Colors.green,
      onConfirm: () => {},
    );
  }

  onRevoke(request_model.Datum model) {
    showActionConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      title: 'Revoke',
      confirmText: "Revoke",
      message:
          "Are you sure you want to Revoke the ${model.projectId} to the Influencer Cancelled section?",
      icon: Icons.free_cancellation,
      confirmColor: red,
      onConfirm: () => {},
    );
  }

  onGotoPromotePay(request_model.Datum model) {
    showActionConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      title: 'Promote Pay',
      confirmText: "Go to Promote pay",
      image: "assets/images/pay.svg",
      message:
          "Are you sure you move to Promote Pay the ${model.projectId} to the Promote verified section?",
      icon: Icons.free_cancellation,
      confirmColor: publisButtonColor,
      onConfirm: () => {},
    );
  }

  Future<void> onRefresh() async {
    setSelected(_isSelected);
  }
}
