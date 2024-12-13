import 'dart:math';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mars_flutter/domain/chat_cubit.dart';
import 'package:mars_flutter/domain/lobby_cubit.dart';
import 'package:mars_flutter/domain/model/constants.dart';
import 'package:mars_flutter/domain/repositories.dart';
import 'package:mars_flutter/presentation/core/common_future_widget.dart';
import 'dart:js' as js;
import 'package:mars_flutter/presentation/game_components/common/expanded_chat_panel/expanded_chat_panel.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class IframeGameScreen extends StatelessWidget {
  final LobbyCubit lobbyCubit;
  final ChatCubit gameChatCubit;
  final ChatCubit generalChatCubit;
  const IframeGameScreen({
    super.key,
    required this.lobbyCubit,
    required this.gameChatCubit,
    required this.generalChatCubit,
  });

  @override
  Widget build(BuildContext context) {
    final participantId = lobbyCubit.participantId;

    if (participantId == null) {
      lobbyCubit.closeGameSession();
      context.go(LOBBY_ROUTE);
      return const SizedBox.shrink();
    }
    final chatPanelExpandedVN = ValueNotifier(false);
    return Scaffold(
      body: ExpandedChatPanel(
        lobbyCubit: lobbyCubit,
        gameChatCubit: gameChatCubit,
        generalChatCubit: generalChatCubit,
        expandedController: chatPanelExpandedVN,
        child: CommonFutureWidget<String>(
          future: Repositories.game.host,
          getContentView: (gameServer) {
            final protocol = gameServer.startsWith("localhost") || kDebugMode
                ? "http://"
                : "https://";
            final serverHandler =
                participantId.isPlayer ? 'player' : 'spectator';
            final targetServerUrl = protocol + gameServer;
            final url =
                '$targetServerUrl/$serverHandler?id=${participantId.toString()}';
            return IframeGameView(url: url);
          },
        ),
      ),
    );
  }
}

class IframeGameView extends StatefulWidget {
  final String url;
  const IframeGameView({super.key, required this.url});

  @override
  State<IframeGameView> createState() => _IframeGameViewState();
}

class _IframeGameViewState extends State<IframeGameView> {
  double scale = 1.0;
  double lastUpdatedScaleWidth = 0.0;
  bool scaleChangedByUser = false;
  static const _viewId = 'my-view-id';
  @override
  void initState() {
    final html.IFrameElement _iFrame;
    _iFrame = html.IFrameElement()..src = widget.url;

    _iFrame.style
      ..marginBottom = '-10px'
      ..border = 'none'
      ..height = '100%'
      ..width = '100%'
      ..minWidth = '1260px'
      ..zoom = scale.toString();
    final div = html.DivElement();
    div.children.add(_iFrame);
    div.style
      ..height = '100%'
      ..width = '100%'
      ..overflow = 'auto'
      ..border = 'none';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) => div,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final minimumWidthToChangeScale = 100;
    final minGameWidth = 320.0;
    return Stack(alignment: Alignment.topRight, children: [
      LayoutBuilder(builder: (context, constraints) {
        if ((lastUpdatedScaleWidth - constraints.maxWidth >
                    minimumWidthToChangeScale ||
                constraints.maxWidth - lastUpdatedScaleWidth >
                    minimumWidthToChangeScale) &&
            constraints.maxWidth > minGameWidth &&
            !scaleChangedByUser) {
          scale = min(1.0, max(0.3, constraints.maxWidth / 1260));
          lastUpdatedScaleWidth = constraints.maxWidth;
          js.context.callMethod('zoomIframe', [scale]);
        }
        return HtmlElementView(viewType: _viewId);
      }),
      Column(
        children: [
          PointerInterceptor(
              child: IconButton(
            iconSize: 40,
            color: Colors.white,
            icon: const Icon(Icons.zoom_in),
            onPressed: () {
              scale = min(1.0, scale + 0.1);
              js.context.callMethod('zoomIframe', [scale]);
              scaleChangedByUser = true;
            },
          )),
          PointerInterceptor(
              child: IconButton(
            iconSize: 40,
            icon: const Icon(Icons.zoom_out),
            color: Colors.white,
            onPressed: () {
              scale = max(0.3, scale - 0.1);
              js.context.callMethod('zoomIframe', [scale]);
              scaleChangedByUser = true;
            },
          )),
        ],
      ),
    ]);
  }
}
