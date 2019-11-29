import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_scanner/res/strings.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  final txtNickNameController = TextEditingController();

  String _dataString = "Hello from this QR";
  String _inputErrorText;
  var bodyHeight;

  GlobalKey globalKey = new GlobalKey();

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.text,
                maxLines: 1,
                controller: txtNickNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nick Name",
                  errorText: _inputErrorText,
                ),
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
                        ("MECARD:N:${txtNameController.text.trim()};TEL:${txtPhoneNumberController.text.trim()};ADR:${txtAddressController.text.trim()};EMAIL:${txtEmailController.text.trim()};URL:${txtWebSiteController.text.trim()};NICKNAME:${txtNickNameController.text.trim()};");
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

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }

  void phoneInputBS(_dataString, context) {
    GlobalKey globalKey = new GlobalKey();

    bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 450.0,
              margin: EdgeInsets.all(10),
              color:
                  Colors.transparent, //could change this to Color(0xFF737373),
              //so you don't have to change MaterialApp canvasColor
              child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.all(Radius.circular(10.0))),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RepaintBoundary(
                        key: globalKey,
                        child: QrImage(
                          version: QrVersions.auto,
                          gapless: false,
                          data: _dataString,
                          size: 0.38 * bodyHeight,
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      child: Text(
                        "Share",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        _captureAndSharePng();
                      },
                    )
                  ],
                ),
              ));
        });
  }
}
