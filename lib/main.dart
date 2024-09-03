import 'package:flutter/material.dart';
import 'package:in_app_web_view/app/counter_app.dart';
import 'package:in_app_web_view/utils/log.dart';

void main() async {
  Log.d().d('MAIN Building');
  runApp(MaterialApp(
      title: 'Testing InAppWebView',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const CounterApp()));
}


