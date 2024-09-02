import 'dart:math';

import 'package:flutter/material.dart';
import 'package:in_app_web_view/interactive_web_view/interactive_web_view.dart';
import 'package:in_app_web_view/interactive_web_view/interactive_web_view_controller.dart';
import 'package:in_app_web_view/utils/log.dart';

class CounterApp extends StatefulWidget {
  const CounterApp({
    super.key,
  });

  @override
  State<CounterApp> createState() => _CounterAppState();
}

class _CounterAppState extends State<CounterApp> {
  static final log = Log.d();
  late InteractiveWebViewController controller;
  int _counter = 0;

  @override
  void initState() {
    log.d('CounterApp.initState : Initialising the App');
    controller = InteractiveWebViewController(
      name: 'web-page',
      onEvent: onEvent,
    );
    super.initState();
  }

  void onEvent(event) {
    log.d('CounterApp.onEvent : Initialising the App');
    setState(() {
      _counter++;
    });
    controller.sendEvent(_counter.toString());
  }

  @override
  void dispose() {
    log.d('CounterApp.dispose : Disposing the App');
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log.d('CounterApp.build : building material app');
    return MaterialApp(
      title: 'Testing InAppWebView',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Testing InAppWebView'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _counter++;
                      });
                      controller.sendEvent('$_counter');
                    },
                    child: const Text('Increment'),
                  ),
                  const SizedBox(width: 8),
                  Text('$_counter'),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: InteractiveWebView(
                    controller: controller,
                    htmlText: """
                      <html lang="en">
                        <head>
                          <title>Embedded HTML</title>
                          <script>
                            window.addEventListener('load', function() {
                              document.getElementById('increment').addEventListener('click', () => {
                                console.log('Embedded HTML : emitToEventBus : ', event);
                                window.parent.postMessage('increment', '*');
                              });
                              window.addEventListener('message', () => {
                                console.log('Embedded HTML : listenToEventBus:', event.data);
                                document.getElementById('counter').innerText = event.data;
                              });
                            });
                          </script>
                          <style>
                            fieldset {
                              display: flex;
                              flex-direction: row;
                              justify-content: center;
                              gap: 8px;
                            }
                          </style>
                        </head>
                        <body>
                          <h3>This is HTML that is embedded within a Flutter app.</h3>   
                          <fieldset id="interop">
                            <legend>Inner HTML Page</legend>
                            <input id="increment" value="Increment" type="button"/>
                            <span id="counter">0</span>
                          </fieldset>
                        </body>
                      </html>
                    """,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
