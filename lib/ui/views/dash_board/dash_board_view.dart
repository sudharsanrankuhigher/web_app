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
              Container(
                width: double.infinity,
                padding: defaultPadding16,
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                ),
                child: Text(
                  'Dashboard',
                  style: fontFamilyBold.size26.black,
                ),
              ),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  DashBoardCard(
                    title: 'Total Client Projects',
                    count: '00',
                    // icon: Icons.wallet,
                    asset: 'assets/images/total_client_project.png',
                    subtitle: '+0% From last month',
                    textColor: Colors.blueAccent,
                  ),
                  DashBoardCard(
                    title: 'Client Revenue',
                    count: '10',
                    // icon: Icons.person,
                    subtitle: '+5% From last month',
                    asset: 'assets/images/client_revenue.png',
                    textColor: continueButton,
                  ),
                  DashBoardCard(
                    title: 'Promote Revenue',
                    count: '07',
                    // icon: Icons.task,
                    asset: 'assets/images/promote_revenue.png',
                    subtitle: '+2% From last month',
                    textColor: appGreen800,
                  ),
                  DashBoardCard(
                    title: 'Influencers Count',
                    count: '50',
                    // icon: Icons.check_circle,
                    asset: 'assets/images/influencer_count.png',
                    subtitle: '+12% From last month',
                    textColor: red,
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
                      width: isExtended
                          ? MediaQuery.of(context).size.width * 0.55
                          : null,
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
                      width: isExtended
                          ? MediaQuery.of(context).size.width * 0.26
                          : null,
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
                              boxColor: greenShade1.withOpacity(0.10),
                              dotColor: appGreen500,
                              text: "Completed",
                              // text: isExtended ? "Completed" : "",
                              textColor: Colors.green[600]!,
                              count: "50",
                              countColor: Colors.black,
                            ),
                            ClientProjectInfoCard(
                              boxColor: onGoing.withOpacity(0.10),
                              dotColor: onGoing,
                              text: "Ongoing",
                              // text: isExtended ? "Ongoing" : "",
                              textColor: Colors.blue[600]!,
                              count: "10",
                              countColor: Colors.black,
                            ),
                            ClientProjectInfoCard(
                              boxColor: pending.withOpacity(0.10),
                              dotColor: pending,
                              text: "Pending",
                              // text: isExtended ? "Pending" : "",
                              textColor: Colors.blue[600]!,
                              count: "12",
                              countColor: Colors.black,
                            ),
                            ClientProjectInfoCard(
                              boxColor: monthlyProjects.withOpacity(0.10),
                              dotColor: monthlyProjects,
                              text: "Monthly Project",
                              // text: isExtended ? "Monthly Project" : "",
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
              Row(
                children: [
                  Expanded(
                    child: InfoCard(
                      boxColor: pendingColor,
                      count: '00',
                      icon: Icons.check_circle,
                      text: 'Total projects',
                    ),
                  ),
                  horizontalSpacing16,
                  Expanded(
                    child: InfoCard(
                      boxColor: continueButton,
                      count: '00',
                      icon: Icons.check_circle,
                      text: 'Monthly Projects',
                    ),
                  ),
                  horizontalSpacing16,
                  Expanded(
                    child: InfoCard(
                      boxColor: publisButtonColor,
                      count: '00',
                      icon: Icons.check_circle,
                      text: 'In progress',
                    ),
                  ),
                  horizontalSpacing16,
                  Expanded(
                    child: InfoCard(
                      boxColor: appGreen400,
                      count: '00',
                      icon: Icons.check_circle,
                      text: 'Completed',
                    ),
                  ),
                ],
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
