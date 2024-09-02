import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:in_app_web_view/interactive_web_view/event_bus.dart';
import 'package:in_app_web_view/interactive_web_view/interactive_web_view_controller.dart';
import 'package:in_app_web_view/utils/log.dart';
import 'package:js/js.dart' as js;
import 'package:js/js_util.dart' as js_util;

class InteractiveWebView extends StatelessWidget {
  static final log = Log.d();

  final String htmlText;
  final InteractiveWebViewController controller;
  final void Function(String)? onEvent;

  const InteractiveWebView({
    super.key,
    required this.controller,
    required this.htmlText,
    this.onEvent,
  });

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialData: InAppWebViewInitialData(
          data: htmlText,
      ),
    );
  }
}


