import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:js/js.dart' as js;
import 'package:js/js_util.dart' as js_util;

void main() async {
  runApp(const SafeArea(child: App()));
}

class App extends StatefulWidget {
  const App({
    super.key,
  });

  @override
  State<App> createState() => _AppState();
}

class Model {
  final String a;
  final String b;

  Model(this.a, this.b);

  @override
  String toString() {
    return '{ a: $a, b: $b }';
  }
}

class _AppState extends State<App> {
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
    _streamController.stream.listen((event) {
      handler(_counterScreenCount.toString());
    });
  }

  @js.JSExport()
  void increment() {
    setState(() {
      _counterScreenCount++;
      _streamController.add(_counterScreenCount.toString());
      print('COUNTER: $_counterScreenCount');
    });
  }

  @js.JSExport()
  void publishEvent(String message) {
    print('publishing event: $_counterScreenCount');
    _streamController.add(message);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing InAppWebView',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
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
              const Expanded(
                child: TestPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestPage extends StatefulWidget {
  static final keepAlive = InAppWebViewKeepAlive();

  const TestPage({
    super.key,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  static const inlineHtml = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing InAppWebView'),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              key: GlobalKey(),

              // keepAlive: keepAlive,
              initialData: inlineHtml ? InAppWebViewInitialData(
                data: """
                  <html>
                    <head>
                      <script>
                        setTimeout(() => {
                        console.log('<== Page loaded   :-)');
                        }, 3000);
                        
                        window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
                          const args = [1, true, ['bar', 5], {foo: 'baz'}];
                          window.flutter_inappwebview.callHandler('myHandlerName', ...args);
                        });
                      </script>
                    </head>
                    <body>
                      <h3>AAA</h3>
                      
                    </body>
                  </html>
                """,
              ) : null,
              initialUrlRequest: inlineHtml ? null : URLRequest(
                url: WebUri('https://example.com'),
              ),
              onProgressChanged: (c, p) {
                print('Progress: $p');
              },
              onLoadStop: (c, u) {
                print('onLoadStop: $u');
              },
              // onWebViewCreated: (controller) async {
              //   print('==> onWebViewCreated');
              //   controller.addJavaScriptHandler(handlerName: 'myHandlerName', callback: (args) {
              //     print(args);
              //     return {
              //       'bar': 'bar_value', 'baz': 'baz_value'
              //     };
              //   });
              // }
            ),
          ),
        ],
      ),
    );
  }
}

class ImageExample extends StatelessWidget {
  final bool cache;

  const ImageExample({super.key, this.cache = false});

  @override
  Widget build(BuildContext context) {
    return cache ? CachedNetworkImage(
      imageUrl: 'https://d2j6dbq0eux0bg.cloudfront.net/images/91265507/3962209852.jpg',
      httpHeaders: const {'Access-Control-Allow-Origin': '*'},
      imageBuilder: (context, image) => Image.new(
        image: image,
        fit: BoxFit.cover,
      ),
      errorWidget: (_, url, error) {
        print('Could not log Image($url): Error($error)');
        return Center(
          child: Icon(
            FontAwesomeIcons.solidImage,
            size: 48,
            color: Colors.grey.shade400,
          ),
        );
      },
      errorListener: (error) {
        print('COULD NOT RENDER IMAGE: $error');
      },
    ) : Image.network(
      'https://d2j6dbq0eux0bg.cloudfront.net/images/91265507/3962209852.jpg',
      errorBuilder: (_, error, __) {
        return Text(error.toString());
      },
    );
  }
}
