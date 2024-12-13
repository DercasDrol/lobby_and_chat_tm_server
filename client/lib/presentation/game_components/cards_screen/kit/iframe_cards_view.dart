import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class IframeCardsView extends StatelessWidget {
  final String host;
  const IframeCardsView({required this.host});

  @override
  Widget build(BuildContext context) {
    WebViewPlatform.instance = WebWebViewPlatform();
    final serverHandler = 'cards';
    final protocol =
        host.startsWith("localhost:") || kDebugMode ? "http" : "https";
    final PlatformWebViewController controller = PlatformWebViewController(
      const PlatformWebViewControllerCreationParams(),
    )..loadRequest(
        LoadRequestParams(
          uri: Uri.parse('$protocol://$host/$serverHandler'),
        ),
      );

    return PlatformWebViewWidget(
      PlatformWebViewWidgetCreationParams(controller: controller),
    ).build(context);
  }
}
