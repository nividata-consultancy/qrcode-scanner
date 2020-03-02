import 'package:flutter/material.dart';

String mailTo = '''mailto:info@nividata.com?subject=Feedback for QR code''';

const String sqr1 = "Click on the scan icon of Left-Bottom of the home screen.";
const String sqr2 = "Click on the Camera icon.";
const String sqr3 = "Allow Camera permission.";
const String sqr4 = "Scan QR code.";

const String gqr1 = "User can generate following QR code...";
const String gqr11 = "   -Phone number";
const String gqr12 = "   -Personal Visiter card";
const String gqr13 = "   -Web Site URL";
const String gqr14 = "   -Text Message";
const String gqr15 = "   -Wifi";
const String gqr16 = "   -Email";
const String gqr2 =
    "Select any category form home screen, add appropriate details and click on Generate QR code button.";

const double kBottomContainerHeight = 80.0;
const Color kBottomContainerColor = Color(0xFFEB1555);
const Color kActiveCardColor = Color(0xFF1D1E33);
const Color kInactiveCardColor = Color(0xFF111328);
String platformVersion = "";

const kLabelTextStyle = TextStyle(
  fontSize: 20.0,
  color: Color(0xFF8D8E98),
);

const listHeading =
    TextStyle(fontSize: 18.0, color: Colors.grey, fontWeight: FontWeight.w900);

const listTitle = TextStyle(
    fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.normal);

const listTrailing =
    TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.w900);

const kNumberTextStyle = TextStyle(
    color: Color.fromRGBO(86, 81, 104, 1),
    fontSize: 50.0,
    fontWeight: FontWeight.w900);

const kTitleTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
);

const kResultTextStyle = TextStyle(
  color: Color(0xFF24D876),
  fontSize: 22.0,
  fontWeight: FontWeight.bold,
);

const kBMITextStyle = TextStyle(
  fontSize: 100.0,
  fontWeight: FontWeight.bold,
);

const kResultBodyTextStyle = TextStyle(
  fontSize: 22.0,
);
