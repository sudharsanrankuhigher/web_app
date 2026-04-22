import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/enum/requested_status.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/ui/views/requests/model/request_model.dart'
    as request_model;
import 'package:webapp/ui/views/requests/widgets/confirmation_dialog.dart';
import 'package:webapp/ui/views/requests/widgets/request_table_source.dart';
import 'package:webapp/ui/views/influencers/model/influencers_model.dart'
    as influencer_model;

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

  List<influencer_model.Datum> influencers = [];

  List<int> assignedInfluencerIds = [];

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
    RequestStatus.clientPaymentVerified,
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

  Future<void> getInfluencers() async {
    try {
      final res = await runBusyFuture(_apiService.getAllInfluencer());
      influencers = res.data ?? [];
    } catch (e) {
      influencers = [];
    }
  }

  // Data list
  List<request_model.Datum> requests = [];

  RequestTableSource? tableSource;

  List<request_model.Datum> filteredData = [];

  // 1:Request, 2:Request-Waiting, 3:Waiting-Accept, 4:Completed-Pending, 5:Rework, 6:Completed, 7:inf-cancelled, 8:Admin-Rejected, 9:Promote-Verified, 10:Promote-Pay, 11:Promote-Commission,
  Future<void> loadTable(RequestStatus tabStatus) async {
    _isRequest = true;
    print(tabStatus.value);
    setBusy(true);
    _selectedString = tabStatus.value;

    try {
      final res = await _apiService.getClientRequest(tabStatus.apiCode);
      requests = res.data ?? [];
      print("Total requests fetched: ${requests.length}");
      final filteredData = requests.where((e) {
        final apiStatus = e.status; // INT from backend
        return tabStatus.filterBackendCodes.contains(apiStatus);
      }).toList();

      requests = filteredData;
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
          onPaymentDialog,
          onGotoPromoteCommission,
          onClientPaymentVerified,
          onReAssign,
          onBankDetails,
          infReject,
          showNote);

      _isRequest = false;
    } catch (e) {
      requests = [];
      tableSource = RequestTableSource([],
          tabStatus.value,
          onReject,
          onWaiting,
          onProceed,
          onPreparing,
          onGoToPromoteVerified,
          onRevoke,
          onGotoPromotePay,
          onPaymentDialog,
          onGotoPromoteCommission,
          onClientPaymentVerified,
          onReAssign,
          onBankDetails,
          infReject,
          showNote);

      _isRequest = false;
    }
    getInfluencers();
    setBusy(false);
    notifyListeners();
  }

  void searchRequests(String value) {
    if (value.isEmpty) {
      filteredData = List.from(requests);
    } else {
      filteredData = requests.where((e) {
        final service = (e.client ?? "").toString().toLowerCase();
        final client = (e.inf?.name ?? "").toLowerCase();
        final infId = (e.inf?.infId ?? "").toString().toLowerCase();
        final phone = (e.inf?.phone ?? "").toString().toLowerCase();
        final projectId = (e.projectId ?? "").toString().toLowerCase();
        final search = value.toLowerCase();

        return service.contains(search) ||
            client.contains(search) ||
            infId.contains(search) ||
            phone.contains(search) ||
            projectId.contains(search);
      }).toList();
    }

    tableSource = RequestTableSource(
        filteredData,
        _selectedString!,
        onReject,
        onWaiting,
        onProceed,
        onPreparing,
        onGoToPromoteVerified,
        onRevoke,
        onGotoPromotePay,
        onPaymentDialog,
        onGotoPromoteCommission,
        onClientPaymentVerified,
        onReAssign,
        onBankDetails,
        infReject,
        showNote);
    notifyListeners();
  }

  void applySort(bool specialFilter, String sortType) {
    if (sortType == "A-Z") {
      filteredData.sort((a, b) =>
          (a.client ?? "").toString().compareTo(b.client.toString() ?? ""));
    } else if (sortType == "clientAsc") {
      filteredData.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
    } else if (sortType == "older") {
      filteredData.sort((a, b) {
        DateTime aDate = a.createdAt != null
            ? DateTime.parse(a.createdAt!.toString())
            : DateTime(1970);

        DateTime bDate = b.createdAt != null
            ? DateTime.parse(b.createdAt!.toString())
            : DateTime(1970);

        return aDate.compareTo(bDate);
      });
    } else if (sortType == "newer") {
      filteredData.sort((a, b) {
        DateTime aDate = a.createdAt != null
            ? DateTime.parse(a.createdAt!.toString())
            : DateTime(1970);

        DateTime bDate = b.createdAt != null
            ? DateTime.parse(b.createdAt!.toString())
            : DateTime(1970);

        return bDate.compareTo(aDate);
      });
    }
    tableSource = RequestTableSource(
        filteredData,
        _selectedString!,
        onReject,
        onWaiting,
        onProceed,
        onPreparing,
        onGoToPromoteVerified,
        onRevoke,
        onGotoPromotePay,
        onPaymentDialog,
        onGotoPromoteCommission,
        onClientPaymentVerified,
        onReAssign,
        onBankDetails,
        infReject,
        showNote);

    // 🔥 notify UI
    print("Applied sort: $sortType, specialFilter: $specialFilter");

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
              label: Text("Inf_name \n /Inf_ID / Inf_No"),
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
          DataColumn(label: Text("Inf Reject")),
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
          DataColumn(label: Text("Action")),
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
          DataColumn(label: Text("link")),
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
          DataColumn(
              label: Text("Action"),
              headingRowAlignment: MainAxisAlignment.center),
        ];
      case "client_payment_verified":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("client_name")),
          DataColumn(label: Text("client_Phone")),
          DataColumn(label: Text("Payment amount")),
          DataColumn(label: Text("Commission Amount")),
          DataColumn(
              label: Text("Action"),
              headingRowAlignment: MainAxisAlignment.center),
        ];

      default:
        return [];
    }
  }

  Future<void> statusChange(data) async {
    setBusy(true);
    _isRequest = true;
    final req = {
      "id": data["id"],
      "status": data["status"],
      "client_id": data["client_id"],
      "category_id": data["category_id"],
    };

    try {
      final res = await _apiService.statusChange(req);
      await onRefresh();
    } catch (e) {
      _isRequest = false;
    } finally {}
    setBusy(false);
    _isRequest = false;
    notifyListeners();
  }

  Future<void> waitingAccept(data) async {
    setBusy(true);
    _isRequest = true;
    final req = {
      "id": data["id"],
      "status": data["status"],
      "payment": data["data"]["payment"],
      "verification": data["data"]["verification"],
    };

    try {
      final res = await _apiService.waitingAccept(req);
      await onRefresh();
    } catch (e) {
      _isRequest = false;
    } finally {}
    setBusy(false);
    _isRequest = false;
    notifyListeners();
  }

  Future<void> paymentStatusChange(data) async {
    setBusy(true);
    _isRequest = true;
    final req = {
      "id": data["id"],
      "payment_date": data["payment_date"] ?? "",
      "payment_status": data["payment_status"] == "Paid" ? 3 : 0
    };

    try {
      final res = await _apiService.paymentStatusChange(req);
      await onRefresh();
    } catch (e) {
      _isRequest = false;
    } finally {}
    setBusy(false);
    _isRequest = false;
    notifyListeners();
  }

  Future<void> assignInfluencer(data) async {
    setBusy(true);
    _isRequest = true;
    try {
      final res = await _apiService.clientReAssign(data);
      await onRefresh();
    } catch (e) {
      _isRequest = false;
    } finally {}
    setBusy(false);
    _isRequest = false;
    notifyListeners();
  }

  /// functions
  /// request & waiting
  onReject(request_model.Datum model) {
    showRejectConfirmationDialog(
        context: StackedService.navigatorKey!.currentContext!,
        itemName: "${model.projectId}",
        onConfirm: () async {
          final data = {
            "id": model.id,
            "status": 8,
            "client_id": model.client!.id,
            "category_id": model.category
          };
          await statusChange(data);
        });
  }

  //reAssign

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
      onConfirm: () {
        final data = {
          "id": model.id,
          // "status": 12,
          "status": 2,
          "client_id": model.client!.id,
        };
        statusChange(data);
      },
    );
  }

  onBankDetails(request_model.Datum model) {
    if (model.inf == null) {
      Fluttertoast.showToast(msg: "No bank details available");
      return;
    }

    showBankDetailsDialog(
      context: StackedService.navigatorKey!.currentContext!,
      bankDetails: model.inf!,
    );
  }

  void showBankDetailsDialog({
    required request_model.Inf bankDetails,
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        dynamic details;

        details = bankDetails;
        // if (bankDetails is List && bankDetails.isNotEmpty) {
        //   details = bankDetails.first;
        // } else {}

        return AlertDialog(
          title: const Text("Bank Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailRow(
                "Account Holder Name",
                details.holderName,
              ),
              _detailRow(
                "Account Number",
                details.accountNumber,
              ),
              _detailRow(
                "IFSC Code",
                details.ifscCode,
              ),
              _detailRow("UPI id", details.upiId),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(
    String label,
    String? value, {
    TextStyle? labelStyle,
    TextStyle? valueStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: "$label: ",
                style: labelStyle ?? fontFamilySemiBold.size13.black),
            TextSpan(
                text: value?.isNotEmpty == true ? value! : "-",
                style: valueStyle ?? fontFamilyMedium.size13.grey),
          ],
        ),
      ),
    );
  }

  //waiting accept
  onProceed(request_model.Datum model) {
    showAdminPaymentConfigDialog(
      context: StackedService.navigatorKey!.currentContext!,
      onSave: (data) {
        debugPrint(data.toString());
        final datas = {
          "id": model.id,
          "status": 12,
          // "status": 3,
          "data": data
        };
        waitingAccept(datas);
        print(datas);
      },
    );
  }

  showNote(request_model.Datum model) {
    print("Note: ${model.payment?.note}");
    showAPaymentConfigDialog(
      context: StackedService.navigatorKey!.currentContext!,
      note: model.payment?.note ?? "",
      instagram: model.promotion?.instagram != null ? true : false,
      facebook: model.promotion?.facebook != null ? true : false,
      youtube: model.promotion?.youtube != null ? true : false,
    );
  }

  //completed-pending
  onPreparing(request_model.Datum model) async {
    final result = await showStatusDialog(
      StackedService.navigatorKey!.currentContext!,
    );

    if (result != null) {
      print("Selected status: ${result['name']}");
      final data = {
        "id": model.id,
        "status": result['name'] == "Completed" ? 6 : 5,
        "client_id": model.client!.id,
      };
      statusChange(data);
    }
  }

  infReject(request_model.Datum model) {
    showActionConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      title: 'Influencer Reject',
      confirmText: "Reject",
      message:
          "Are you sure the influencer wants to reject the ${model.projectId}?",
      icon: Icons.cancel,
      confirmColor: Colors.red,
      onConfirm: () {
        final data = {
          "id": model.id,
          "status": 7,
          "client_id": model.client!.id,
          "category_id": model.category
        };
        statusChange(data);
      },
    );
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
      onConfirm: () {
        final data = {
          "id": model.id,
          "status": 9,
          // "status": 12,
          "client_id": model.client!.id,
        };
        statusChange(data);
      },
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
      onConfirm: () {
        final data = {
          "id": model.id,
          "status": 4,
          "client_id": model.client!.id,
        };
        statusChange(data);
      },
    );
  }

  onReAssign(request_model.Datum model) async {
    final selected = await showReassignInfluencerDialog(
        context: StackedService.navigatorKey!.currentContext!,
        influencers: influencers,
        currentInfluencerId: model.inf!.ids,
        assignedInfluencerIds: assignedInfluencerIds);

    if (selected != null) {
      print("Selected Influencer ID: ${selected.id}");
      final data = {
        "client_project_id": model.id,
        "inf_id": selected.id,
        "status": 3
      };
      await assignInfluencer(data);
      print(data);
    }
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
      onConfirm: () {
        final data = {
          "id": model.id,
          "status": 10,
          "client_id": model.client!.id,
        };
        statusChange(data);
      },
    );
  }

  onGotoPromoteCommission(request_model.Datum model) {
    showActionConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      title: 'Promote Commission',
      confirmText: "Go to Promote Commission",
      image: "assets/images/pay.svg",
      message:
          "Are you sure you move to Promote Commission the ${model.projectId} to the Promote Pay section?",
      icon: Icons.free_cancellation,
      confirmColor: publisButtonColor,
      onConfirm: () {
        final data = {
          "id": model.id,
          "status": 11,
          "client_id": model.client!.id,
        };
        statusChange(data);
      },
    );
  }

  void onPaymentDialog(request_model.Datum model) {
    showPaymentStatusDialog(
      context: StackedService.navigatorKey!.currentContext!,
      onConfirm: (result) {
        final status = result['status'];
        final paymentDate = result['paymentDate'];

        print("Status Name : ${status['name']}");
        print("Payment Date: $paymentDate");

        final data = {
          "id": model.id,
          "payment_status": status['name'],
          "payment_date":
              DateFormat('yyyy-MM-dd').format(paymentDate ?? DateTime.now()),
        };

        // API call here 👇
        paymentStatusChange(data);
      },
    );
  }

  onClientPaymentVerified(request_model.Datum model) {
    showActionConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      title: 'Client Payment Verified',
      confirmText: "Client Payment Verified",
      image: "assets/images/pay.svg",
      message:
          "Are you sure you want to move the ${model.projectId} to the waiting accept section?",
      icon: Icons.free_cancellation,
      confirmColor: publisButtonColor,
      onConfirm: () {
        final data = {
          "id": model.id,
          "status": 3,
          // "status": 9,
          "client_id": model.client!.id,
        };
        print("data client id $data");
        statusChange(data);
      },
    );
  }

  Future<void> onRefresh() async {
    setSelected(_isSelected);
  }
}

// 1:Request,
//2:Request-Waiting,
//3:Waiting-Accept,
//4:Completed-Pending,
//5:Rework,
//6:Completed,
//7:inf-cancelled,
//8:Admin-Rejected,
//9:Promote-Verified,
//10:Promote-Pay,
//11:Promote-Commission
