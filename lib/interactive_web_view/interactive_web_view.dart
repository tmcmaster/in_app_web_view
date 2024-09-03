import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:in_app_web_view/interactive_web_view/event_bus_flutter.dart';
import 'package:in_app_web_view/interactive_web_view/interactive_web_view_controller.dart';
import 'package:in_app_web_view/utils/log.dart';
import 'package:js/js.dart' as js;
import 'package:js/js_util.dart' as js_util;

class InteractiveWebView extends StatelessWidget {
  static final log = Log.d();

  final String? htmlText;
  final String? htmlUrl;
  final InteractiveWebViewController controller;
  final void Function(String)? onEvent;

  const InteractiveWebView({
    super.key,
    required this.controller,
    this.htmlText,
    this.htmlUrl,
    this.onEvent,
  }) : assert(htmlText != null || htmlUrl != null);

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialData: htmlText == null
          ? null
          : InAppWebViewInitialData(
              data: htmlText!,
            ),

        initialUrlRequest: htmlUrl == null ? null : URLRequest(
          url: WebUri(htmlUrl!),
        ),
    );
  }
}
