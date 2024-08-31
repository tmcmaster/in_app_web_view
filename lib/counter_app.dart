import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_web_view/log.dart';
import 'package:js/js.dart' as js;
import 'package:js/js_util.dart' as js_util;

class CounterApp extends StatefulWidget {
  final Widget child;
  const CounterApp({
    super.key,
    required this.child,
  });

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  static final log = Log.d();

  final _streamController = StreamController<String>.broadcast();
  int _counterScreenCount = 0;

  @override
  void initState() {
    print('Initialising the App');
    final export = js_util.createDartExport(this);
    js_util.setProperty(js_util.globalThis, '_appState', export);
    js_util.callMethod<void>(js_util.globalThis, '_stateSet', []);
    super.initState();
  }

  @override
  void dispose() {
    print('Disposing the App');
    _streamController.close();
    super.dispose();
  }

  @js.JSExport()
  int get count => _counterScreenCount;

  @js.JSExport()
  void addHandler(void Function(String event) handler) {
    print('Handler has been added');
    _streamController.stream.listen((event) {
      handler(_counterScreenCount.toString());
    });
  }

  @js.JSExport()
  void increment() {
    setState(() {
      _counterScreenCount++;
      _streamController.add(_counterScreenCount.toString());
      log.d('COUNTER: $_counterScreenCount');
    });
  }

  @js.JSExport()
  void publishEvent(String message) {
    print('publishing event: $_counterScreenCount');
    _streamController.add(message);
  }

  @override
  Widget build(BuildContext context) {
    print('CounterApp building');
    return MaterialApp(
      title: 'Testing InAppWebView',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Testing InAppWebView'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _counterScreenCount++;
                      });
                      publishEvent('$_counterScreenCount');
                    },
                    child: const Text('Increment'),
                  ),
                  const SizedBox(width: 8),
                  Text('$_counterScreenCount'),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
