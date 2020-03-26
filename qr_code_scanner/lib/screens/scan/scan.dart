import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/res/strings.dart';
import 'package:simple_permissions/simple_permissions.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<ScanScreen> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

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
              " ${Strings.lbl_qr_scanner}",
              style: TextStyle(fontFamily: 'Righteous', color: Colors.black),
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: SelectableText(
              barcode,
              toolbarOptions: ToolbarOptions(selectAll: true, copy: true),
              style: new TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        backgroundColor: Colors.deepOrange,
        onPressed: handleCameraPermission,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      print(e);
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'Camera permission required for scan qr code!';
        });
      } else if (e.code == BarcodeScanner.UserCanceled) {
        this.barcode = 'Camera permission required for scan qr code!';
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      Navigator.pop(context);
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  Future handleCameraPermission() async {
    SimplePermissions.getPermissionStatus(Permission.Camera).then((permission) {
      if (permission == PermissionStatus.authorized) {
        scan();
      } else if (permission == PermissionStatus.denied) {
        SimplePermissions.requestPermission(Permission.Camera)
            .then((permission) {
          if (permission == PermissionStatus.authorized) {
            scan();
          } else if (permission == PermissionStatus.denied) {
            setState(() {
              this.barcode = 'Camera permission required for scan qr code!';
            });
          } else if (permission == PermissionStatus.deniedNeverAsk) {
            setState(() {
              this.barcode = 'Camera permission required for scan qr code!';
              SimplePermissions.openSettings();
            });
          }
        });
      } else if (permission == PermissionStatus.deniedNeverAsk) {
        setState(() {
          this.barcode = 'Camera permission required for scan qr co';
        });
        SimplePermissions.openSettings();
      }
    });
  }
}
