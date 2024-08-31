import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:in_app_web_view/log.dart';

class WebPage extends StatefulWidget {
  static final keepAlive = InAppWebViewKeepAlive();

  const WebPage({
    super.key,
  });

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  static final log = Log.d();

  static const inlineHtml = true;

  @override
  void initState() {
    super.initState();
  }

  // late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    log.d('WebPage building');
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              key: GlobalKey(),

              // keepAlive: keepAlive,
              initialData: inlineHtml
                  ? InAppWebViewInitialData(
                data: """
                  <html lang="en">
                    <head>
                      <title>Embedded HTML File</title>
                      <script>
                        // window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
                        //   console.log('AAAAAAA ', window.flutter_inappwebview);
                        //   console.log('flutterInAppWebViewPlatformReady');
                        //   window.flutter_inappwebview.callHandler('handlerFoo')
                        //     .then(function(result) {
                        //       // print to the console the data coming
                        //       // from the Flutter side.
                        //       console.log('AAAA', JSON.stringify(result));
                        //       window.flutter_inappwebview.callHandler(
                        //         'handlerFooWithArgs', 1, true, ['bar', 5], {foo: 'baz'}, result
                        //       );
                        //   });
                        // });
                      </script>
                    </head>
                    <body>
                      <h3>This is an HTML that is embedded within a Flutter app.</h3>   
                      <fieldset id="interop">
                        <legend>Inner HTML Page</legend>
                        <input id="increment" value="Increment" type="button"/>
                        <span id="counter"></span>
                      </fieldset>
                    </body>
                  </html>
                """,
              )
                  : null,
              initialUrlRequest: inlineHtml
                  ? null
                  : URLRequest(
                url: WebUri('https://example.com'),
              ),
              onProgressChanged: (c, p) {
                log.d('=======> Progress: $p');
              },
              onLoadStop: (c, u) {
                log.d('=======> onLoadStop: $u');
              },
              onLoadStart: (controller, u) {
                log.d('=======> onLoadStart: $u');
              },
              onWebViewCreated: (controller) async {
                // _webViewController = controller;
                // Future.delayed(const Duration(seconds: 1), () async {
                //   final title = await _webViewController.getTitle();
                //   log.d('TITLE: $title');
                // });

                log.d('onWebViewCreated');
                // var a = await controller.evaluateJavascript(source: """
                //   const args = [1, true, ['bar', 5], {foo: 'baz'}];
                //   window.flutter_inappwebview.callHandler('myHandlerName', ...args);
                // """);
                // log.d('RESPONSE: $a');
                // controller.addJavaScriptHandler(handlerName: 'handlerFoo', callback: (args) {
                //   log.d('handlerFoo: $args');
                //   return {
                //     'bar': 'bar_value', 'baz': 'baz_value'
                //   };
                // });
                //
                // controller.addJavaScriptHandler(handlerName: 'handlerFooWithArgs', callback: (args) {
                //   log.d('handlerFooWithArgs: $args');
                // });
              },
              onConsoleMessage: (controller, consoleMessage) {
                log.d('onConsoleMessage $consoleMessage');
              },
            ),
          ),
        ],
      ),
    );
  }
}
