import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/res/strings.dart';
import 'package:qr_code_scanner/screens/landing_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primarySwatch: Colors.blue, backgroundColor: Colors.white),
      home: Scaffold(
        extendBody: true,
        body: QRCodeGenerator(),
        floatingActionButton: FloatingActionButton(
          onPressed: scan,
          backgroundColor: Color.fromRGBO(255, 87, 34, 1),
          child: SvgPicture.asset(
            'assests/icons/scan.svg',
            color: Colors.white,
            height: 26,
            width: 26,
          ),
        ),
        bottomNavigationBar: Container(
          // color: Colors.green,
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            clipBehavior: Clip.hardEdge,
            notchMargin: 4.0,
            child: BottomNavigationBar(
                selectedItemColor: Colors.deepOrange,
                type: BottomNavigationBarType.fixed,
                currentIndex: 0,
                elevation: 100.0,
                backgroundColor: Colors.white70,
                selectedLabelStyle: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0),
                unselectedItemColor: Colors.black87,
                unselectedLabelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.history,
                        size: 22.0,
                      ),
                      title: Text(Strings.lbl_history)),
                  BottomNavigationBarItem(
                      icon: Icon(
                        FontAwesomeIcons.qrcode,
                        size: 18.0,
                      ),
                      title: Text(Strings.lbl_generate))
                ]),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
