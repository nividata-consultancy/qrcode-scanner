package com.example.qr_code_scanner

import android.os.Bundle
import android.content.Intent
import android.net.Uri
import io.flutter.app.FlutterActivity

import android.support.v4.content.FileProvider
import java.io.File
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

  val SHARE_CHANNEL = "channel:me.alfian.share/share";

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
  }
}
