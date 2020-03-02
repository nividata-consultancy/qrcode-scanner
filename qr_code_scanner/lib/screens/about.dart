import 'package:flutter/material.dart';
import 'package:qr_code_scanner/constants.dart';

class AboutUS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text(
          'How it\'s work',
          textScaleFactor: 1.2,
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 20.0),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(0.5),
            1: FlexColumnWidth(0.4),
            2: FlexColumnWidth(8.0),
          },
          children: [
            TableRow(children: [
              TableCell(
                child: getNumberText("1)"),
              ),
              TableCell(
                child: Text(""),
              ),
              TableCell(
                child: getTitleText("Scan QR code"),
              )
            ]),
            TableRow(children: [
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getArrowText(),
              ),
              TableCell(
                child: getDescText(sqr1),
              )
            ]),
            TableRow(children: [
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getArrowText(),
              ),
              TableCell(
                child: getDescText(sqr2),
              )
            ]),
            TableRow(children: [
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getArrowText(),
              ),
              TableCell(
                child: getDescText(sqr3),
              )
            ]),
            TableRow(children: [
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getArrowText(),
              ),
              TableCell(
                child: getDescText(sqr4),
              )
            ]),
            TableRow(children: [
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getSpaceText(),
              )
            ]),
            TableRow(children: [
              TableCell(
                child: getNumberText("2)"),
              ),
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getTitleText("Generate QR code"),
              )
            ]),
            TableRow(children: [
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getArrowText(),
              ),
              TableCell(
                child: getDescText(gqr1),
              )
            ]),
            TableRow(children: [
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getDescText(gqr11),
              )
            ]),
            TableRow(children: [
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getDescText(gqr12),
              )
            ]),
            TableRow(children: [
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getDescText(gqr13),
              )
            ]),
            TableRow(children: [
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getDescText(gqr14),
              )
            ]),
            TableRow(children: [
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getDescText(gqr15),
              )
            ]),
            TableRow(children: [
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getDescText(gqr16),
              )
            ]),
            TableRow(children: [
              TableCell(
                child: getSpaceText(),
              ),
              TableCell(
                child: getArrowText(),
              ),
              TableCell(
                child: getDescText(gqr2),
              )
            ])
          ],
        ),
      ),
    );
  }

  getNumberText(text) {
    return Text(text,
        style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18.0));
  }

  getTitleText(text) {
    return Text(text,
        style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18.0));
  }

  getSpaceText() {
    return Text("");
  }

  getArrowText() {
    return Text("->");
  }

  getDescText(text) {
    return Text(text, style: TextStyle(color: Colors.black54, fontSize: 15.0));
  }
}
