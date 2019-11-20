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
  final txtMailContentController = TextEditingController();

  String _dataString = "Hello from this QR";
  String _inputErrorText;
  var bodyHeight;
  GlobalKey globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 50.0, 40.0, 10.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 1,
                  controller: txtEmailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: Strings.lbl_email,
                    errorText: _inputErrorText,
                  ),
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Email address is required';
                    else
                      return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  controller: txtSubjectController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: Strings.lbl_subject,
                    errorText: _inputErrorText,
                  ),
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Subject is required';
                    else
                      return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: txtMailContentController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: Strings.lbl_body,
                    errorText: _inputErrorText,
                  ),
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Body content is required';
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
                        _dataString =
                            ("mailto:${txtEmailController.text}?subject=${txtSubjectController.text}&body=${txtMailContentController.text}");
                        _inputErrorText = null;
                        phoneInputBS(_dataString, context);
                      }
                    },
                    child: Text('Generate QR',
                        style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
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
                          data: _dataString,
                          size: 0.38 * bodyHeight,
                          onError: (ex) {
                            print("[QR] ERROR - $ex");
                            setState(() {
                              _inputErrorText =
                                  "Error! Maybe your input value is too long?";
                            });
                          },
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
