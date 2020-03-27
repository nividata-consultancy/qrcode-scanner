import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/res/strings.dart';
import 'package:qr_code_scanner/screens/qr_generators_screens/qrShareDialog.dart';

class ContactQR extends StatefulWidget {
  @override
  _ContactQRState createState() => _ContactQRState();
}

class _ContactQRState extends State<ContactQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: <Widget>[
            Icon(
              FontAwesomeIcons.qrcode,
              color: Colors.deepOrange,
              size: 18.0,
            ),
            Text(
              " ${Strings.lbl_contact}",
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
  final txtNameController = TextEditingController();
  final txtPhoneNumberController = TextEditingController();
  final txtEmailController = TextEditingController();
  final txtCompanyNameController = TextEditingController();
  final txtAddressController = TextEditingController();
  final txtWebSiteController = TextEditingController();

  String _dataString = "Hello from this QR";
  String _inputErrorText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: new Form(
        key: _formKey,
        autovalidate: false,
        child: new ListView(
          padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                maxLines: 1,
                maxLength: 50,
                controller: txtNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Name",
                  errorText: _inputErrorText,
                ),
                validator: (value) {
                  if (value.trim().isEmpty)
                    return 'Name is required';
                  else
                    return null;
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 100.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  maxLength: 150,
                  controller: txtAddressController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Address",
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty)
                      return 'Address is required';
                    else
                      return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                maxLines: 1,
                maxLength: 15,
                controller: txtPhoneNumberController,
                decoration: InputDecoration(
                  hintText: Strings.lbl_phone,
                  border: OutlineInputBorder(),
                  labelText: "Phone Number",
                  errorText: _inputErrorText,
                ),
                validator: (value) {
                  if (value.trim().isEmpty)
                    return 'Phone number is required';
                  else
                    return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                maxLines: 1,
                maxLength: 50,
                controller: txtCompanyNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Organization",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                maxLines: 1,
                maxLength: 25,
                controller: txtEmailController,
                decoration: InputDecoration(
                  hintText: Strings.lbl_email_hint,
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
                validator: (value) {
                  if (value.trim().isEmpty)
                    return 'Email is required';
                  else {
                    if (RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value))
                      return null;
                    else
                      return 'Invalid email id';
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.url,
                maxLines: 1,
                maxLength: 150,
                controller: txtWebSiteController,
                decoration: InputDecoration(
                  hintText: Strings.lbl_web_url_hint,
                  border: OutlineInputBorder(),
                  labelText: "Website",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: MaterialButton(
                color: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _dataString =
                          ("MECARD:N:${txtNameController.text.trim()};TEL:${txtPhoneNumberController.text.trim()};ADR:${txtAddressController.text.trim()};EMAIL:${txtEmailController.text.trim()};URL:${txtWebSiteController.text.trim()};");
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
