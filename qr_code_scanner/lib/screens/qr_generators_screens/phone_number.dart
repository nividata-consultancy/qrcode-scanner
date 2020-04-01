import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/res/strings.dart';
import 'package:qr_code_scanner/screens/qr_generators_screens/qrShareDialog.dart';

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
        title: Row(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.qrcode,
              color: Colors.deepOrange,
              size: 18.0,
            ),
            Text(
              " ${Strings.lbl_phone}",
              style: TextStyle(fontFamily: 'Righteous', color: Colors.black),
            )
          ],
        ),
      ),
      body: PhoneNumberScreen(),
    );
  }
}

class PhoneNumberScreen extends StatefulWidget {
  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();
  String _dataString = "Hello from this QR";
  String _inputErrorText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: new Form(
        key: _formKey,
        autovalidate: false,
        child: new ListView(
          padding: const EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 16.0),
          shrinkWrap: true,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.phone,
              maxLines: 1,
              maxLength: 15,
              controller: textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "+xx xxxxxxxxxx",
                labelText: Strings.lbl_phone,
                errorText: _inputErrorText,
              ),
              validator: (value) {
                if (value.trim().isEmpty)
                  return 'Phone number is required';
                else
                  return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: MaterialButton(
                color: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _dataString = ("tel:${textEditingController.text?.trim()}");
                    _inputErrorText = null;
                    phoneInputBS(_dataString, context);
                  }
                },
                child:
                    Text('Generate QR', style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void phoneInputBS(_dataString, context) {
    var bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    GlobalKey globalKey = new GlobalKey();
    
    QrShareDialog.showDialog(context, bodyHeight, _dataString, globalKey);
  }
}
