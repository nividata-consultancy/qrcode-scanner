import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/animations/size_transition.dart';
import 'package:qr_code_scanner/screens/qr_generators_screens/contact.dart';
import 'package:qr_code_scanner/screens/qr_generators_screens/email.dart';
import 'package:qr_code_scanner/screens/qr_generators_screens/messages.dart';
import 'package:qr_code_scanner/screens/qr_generators_screens/phone_number.dart';
import 'package:qr_code_scanner/screens/qr_generators_screens/web_url.dart';
import 'package:qr_code_scanner/screens/qr_generators_screens/wifi.dart';

class QRCodeGenerator extends StatefulWidget {
  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  String _inputErrorText;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onPressed: null,
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
        body: FutureBuilder(
          future: DefaultAssetBundle.of(context)
              .loadString('assests/qr_generators.json'),
          builder: (context, snapshot) {
            var qrItems = json.decode(snapshot.data.toString());
            return GridView.builder(
              padding: EdgeInsets.only(bottom: 80.0),
              itemBuilder: (BuildContext context, int index) {
                return gridView(context, qrItems, index);
              },
              itemCount: qrItems == null ? 0 : qrItems.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            );
          },
        ),
      ),
    );
  }

  Widget gridView(context, qrItems, int number) {
    return Card(
      color: Color.fromRGBO(105, 240, 174, 1),
      margin: EdgeInsets.all(7.0),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Colors.grey.shade200,
            width: 1.5,
          )),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SvgPicture.asset(
                qrItems[number]['assest_path'],
                height: 60.0,
                width: 60.0,
                color: Colors.black87,
              ),
              Text(
                qrItems[number]['label'],
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87),
              )
            ],
          ),
        ),
        onTap: () => {
          if (number == 0)
            Navigator.push(context, SizeRoute(page: PhoneNumberQR()))
          else if (number == 1)
            Navigator.push(context, SizeRoute(page: ContactQR()))
          else if (number == 2)
            Navigator.push(context, SizeRoute(page: WebUrlQR()))
          else if (number == 3)
            Navigator.push(context, SizeRoute(page: MessageQR()))
          else if (number == 4)
            Navigator.push(context, SizeRoute(page: WifiQR()))
          else if (number == 5)
            Navigator.push(context, SizeRoute(page: EmailQR()))
          else
            Navigator.push(context, SizeRoute(page: EmailQR()))
        },
      ),
    );
  }
}
