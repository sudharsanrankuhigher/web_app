import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:webapp/ui/common/shared/styles.dart';
import 'package:webapp/ui/common/shared/text_style_helpers.dart';
import 'package:webapp/widgets/common_button.dart';
import 'package:webapp/widgets/initial_textform.dart';

import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Card(
        elevation: 5,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
            ),
            padding: defaultPadding10,
            child: Container(
              padding: defaultPadding10,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Color(0xffEEF3FA),
                      Colors.white,
                    ]),
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 350,
                    alignment: Alignment.center,
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          WidgetSpan(
                              child: Image.asset(
                            'assets/images/logo.png',
                            height: 35,
                          )),
                          const WidgetSpan(child: horizontalSpacing12),
                          TextSpan(
                              text: 'Promote',
                              style: fontFamilyBold.size30.blueText),
                          TextSpan(
                              text: 'app', style: fontFamilyBold.size30.black)
                        ])),
                  ),
                  verticalSpacing12,
                  Text(
                    textAlign: TextAlign.left,
                    "Admin panel",
                    style: fontFamilyBold.size18.black,
                  ),
                  verticalSpacing40,
                  Text(
                    'Email Address',
                    style: fontFamilySemiBold.size16.black,
                  ),
                  verticalSpacing8,
                  SizedBox(
                      width: 350,
                      child: InitialTextForm(
                        preffixIcon: const Icon(
                          Icons.mail_outline,
                          color: disableColor,
                        ),
                        hintText: 'Enter email address',
                        fillColor: Color(0xff01B8F91A),
                        radius: 10.r,
                      )),
                  verticalSpacing12,
                  Text(
                    'Password',
                    style: fontFamilySemiBold.size16.black,
                  ),
                  verticalSpacing8,
                  SizedBox(
                      width: 350,
                      child: InitialTextForm(
                        preffixIcon:
                            const Icon(Icons.lock_outline, color: disableColor),
                        hintText: 'Enter password',
                        fillColor: Color(0xff01B8F91A),
                        radius: 10.r,
                      )),
                  verticalSpacing20,
                  verticalSpacing20,
                  CommonButton(
                    height: 45,
                    width: 350,
                    text: 'Continue',
                    textStyle: fontFamilySemiBold.size16.white,
                    buttonColor: continueButton,
                    onTap: () => viewModel.goHome(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();
}
