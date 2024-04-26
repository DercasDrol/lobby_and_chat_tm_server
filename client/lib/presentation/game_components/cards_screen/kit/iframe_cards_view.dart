import 'package:flutter/material.dart';
import 'package:mars_flutter/data/api/game/game_api_client.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class IframeCardsView extends StatelessWidget {
  const IframeCardsView();

  @override
  Widget build(BuildContext context) {
    final String targetServerUrl = GameAPIClient.serverPath;
    WebViewPlatform.instance = WebWebViewPlatform();
    final serverHandler = 'cards';
    final PlatformWebViewController controller = PlatformWebViewController(
      const PlatformWebViewControllerCreationParams(),
    )..loadRequest(
        LoadRequestParams(
          uri: Uri.parse('$targetServerUrl$serverHandler'),
        ),
      );

    return PlatformWebViewWidget(
      PlatformWebViewWidgetCreationParams(controller: controller),
    ).build(context);
  }
}
