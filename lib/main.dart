import 'package:flutter/material.dart';
import 'package:in_app_web_view/app/counter_app.dart';
import 'package:in_app_web_view/utils/log.dart';

void main() async {
  Log.d().d('MAIN Building');
  runApp(const CounterApp());
}


