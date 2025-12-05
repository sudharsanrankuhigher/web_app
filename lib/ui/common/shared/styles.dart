import 'package:flutter/material.dart';

//colors
const backgroundColor = Color(0xFFF5FFFA);
const disableColor = Color(0xFFD9D9D9);
const button1 = Color(0xFF43E594);
const button2 = Color(0xFF368E62);
const white = Colors.white;
const previewButton = Color(0xFFDAE6FF);
const backwhite = Color(0xFFFFFFFF);
const lightGrey = Color(0xFFF6F6F6);
const grey = Colors.grey;
const greyStepper = Color(0xFFE7E7E7);
const red = Colors.red;
const redShade = Color(0xFFFED2D2);
const greenShade = Color(0xFFD3FFC7);
const greenLightShade = Color(0xFFEDFDF5);
const lightContainer = Color(0xFFF6F6F6);
const lightContainerBorder = Color(0xFFE2E2E2);
const lightText = Color(0xFF545454);
const continueButton = Color(0xFF2563EB);
const pendingColor = Color(0xFFD3600D);
const activeColor = Color(0xFFB22BFF);
const completedColor = Color(0xFF0D9B50);
const pendingColorShade = Color(0xFFFFF5D8);
const activeColorShade = Color(0xFFF8EDFF);
const completedColorShade = Color(0xFFEDFDF5);
const participatedColor = Color(0xFFC594F5);
const missedColor = Color(0xFFFFD5A2);
const availableCampaignColor = Color(0xFFCFE4A3);
const totalIncomMonthColor = Color(0xFFFFB2E6);
const potentialMonthColor = Color(0xFFFFB1B1);
const publisButtonColor = Color(0xFF039CD3);

const participatedTextColor = Color(0xFF4D0792);
const missedTextColor = Color(0xFFC06B03);
const availableCampaignTextColor = Color(0xFF659108);
const totalIncomMonthTextColor = Color(0xFFE419A3);
const potentialMonthTextColor = Color(0xFFD80000);

const appGreen50 = Color(0xFFF0FDF6);
const appGreen100 = Color(0xFFDCFCEB);
const appGreen200 = Color(0xFFBBF7D7);
const appGreen300 = Color(0xFF86EFB9);
const appGreen400 = Color(0xFF4ADE92);
const appGreen500 = Color(0xFF22C572);
const appGreen600 = Color(0xFF16A35B);
const appGreen700 = Color(0xFF178C51);
const appGreenIcons = Color(0xFF0D9B50);
const appGreen800 = Color(0xFF16653E);
const appGreen900 = Color(0xFF145335);
const appGreen950 = Color(0xFF052E1B);
const appGreenText = Color(0xFF16A34A);
const containerGreen = Color(0xFFDCFCEC);

const appSecond50 = Color(0xFFF6F6F6);
const appSecond100 = Color(0xFFE7E7E7);
const appSecond200 = Color(0xFFD1D1D1);
const appSecond300 = Color(0xFFB0B0B0);
const appSecond400 = Color(0xFF888888);
const appSecond500 = Color(0xFF6D6D6D);
const appSecond600 = Color(0xFF5D5D5D);
const appSecond700 = Color(0xFF545454);
const appSecond800 = Color(0xFF454545);
const appSecond900 = Color(0xFF3D3D3D);
const appSecond950 = Color(0xFF262626);

//spacer
const emptySpacing = SizedBox.shrink();
const verticalSpacing4 = SizedBox(height: 4);
const verticalSpacing8 = SizedBox(height: 8);
const verticalSpacing10 = SizedBox(height: 10);
const verticalSpacing12 = SizedBox(height: 12);
const verticalSpacing16 = SizedBox(height: 16);
const verticalSpacing20 = SizedBox(height: 20);
const verticalSpacing40 = SizedBox(height: 40);
const verticalSpacing60 = SizedBox(height: 60);

const horizontalSpacing4 = SizedBox(width: 4);
const horizontalSpacing8 = SizedBox(width: 8);
const horizontalSpacing10 = SizedBox(width: 10);
const horizontalSpacing12 = SizedBox(width: 12);
const horizontalSpacing16 = SizedBox(width: 16);
const horizontalSpacing20 = SizedBox(width: 20);
const horizontalSpacing60 = SizedBox(width: 60);

