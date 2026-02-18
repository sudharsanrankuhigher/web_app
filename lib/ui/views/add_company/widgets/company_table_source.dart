import 'package:flutter/material.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/views/add_company/model/company_model.dart'
    as company_model;
import 'package:webapp/widgets/profile_image.dart';

class CompanyTableSource extends DataTableSource {
  final List<company_model.Datum> companies;
  final Function(company_model.Datum) onView;
  final Function(company_model.Datum)? showBankDetails;

  CompanyTableSource({
    required this.companies,
    required this.onView,
    this.showBankDetails,
  });

  @override
  DataRow? getRow(int index) {
    // if (index >= plans.length) return null;
    if (companies.isEmpty) {
      return DataRow(
        cells: List.generate(
          10, // total columns
          (i) {
            if (i == 5) {
              // column index where message should show
              return const DataCell(
                Center(
                  child: Text(
                    "No data found",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }
            return const DataCell(Text("")); // other cells empty
          },
        ),
      );
    }

    final company = companies[index];
    final sNo = index + 1;

    return DataRow(
        color: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (index.isEven) return Colors.white;
            return Colors.grey.shade100;
          },
        ),
        cells: [
          DataCell(Text("$sNo")),
          DataCell(Center(
            child: Padding(
              padding: defaultPadding4,
              child: IgnorePointer(
                ignoring: true,
                child: ProfileImageEdit(
                  imageUrl: company.companyImage,
                  radius: 20,
                  onImageSelected: (_, a) {},
                ),
              ),
            ),
          )),
          DataCell(Text("${company.companyName}")),
          DataCell(Text("${company.clientName}")),
          DataCell(Text("${company.phone}")),
          DataCell(Text("${company.altPhoneNo}")),
          DataCell(Text("${company.city} / ${company.state}")),
          DataCell(Text("${company.gstNo}")),
          DataCell(
            InkWell(
              onTap: () => showBankDetails!(company),
              child: Text(
                company.bankDetails != null
                    ? company.bankDetails!.upi?.toString() ?? ""
                    : "",
              ),
            ),
          ),
          DataCell(Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: const Icon(
                    Icons.visibility,
                    size: 16,
                    color: Colors.blue,
                  ),
                  onPressed: () => onView(company)),
            ],
          )),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => companies.isEmpty ? 1 : companies.length;

  @override
  int get selectedRowCount => 0;
}
