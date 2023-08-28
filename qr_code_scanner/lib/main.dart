import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/screens/landing_screen.dart';
import 'package:qr_code_scanner/screens/scan/scan.dart';
import 'package:qr_code_scanner/screens/setting.dart';

import 'animations/animate_button.dart';
import 'animations/size_transition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Code     ',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        backgroundColor: Colors.white,
      ),
      home: MyQRApp(),
    );
  }
}

class MyQRApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyQRAppState createState() => _MyQRAppState();
}

class _MyQRAppState extends State<MyQRApp> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 100.0,
                floating: true,
                pinned: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  IconButton(
                    icon: new Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                    onPressed: () =>
                        {Navigator.push(context, SizeRoute(page: Setting()))},
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  centerTitle: true,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.qrcode,
                        color: Colors.deepOrange,
                      ),
                      Text(" QR code",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontFamily: 'Righteous',
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  background: Container(
                    color: Colors.white,
                  ),
                ),
              ),
            ];
          },
          body: QRCodeGenerator(),
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            AnimatedLoader(
                animation: _controller,
                // alignment: FractionalOffset.center,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: 70.0,
                  height: 70.0,
                  child: new RawMaterialButton(
                    shape: new CircleBorder(),
                    fillColor: Color.fromRGBO(255, 87, 34, 0.8),
                    onPressed: () {},
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: FloatingActionButton(
                onPressed: () => handleCameraPermission(),
                elevation: 0.0,
                backgroundColor: Color.fromRGBO(255, 87, 34, 1),
                child: SvgPicture.asset(
                  'assests/icons/scan.svg',
                  color: Colors.white,
                  height: 26,
                  width: 26,
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  Future scan() async {
    try {
      ScanResult barcode = await BarcodeScanner.scan();
      if (barcode.type == ResultType.Barcode) {
        Navigator.push(
          context,
          SizeRoute(
            page: ScanScreen(
              barcode: barcode.rawContent,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future handleCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;

    if (status.isGranted) {
      scan();
    } else if (status.isDenied || status.isRestricted) {
      PermissionStatus newStatus = await Permission.camera.request();
      if (newStatus.isGranted) {
        scan();
      } else if (newStatus.isPermanentlyDenied) {
        // Open the App settings
        openAppSettings();
      }
    } else if (status.isPermanentlyDenied) {
      // If the permission has been denied forever, then direct the user to settings
      openAppSettings();
    }
  }
}

/*
bottomNavigationBar: Container(
// color: Colors.green,
child: BottomAppBar(
shape: CircularNotchedRectangle(),
clipBehavior: Clip.hardEdge,
notchMargin: 4.0,
child: BottomNavigationBar(
selectedItemColor: Colors.deepOrange,
type: BottomNavigationBarType.fixed,
currentIndex: _selectedIndex,
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
],
onTap: _onItemTapped,
),
),
),*/
