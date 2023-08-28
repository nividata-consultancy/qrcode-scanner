import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/models/QrCodeTextParser.dart';
import 'package:qr_code_scanner/res/strings.dart';

class ScanScreen extends StatelessWidget {
  final String barcode;

  ScanScreen({
    Key? key,
    required this.barcode,
  }) : super(key: key);

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
        child: Center(
          child: getWidget(barcode),
        ),
      ),
    );
  }
}

Widget getWidget(String barcode) {
  List<QrDisplayData> list = QrCodeTextParser.getDisplayData(barcode);
  print(list.toString());
  return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, position) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                list[position].name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                list[position].value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700]),
              )
            ],
          ),
        );
      });
}
