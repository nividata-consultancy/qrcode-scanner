import 'package:flutter/material.dart';
import 'package:qr_code_scanner/res/strings.dart';

class PhoneNumberQR extends StatefulWidget {
  @override
  _PhoneNumberQRState createState() => _PhoneNumberQRState();
}

class _PhoneNumberQRState extends State<PhoneNumberQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(Strings.lbl_phone_number),
      ),
    );
  }
}
