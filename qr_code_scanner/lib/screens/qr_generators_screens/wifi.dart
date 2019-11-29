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

class WifiQR extends StatefulWidget {
  @override
  _WifiQRState createState() => _WifiQRState();
}

class _WifiQRState extends State<WifiQR> {
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
              " ${Strings.lbl_wifi}",
              style: TextStyle(fontFamily: 'Righteous', color: Colors.black),
            )
          ],
        ),
      ),
      body: WifiScreen(),
    );
  }
}

class WifiScreen extends StatefulWidget {
  @override
  _WifiScreenState createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  final _formKey = GlobalKey<FormState>();

  final txtSSIDController = TextEditingController();
  final txtPASSWORDContentController = TextEditingController();

  String _dataString = "Hello from this QR";
  String _inputErrorText;
  var bodyHeight;
  GlobalKey globalKey = new GlobalKey();
  String dropdownValue = 'None';

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
                padding: const EdgeInsets.only(left: 9.0),
                child: Text(Strings.lbl_authentication),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1.0,
                              style: BorderStyle.solid,
                              color: Colors.grey),
                          borderRadius:
                              BorderRadius.all(Radius.circular(4.0)))),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0.0,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['None', 'WEP', 'WPA/WPA2']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  maxLength: 30,
                  controller: txtSSIDController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: Strings.lbl_network_name,
                    labelText: Strings.lbl_ssid,
                    errorText: _inputErrorText,
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty)
                      return 'SSID is required';
                    else
                      return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  maxLines: 1,
                  maxLength: 20,
                  controller: txtPASSWORDContentController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: Strings.lbl_password,
                    errorText: _inputErrorText,
                  ),
                  validator: (value) {
                    if (dropdownValue != 'None' && value.trim().isEmpty)
                      return 'Password is required';
                    else
                      return null;
                  },
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
                          ("WIFI:T:$dropdownValue;S:${txtSSIDController.text.trim()};P:${txtPASSWORDContentController.text.trim()};;");
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
    bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: MediaQuery.of(context).size.height,
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
