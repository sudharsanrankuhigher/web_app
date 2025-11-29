import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/client_project_info_card.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/dash_board_card.dart';
import 'package:webapp/widgets/info_card.dart';
import 'package:webapp/widgets/monthly_bar_chart.dart';

import 'dash_board_viewmodel.dart';

class DashBoardView extends StackedView<DashBoardViewModel> {
  const DashBoardView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DashBoardViewModel viewModel,
    Widget? child,
  ) {
    final bool isExtended = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        // <-- Scroll enabled
        child: Padding(
          padding: defaultPadding12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  DashBoardCard(
                    title: 'Total Client Projects',
                    count: '00',
                    icon: Icons.wallet,
                    subtitle: '+0% From last month',
                  ),
                  DashBoardCard(
                    title: 'Active Clients',
                    count: '10',
                    icon: Icons.person,
                    subtitle: '+5% From last month',
                  ),
                  DashBoardCard(
                    title: 'Pending Tasks',
                    count: '07',
                    icon: Icons.task,
                    subtitle: '+2% From last month',
                  ),
                  DashBoardCard(
                    title: 'Completed',
                    count: '50',
                    icon: Icons.check_circle,
                    subtitle: '+12% From last month',
                  ),
                ],
              ),
              verticalSpacing12,
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  Card(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      height: 350,
                      child: Container(
                        padding: defaultPadding12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: white,
                            boxShadow: [BoxShadow(color: disableColor)]),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Monthly Sales',
                                  style: fontFamilySemiBold.size16.black,
                                ),
                                CommonButton(
                                  padding: defaultPadding4,
                                  height: 40,
                                  width: 100,
                                  text: '2025',
                                  buttonColor: appGreen600,
                                  textStyle: fontFamilySemiBold.size14.white,
                                )
                              ],
                            ),
                            MonthlyBarChart(
                              ongoing: [
                                20000,
                                30000,
                                15000,
                                50000,
                                25000,
                                40000,
                                45000,
                                30000,
                                35000,
                                60000,
                                70000,
                                80000,
                              ],
                              completed: [
                                10000,
                                25000,
                                10000,
                                30000,
                                20000,
                                30000,
                                35000,
                                20000,
                                30000,
                                45000,
                                60000,
                                75000,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // RIGHT (Widget)
                  Card(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.26,
                      height: 350,
                      child: Container(
                        padding: defaultPadding12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: white,
                          boxShadow: [BoxShadow(color: disableColor)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Client Project Count',
                              style: fontFamilySemiBold.size16.black,
                            ),
                            verticalSpacing20,
                            ClientProjectInfoCard(
                              boxColor: greenShade,
                              dotColor: appGreen500,
                              text: isExtended ? "Completed" : "",
                              textColor: Colors.green[600]!,
                              count: "50",
                              countColor: Colors.black,
                            ),
                            ClientProjectInfoCard(
                              boxColor: Colors.blue[50]!,
                              dotColor: Colors.blue[500]!,
                              text: isExtended ? "Ongoing" : "",
                              textColor: Colors.blue[600]!,
                              count: "10",
                              countColor: Colors.black,
                            ),
                            ClientProjectInfoCard(
                              boxColor: pendingColorShade,
                              dotColor: pendingColor,
                              text: isExtended ? "Pending" : "",
                              textColor: Colors.blue[600]!,
                              count: "12",
                              countColor: Colors.black,
                            ),
                            ClientProjectInfoCard(
                              boxColor: participatedColor,
                              dotColor: participatedTextColor,
                              text: isExtended ? "Monthly Project" : "",
                              textColor: Colors.blue[600]!,
                              count: "19",
                              countColor: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpacing20,
              Text(
                'Promote Projects Clients',
                style: fontFamilySemiBold.size18.black,
              ),
              InfoCard(
                boxColor: pendingColor,
                count: '00',
                icon: Icons.check_circle,
                text: 'Completed',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  DashBoardViewModel viewModelBuilder(BuildContext context) =>
      DashBoardViewModel();
}
