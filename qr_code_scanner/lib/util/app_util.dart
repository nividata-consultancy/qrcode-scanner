import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class AppUtil {
  static String share =
      "https://play.google.com/store/apps/details?id=com.nividata.qrCodeScanner";

  static void onShareTap(BuildContext context) {
    Share.text('Share App...', share, 'text/plain');
  }

  static Future<void> captureAndSharePng(GlobalKey globalKey) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      await Share.file("Qr code", "image.png", pngBytes, "image/png");
    } catch (e) {
      print(e.toString());
    }
  }
}
