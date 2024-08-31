import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:in_app_web_view/counter_app.dart';
import 'package:in_app_web_view/log.dart';
import 'package:in_app_web_view/web_page.dart';

void main() async {
  var log = Log.d();

  log.d('MAIN building');
  FlutterError.onError = (error) {
    log.e('========== ERROR =========== $error');
  };

  runApp(
    const CounterApp(
      child: WebPage(),
    ),
  );
}


