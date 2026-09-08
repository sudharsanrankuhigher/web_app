import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webapp/app/app.locator.dart';
import 'package:webapp/core/enum/requested_status.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/services/api_service.dart';
import 'dart:typed_data';
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
    // Moved to onViewModelReady in RequestsView
  }
  DateTime selectedMonth = DateTime.now();
  String? _selectedString = RequestStatus.requested.value;
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
    RequestStatus.refund,
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
  Future<void> loadTable(RequestStatus tabStatus, {bool getAll = false}) async {
    _isRequest = true;
    print(tabStatus.value);
    setBusy(true);

    try {
      final formattedMonth = DateFormat('yyyy-MM').format(selectedMonth);
      final res = await _apiService.getClientRequest(tabStatus.apiCode,
          month: getAll ? null : formattedMonth);

      // Prevent updating UI state if the user switched tabs during load
      if (_isSelected != _tabs.indexOf(tabStatus)) {
        print("Ignoring outdated response for ${tabStatus.value}");
        return;
      }

      requests = res.data ?? [];
      print("Total requests fetched: ${requests.length}");
      filteredData = requests.where((e) {
        final apiStatus = e.status; // INT from backend
        return tabStatus.filterBackendCodes.contains(apiStatus);
      }).toList();

      requests = filteredData;
      _selectedString = tabStatus.value;
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
        onRefund,
        onRefundDialog,
        showNote,
        onWaitingNotesEdit: onWaitingNotesEdit,
      );

      _isRequest = false;
    } catch (e) {
      if (_isSelected != _tabs.indexOf(tabStatus)) {
        print("Ignoring outdated catch block for ${tabStatus.value}");
        return;
      }

      requests = [];
      _selectedString = tabStatus.value;
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
        onPaymentDialog,
        onGotoPromoteCommission,
        onClientPaymentVerified,
        onReAssign,
        onBankDetails,
        infReject,
        onRefund,
        onRefundDialog,
        showNote,
        onWaitingNotesEdit: onWaitingNotesEdit,
      );

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
        final clientName = (e.client?.name ?? "").toLowerCase();
        final clientPhone = (e.client?.mobileNumber ?? "").toLowerCase();
        final infName = (e.inf?.name ?? "").toLowerCase();
        final infId = (e.inf?.infId ?? "").toString().toLowerCase();
        final infPhone = (e.inf?.phone ?? "").toString().toLowerCase();
        final projectId = (e.projectId ?? "").toString().toLowerCase();
        final requestId = (e.id ?? "").toString().toLowerCase();
        final search = value.toLowerCase();

        return clientName.contains(search) ||
            clientPhone.contains(search) ||
            infName.contains(search) ||
            infId.contains(search) ||
            infPhone.contains(search) ||
            projectId.contains(search) ||
            requestId.contains(search);
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
      onRefund,
      onRefundDialog,
      showNote,
      onWaitingNotesEdit: onWaitingNotesEdit,
    );
    notifyListeners();
  }

  void applySort(bool specialFilter, String sortType) {
    if (sortType == "A-Z") {
      filteredData.sort((a, b) => (a.client?.name ?? "")
          .toLowerCase()
          .compareTo((b.client?.name ?? "").toLowerCase()));
      requests.sort((a, b) => (a.client?.name ?? "")
          .toLowerCase()
          .compareTo((b.client?.name ?? "").toLowerCase()));
    } else if (sortType == "clientAsc") {
      filteredData.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
      requests.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
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
      requests.sort((a, b) {
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
      requests.sort((a, b) {
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
      onRefund,
      onRefundDialog,
      showNote,
      onWaitingNotesEdit: onWaitingNotesEdit,
    );

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
          DataColumn(label: Text("Client request")),
          DataColumn(
              label: Text("Inf_ID / Inf_No"),
              headingRowAlignment: MainAxisAlignment.center),
          DataColumn(label: Text("Requested Date")),
          DataColumn(
              label: Text("Reject"),
              headingRowAlignment: MainAxisAlignment.center),
          DataColumn(
              label: Text("Proceed"),
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
          DataColumn(label: Text("Notes")),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.center,
            label: SizedBox(
              width: 120,
              child: Text(
                "Action",
                textAlign: TextAlign.center,
              ),
            ),
          ),
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
          DataColumn(label: Text("Notes")),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.center,
            label: SizedBox(
              width: 150,
              child: Text(
                "Action",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          DataColumn(
              label: Text("Cancel"),
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
          DataColumn(label: Text("Notes")),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.center,
            label: SizedBox(
              width: 150,
              child: Text(
                "Action",
                textAlign: TextAlign.center,
              ),
            ),
          ),
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
          DataColumn(label: Text("Notes")),
          DataColumn(
              label: Text("Revoke"),
              headingRowAlignment: MainAxisAlignment.center),
          DataColumn(
              label: Text("Reassign"),
              headingRowAlignment: MainAxisAlignment.center),
          DataColumn(
              label: Text("Refunded"),
              headingRowAlignment: MainAxisAlignment.center),
        ];

      // 7. Rejected
      case "rejected":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Client Phone")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Influencer Phone")),
          DataColumn(label: Text("Requested Date")),
          DataColumn(label: Text("Rejected Date")),
          DataColumn(label: Text("Notes")),
          DataColumn(
              label: Text("Revoke"),
              headingRowAlignment: MainAxisAlignment.center),
          DataColumn(
              label: Text("Reassign"),
              headingRowAlignment: MainAxisAlignment.center),
          // DataColumn(
          //     label: Text("Refunded"),
          //     headingRowAlignment: MainAxisAlignment.center),
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
          DataColumn(label: Text("Notes")),
          DataColumn(
              label: Text("Doc"),
              headingRowAlignment: MainAxisAlignment.center),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.center,
            label: SizedBox(
              width: 180,
              child: Text(
                "Action",
                textAlign: TextAlign.center,
              ),
            ),
          ),
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
          DataColumn(label: Text("GST Amount")),
          DataColumn(label: Text("Notes")),
          DataColumn(
              label: Text("Doc"),
              headingRowAlignment: MainAxisAlignment.center),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.center,
            label: SizedBox(
              width: 180,
              child: Text(
                "Action",
                textAlign: TextAlign.center,
              ),
            ),
          ),
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
          DataColumn(label: Text("GST Amount")),
          DataColumn(label: Text("Notes")),
          DataColumn(
              label: Text("Doc"),
              headingRowAlignment: MainAxisAlignment.center),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.center,
            label: SizedBox(
              width: 180,
              child: Text(
                "Action",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ];

      // 11. Client Payment Verified
      case "client_payment_verified":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("client")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Total amount")),
          DataColumn(label: Text("Payment amount")),
          DataColumn(label: Text("Commission Amount")),
          DataColumn(label: Text("GST Amount")),
          DataColumn(label: Text("Notes")),
          DataColumn(
              label: Text("Doc"),
              headingRowAlignment: MainAxisAlignment.center),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.center,
            label: SizedBox(
              width: 180,
              child: Text(
                "Action",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ];

      //13: Refund
      case "refund":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("client_name")),
          DataColumn(label: Text("client_Phone")),
          DataColumn(label: Text("Refund amount")),
          DataColumn(label: Text("Refunded created")),
          DataColumn(label: Text("Refunded completed")),
          DataColumn(
            label: Text("status"),
            // headingRowAlignment: MainAxisAlignment.center
          ),
          DataColumn(label: Text("Notes")),
          DataColumn(
            headingRowAlignment: MainAxisAlignment.center,
            label: SizedBox(
              width: 150,
              child: Text(
                "Action",
                textAlign: TextAlign.center,
              ),
            ),
          ),
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
      "link": data["link"] ?? "",
      "remark": data["remark"] ?? "",
      if (data["image"] != null) "image": data["image"],
      if (data["revert_status"] != null) "revert_status": data["revert_status"],
      if (data['client_payment_verified'] != null)
        "client_payment_verified": data['client_payment_verified'],
    };

    print("data request $req");

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
  onReject(request_model.Datum model, {bool isWaiting = false}) {
    showRejectConfirmationDialog(
        context: StackedService.navigatorKey!.currentContext!,
        itemName: "${model.projectId}",
        onConfirm: () async {
          final data = {
            "id": model.id,
            "status": 8,
            "client_id": model.client!.id,
            "category_id": model.category,
            "revert_status": isWaiting,
          };
          await statusChange(data);
        });
  }

  //waiting
  onWaiting(request_model.Datum model) {
    showActionConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      title: 'Move to Waiting',
      confirmText: "Move",
      showNotesField: true,
      message:
          "Are you sure you want to move the ${model.projectId} to the waiting section?",
      icon: Icons.hourglass_top,
      confirmColor: Colors.green,
      onConfirm: (notes) {
        final data = {
          "id": model.id,
          // "status": 12,
          "status": 2,
          "client_id": model.client!.id,
          "remark": notes,
        };
        statusChange(data);
      },
    );
  }

  Future<void> onWaitingNotesEdit(request_model.Datum model) async {
    final result = await showWaitingNotesDialog(model);
    if (result != null) {
      final data = {
        "id": model.id,
        "status": 2,
        "client_id": model.client!.id,
        "remark": result,
      };
      await statusChange(data);
    }
  }

  Future<String?> showWaitingNotesDialog(request_model.Datum model) {
    final context = StackedService.navigatorKey!.currentContext!;
    final controller = TextEditingController(text: model.notes ?? "");

    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("Edit Remark for Project ${model.projectId}"),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: "Enter remark...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: publisButtonColor,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, controller.text);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  //reFunded

  onRefund(request_model.Datum model) {
    showActionConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      title: 'Refunded',
      confirmText: "Refund",
      showNotesField: true,
      message:
          "Are you sure you want to move the ${model.projectId} to the refunded section?",
      icon: Icons.hourglass_top,
      confirmColor: Colors.green,
      onConfirm: (notes) {
        final data = {
          "id": model.id,
          "status": 13,
          "client_id": model.client!.id,
          "remark": notes,
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
    final promo = model.promotion;

    bool hasInstagram = promo?.raw.containsKey("instagram") ?? false;
    bool hasFacebook = promo?.raw.containsKey("facebook") ?? false;
    bool hasYoutube = promo?.raw.containsKey("youtube") ?? false;

    showAPaymentConfigDialog(
      context: StackedService.navigatorKey!.currentContext!,
      note: model.payment?.note ?? "",
      instagram: hasInstagram,
      facebook: hasFacebook,
      youtube: hasYoutube,
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
        "link":
            model.promotion?.raw.map((key, value) => MapEntry(key, null)) ?? {},
      };
      print(data);
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
          "category_id": model.category,
          "client_payment_verified": true
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
    if (model.connection == null || model.connection == 0) {
      Fluttertoast.showToast(msg: "Cannot Revoke this request connection is 0");
      return;
    }
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
          "status": model.revertStatus == true ? 2 : 3,
          "category_id": model.category,
          "client_id": model.client!.id,
          "client_payment_verified": model.revertStatus == true ? false : true
        };
        statusChange(data);
      },
    );
  }

  onReAssign(request_model.Datum model) async {
    if (model.connection == null || model.connection == 0) {
      Fluttertoast.showToast(
          msg: "Cannot Reassign this request connection is 0");
      return;
    }
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
        "status": model.revertStatus == true ? 2 : 3,
        "client_payment_verified": model.revertStatus == true ? false : true
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
      previewImage: true,
      onConfirm: (Uint8List? bytes, String? path) {
        final data = {
          "id": model.id,
          "status": 3,
          "client_id": model.client!.id,
          if (bytes != null || path != null) "image": bytes ?? path,
        };
        print("data client id $data");
        statusChange(data);
      },
    );
  }

  onRefundDialog(request_model.Datum model) {
    showActionConfirmationDialog(
      context: StackedService.navigatorKey!.currentContext!,
      title: 'Refunded',
      confirmText: "Refunded",
      image: "assets/images/pay.svg",
      message:
          "Are you sure you want to completed refund for the ${model.projectId} project?",
      icon: Icons.free_cancellation,
      confirmColor: publisButtonColor,
      onConfirm: () async {
        await _apiService.refundStatus(model.id);
        await onRefresh();
      },
    );
  }

  Future<void> onRefresh({bool getAll = false}) async {
    loadTable(_tabs[_isSelected], getAll: getAll);
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
//12:client-payment-verified
//13:refunded
