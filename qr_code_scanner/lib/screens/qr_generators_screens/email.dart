import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/res/strings.dart';
import 'package:qr_code_scanner/screens/qr_generators_screens/qrShareDialog.dart';

class EmailQR extends StatefulWidget {
  @override
  _EmailQRState createState() => _EmailQRState();
}

class _EmailQRState extends State<EmailQR> {
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
              " ${Strings.lbl_email}",
              style: TextStyle(fontFamily: 'Righteous', color: Colors.black),
            )
          ],
        ),
      ),
      body: EmailScreen(),
    );
  }
}

class EmailScreen extends StatefulWidget {
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final txtEmailController = TextEditingController();
  final txtSubjectController = TextEditingController();
  final txtBodyController = TextEditingController();

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
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 3 ,
                  maxLength: 254,
                  controller: txtEmailController,
                  decoration: InputDecoration(
                    hintText: Strings.lbl_email_hint,
                    border: OutlineInputBorder(),
                    labelText: Strings.lbl_email,
                    errorText: _inputErrorText,
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
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  maxLength: 160,
                  controller: txtSubjectController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: Strings.lbl_subject,
                    errorText: _inputErrorText,
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty)
                      return 'Mail subject is required';
                    else
                      return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 100.0,
                  child: TextFormField(
                    expands: true,
                    textDirection: TextDirection.ltr,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    maxLength: 500,
                    controller: txtBodyController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Strings.lbl_body,
                      errorText: _inputErrorText,
                    ),
                    validator: (value) {
                      if (value.trim().isEmpty)
                        return 'Mail body is required';
                      else
                        return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  color: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _dataString =
                          ("mailto:${txtEmailController.text.trim()}?subject=${txtSubjectController.text.trim()}&body=${txtBodyController.text.trim()}");
                      _inputErrorText = null;
                      phoneInputBS(_dataString, context);
                    }
                  },
                  child: Text('Generate QR',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          )),
    );
  }

  void phoneInputBS(_dataString, context) {
    var bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    GlobalKey globalKey = new GlobalKey();

    QrShareDialog.showDialog(context, bodyHeight, _dataString, globalKey);
  }
}
