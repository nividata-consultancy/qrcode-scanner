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

      // final channel = const MethodChannel('channel:me.alfian.share/share');
      // channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }

  void phoneInputBS(_dataString, context) {
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
