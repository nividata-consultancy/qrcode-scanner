import 'package:flutter/material.dart';
import 'package:qr_code_scanner/util/app_util.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrShareDialog {
  static showDialog(context, bodyHeight, _dataString, GlobalKey globalKey) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 450.0,
              margin: EdgeInsets.all(10),
              color: Colors.transparent,
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
                        child: QrImageView(
                          backgroundColor: Colors.white,
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
                        AppUtil.captureAndSharePng(globalKey);
                      },
                    )
                  ],
                ),
              ));
        });
  }
}
