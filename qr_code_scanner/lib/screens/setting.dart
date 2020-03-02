import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:launch_review/launch_review.dart';
import 'package:qr_code_scanner/animations/size_transition.dart';
import 'package:qr_code_scanner/screens/about.dart';
import 'package:qr_code_scanner/screens/qr_generators_screens/contact.dart';
import 'package:qr_code_scanner/util/app_util.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingState();
  }
}

class _SettingState extends State<Setting> {
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
          body: SettingScreen(),
        ),
      ),
    );
  }
}

class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingScreenState();
  }
}

class _SettingScreenState extends State<SettingScreen> {
  final List<String> _children = [
    "About App",
    "Share App",
    "Rate App",
    "Send Feedback"
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        itemCount: _children.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              height: 50,
              child: GestureDetector(
                  child: Center(
                    child: Text(
                      _children[index],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: Colors.black87),
                    ),
                  ),
                  onTap: () {
                    print(index);
                    switch (index) {
                      case 0:
                        Navigator.push(context, SizeRoute(page: AboutUS()));
                        break;
                      case 1:
                        AppUtil.onShareTap(context);
                        break;
                      case 2:
                        LaunchReview.launch(
                            androidAppId: "com.example.qr_code_scanner",
                            iOSAppId: "com.example.qr_code_scanner");
                        break;
                      case 3:
                        launchURL(Uri.encodeFull(mailTo));
                        break;
                    }
                  }));
        });
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
          msg: "No any email app is available.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }
}
