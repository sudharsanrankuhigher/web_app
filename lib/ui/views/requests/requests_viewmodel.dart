import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/core/navigation/navigation_mixin.dart';
import 'package:webapp/ui/views/requests/model/request_model.dart';
import 'package:webapp/ui/views/requests/widgets/request_table_source.dart';

class RequestsViewModel extends BaseViewModel with NavigationMixin {
  RequestsViewModel() {
    setSelected(0);
  }
  int _isSelected = 0;
  String? _selectedString;
  int get isSelected => _isSelected;
  String? get selectedString => _selectedString;

  bool? _isRequest = false;
  bool? get isRequest => _isRequest;

  void setSelected(int index) {
    _isRequest = true;
    _isSelected = index;

    switch (index) {
      case 0:
        loadTable("requested");
        break;
      case 1:
        loadTable("pending");
        break;
      case 2:
        loadTable("accepted");
        break;
      case 3:
        loadTable("complete_pending_list");
        break;
      case 4:
        loadTable("completed");
        break;
      case 5:
        loadTable("cancelled");
        break;
      case 6:
        loadTable("rejected");
        break;
      case 7:
        loadTable("promote_verified");
        break;
      case 8:
        loadTable("promote_pay");
        break;
      case 9:
        loadTable("promote_commission");
        break;
      default:
        loadTable("requested");
    }

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
          influencerPhone: '9898984562',
          status: "Completed",
          requestedDate: "10-12-2025",
          completedDate: "12-12-2025",
          cancelledDate: "",
          assignedDate: "11-12-2025",
          influencerBankDetails: "Bank XYZ",
          paymentAmount: "5000",
          commissionAmount: "500",
        ),
        ProjectRequestModel(
          sNo: 2,
          projectCode: "PR002",
          clientName: "ABC Corps",
          clientPhone: "9999999999s",
          influencerId: "INF002",
          influencerName: "John ",
          influencerPhone: '9898986532',
          status: "pending",
          requestedDate: "10-12-2025",
          completedDate: "12-12-2025",
          cancelledDate: "",
          assignedDate: "11-12-2025",
          influencerBankDetails: "Bank XYZABC",
          paymentAmount: "5001",
          commissionAmount: "501",
        ),
      ];

      tableSource = RequestTableSource(requests, status);
      _isRequest = false;
    } catch (e) {
      requests = [];
      tableSource = RequestTableSource(requests, status);
      _isRequest = false;
    }

    setBusy(false);
    notifyListeners();
  }

  List<DataColumn> getColumnsByStatus(String status) {
    switch (status) {
      case "requested":
      case "pending":
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

      case "accepted":
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
      case "complete_pending_list":
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

      case "cancelled":
      case "rejected":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Client Phone")),
          DataColumn(label: Text("Influencer Phone")),
          DataColumn(label: Text("Requested Date")),
          DataColumn(label: Text("Cancelled Date")),
        ];

      case "promote_verified":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Client Phone")),
          DataColumn(label: Text("Influencer Phone")),
          DataColumn(label: Text("Assigned Date")),
        ];

      case "promote_pay":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Completed Date")),
          DataColumn(label: Text("Bank Details")),
          DataColumn(label: Text("Payment Amount")),
          DataColumn(label: Text("Action")),
        ];

      case "promote_commission":
        return const [
          DataColumn(label: Text("S.No")),
          DataColumn(label: Text("Project Code")),
          DataColumn(label: Text("Client")),
          DataColumn(label: Text("Influencer")),
          DataColumn(label: Text("Completed Date")),
          DataColumn(label: Text("Bank Details")),
          DataColumn(label: Text("Commission")),
        ];

      default:
        return [];
    }
  }
}