//padding
const zeroPadding = EdgeInsets.all(0);
const defaultPadding20 = EdgeInsets.all(20);
const defaultPadding16 = EdgeInsets.all(16);
const defaultPadding14 = EdgeInsets.all(14);
const defaultPadding12 = EdgeInsets.all(12);
const defaultPadding10 = EdgeInsets.all(10);
const defaultPadding8 = EdgeInsets.all(8);
const defaultPadding4 = EdgeInsets.all(4);
const defaultPadding2 = EdgeInsets.all(2);
const topPadding40 = EdgeInsets.only(top: 40);
const topPadding30 = EdgeInsets.only(top: 30);
const topPadding20 = EdgeInsets.only(top: 20);
const topPadding18 = EdgeInsets.only(top: 18);
const topPadding16 = EdgeInsets.only(top: 16);
const topPadding12 = EdgeInsets.only(top: 12);
const topPadding10 = EdgeInsets.only(top: 10);
const topPadding8 = EdgeInsets.only(top: 8);
const topPadding6 = EdgeInsets.only(top: 6);
const topPadding4 = EdgeInsets.only(top: 4);
const topPadding2 = EdgeInsets.only(top: 2);
const bottomPadding30 = EdgeInsets.only(bottom: 30);
const bottomPadding20 = EdgeInsets.only(bottom: 20);
const bottomPadding12 = EdgeInsets.only(bottom: 12);
const bottomPadding10 = EdgeInsets.only(bottom: 10);
const bottomPadding8 = EdgeInsets.only(bottom: 8);
const bottomPadding4 = EdgeInsets.only(bottom: 4);
const bottomPadding2 = EdgeInsets.only(bottom: 2);
const rightPadding40 = EdgeInsets.only(right: 40);
const rightPadding30 = EdgeInsets.only(right: 30);
const rightPadding20 = EdgeInsets.only(right: 20);
const rightPadding16 = EdgeInsets.only(right: 16);
const rightPadding12 = EdgeInsets.only(right: 12);
const rightPadding10 = EdgeInsets.only(right: 10);
const rightPadding8 = EdgeInsets.only(right: 8);
const rightPadding4 = EdgeInsets.only(right: 4);
const leftPadding40 = EdgeInsets.only(left: 40);
const leftPadding30 = EdgeInsets.only(left: 30);
const leftPadding20 = EdgeInsets.only(left: 20);
const leftPadding12 = EdgeInsets.only(left: 12);
const leftPadding10 = EdgeInsets.only(left: 10);
const leftPadding8 = EdgeInsets.only(left: 8);
const leftPadding4 = EdgeInsets.only(left: 4);

//Divider
const verticalDivider = VerticalDivider(width: 1.5, color: Colors.black87);
const verticalDivider1 = VerticalDivider(width: 3, color: Colors.black87);
const horizontalDivider = Divider(height: 1.5, color: Colors.black87);
const horizontalDividerLight = Divider(
  height: 1.5,
  color: lightContainerBorder,
);
const horizontalDividerGrey = Divider(height: 1.5, color: Color(0xFFE5E5E5));

//fontFamily

const TextStyle fontFamilyRegular = TextStyle(fontFamily: 'Inter_Regular');
const TextStyle fontFamilyBold = TextStyle(fontFamily: 'Inter_Bold');
const TextStyle fontFamilySemiBold = TextStyle(fontFamily: 'Inter_SemiBold');
const TextStyle fontFamilyMedium = TextStyle(fontFamily: 'Inter_Medium');

TextStyle greenGradientText(TextStyle baseStyle) {
  return baseStyle.copyWith(
    foreground: Paint()
      ..shader = const LinearGradient(
        begin: Alignment(1.0, -1.0),
        end: Alignment(-1.0, 1.0),
        colors: [
          appGreen500, // Start green
          appGreen800, // End green
        ],
      ).createShader(const Rect.fromLTWH(0, 0, 400, 10)),
  );
}

const scale = 1.0;
