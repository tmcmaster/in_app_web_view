// import 'dart:io' show Platform;
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart'; // Import for InAppWebView
// import 'package:webview_flutter/webview_flutter.dart'; // Import for WebView
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter WebView Test',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyWebView(),
//     );
//   }
// }
//
// class MyWebView extends StatefulWidget {
//   @override
//   _MyWebViewState createState() => _MyWebViewState();
// }
//
// class _MyWebViewState extends State<MyWebView> {
//   late WebViewController _webViewController;
//   late InAppWebViewController _inAppWebViewController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (Platform.isAndroid) {
//       // Enable virtual display for Android
//       WebView.platform = SurfaceAndroidWebView();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Flutter WebView Test"),
//       ),
//       body: _buildWebView(),
//     );
//   }
//
//   Widget _buildWebView() {
//     if (Platform.isAndroid || Platform.isIOS) {
//       // Use InAppWebView on mobile platforms
//       return InAppWebView(
//         initialUrlRequest: URLRequest(url: Uri.parse("https://your-web-page-url.com")),
//         onWebViewCreated: (controller) {
//           _inAppWebViewController = controller;
//
//           _inAppWebViewController.addJavaScriptHandler(
//             handlerName: 'myHandler',
//             callback: (args) {
//               // Handle JavaScript message from the web page
//               print("Received event: ${args[0]}");
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Received from JS: ${args[0]}")),
//               );
//             },
//           );
//         },
//       );
//     } else {
//       // Use WebView for web platform
//       return WebView(
//         initialUrl: 'https://your-web-page-url.com',
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (WebViewController webViewController) {
//           _webViewController = webViewController;
//         },
//         javascriptChannels: <JavascriptChannel>{
//           _toasterJavascriptChannel(context),
//         },
//       );
//     }
//   }
//
//   JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
//     return JavascriptChannel(
//       name: 'Toaster',
//       onMessageReceived: (JavascriptMessage message) {
//         // Handle the message from JavaScript
//         print("Message from JS: ${message.message}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(message.message)),
//         );
//       },
//     );
//   }
// }
