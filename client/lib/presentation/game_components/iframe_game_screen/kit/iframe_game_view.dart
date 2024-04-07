import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/Types.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class IframeGameView extends StatelessWidget {
  final ParticipantId participantId;
  const IframeGameView({super.key, required this.participantId});

  @override
  Widget build(BuildContext context) {
    WebViewPlatform.instance = WebWebViewPlatform();
    final serverHandler =
        participantId.runtimeType == PlayerId ? 'player' : 'spectator';
    final PlatformWebViewController controller = PlatformWebViewController(
      const PlatformWebViewControllerCreationParams(),
    )..loadRequest(
        LoadRequestParams(
          uri: Uri.parse(
              'https://terraforming-mars.herokuapp.com/$serverHandler?id=${participantId.toString()}'),
        ),
      );
    return PlatformWebViewWidget(
      PlatformWebViewWidgetCreationParams(controller: controller),
    ).build(context);
  }
}
