import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebPage extends StatefulWidget {
  static final keepAlive = InAppWebViewKeepAlive();

  const WebPage({
    super.key,
  });

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  static const inlineHtml = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('WebPage building');
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              key: GlobalKey(),
              initialData: inlineHtml
                  ? InAppWebViewInitialData(
                      data: """
                  <html lang="en">
                    <head>
                      <title>Embedded HTML File</title>
                      <script>
                        window.addEventListener("flutterInAppWebViewPlatformReady", function(event) {
                          console.log('--------->>>>>>>   AAAAAAA ', window.flutter_inappwebview);
                        });
                        setTimeout(() => {
                          console.log('-----> testing console from inner HTML page.');
                        }, 1000);
                        setTimeout(() => {
                          throw new Error('-----> testing error from inner HTML page.');
                        }, 2000);
                        
                        window.addEventListener('load', function(ev) {
                          document.getElementById('increment').addEventListener('click', (event) => {
                            console.log('Incrementing: ', event);
                            window.parent.postMessage('dsfdsfsdf', '*');
                          });
                          window.addEventListener('message', (event) => {
                              console.log('Message received in iframe:', event);
                              document.getElementById('counter').innerText = event.data;
                          });
                        });
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

              shouldInterceptRequest: (c, r) {
                print('Request: $r');
                return Future.value(null);
              },

              initialUrlRequest: inlineHtml
                  ? null
                  : URLRequest(
                      url: WebUri('https://example.com'),
                    ),

              onProgressChanged: (c, p) {
                print('=======> Progress: $p');
              },

              onLoadResource: (c,r) {
                print('=======> onLoadResource:');
              },
              onDownloadStartRequest: (c, a) {
                print('=======> onDownloadStartRequest:');
              },
              onContentSizeChanged: (c, f, t) {
                print('=======> onContentSizeChanged: $f : $t');
              },
              onCloseWindow: (c) {
                print('=======> onCloseWindow:');
              },
              onLoadStop: (c, u) {
                print('=======> onLoadStop: $u');
              },
              onLoadStart: (controller, u) {
                print('=======> onLoadStart: $u');
              },
              onWebViewCreated: (controller) async {
                print('=======> onWebViewCreated');
              },
              onConsoleMessage: (controller, consoleMessage) {
                print('=======> onConsoleMessage $consoleMessage');
              },
              onReceivedError: (controller, request, error) {
                print("=======> Failed to load: $error");
              },
            ),
          ),
        ],
      ),
    );
  }
}
