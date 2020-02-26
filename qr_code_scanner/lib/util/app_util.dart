import 'package:flutter/material.dart';
import 'package:share/share.dart';

class AppUtil {
  static String share =
      "https://play.google.com/store/apps/details?id=com.example.qr_code_scanner";

  static void onShareTap(BuildContext context) {
    Share.share(share);
  }
}
