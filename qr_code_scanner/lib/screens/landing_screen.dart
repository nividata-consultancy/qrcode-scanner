import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_code_scanner/models/QRGenerator.dart';
import 'package:qr_code_scanner/res/strings.dart';

class QRCodeGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Strings.lbl_generate,
          style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white10,
      ),
      body: Container(
        child: FutureBuilder(
          future: DefaultAssetBundle.of(context)
              .loadString('assests/qr_generators.json'),
          builder: (context, snapshot) {
            var qrItems = json.decode(snapshot.data.toString());

            return GridView.builder(
              itemBuilder: (BuildContext context, int index) {
                return gridView(qrItems, index);
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

  Widget gridView(qrItems, int number) {
    return Card(
      margin: EdgeInsets.all(7.0),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Colors.grey.shade200,
            width: 1.5,
          )),
      child: Center(
        child: Container(
          height: 120.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SvgPicture.asset(qrItems[number]['assest_path'],
                  height: 60.0, width: 60.0),
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
      ),
    );
  }
}
