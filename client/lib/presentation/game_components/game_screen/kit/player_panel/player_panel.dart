import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/domain/model/game_models/ActionLabel.dart';
import 'package:mars_flutter/domain/model/game_models/CardModel.dart';
import 'package:mars_flutter/domain/model/game_models/PlayerModel.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_player_panel_info.dart';
import 'package:mars_flutter/presentation/game_components/common/card_tooltip.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/player_panel/kit/panel_button.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/player_panel/kit/player_resource_box.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/player_panel/kit/action_cards_button.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/player_panel/kit/main_cards_button.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/player_panel/kit/tag_row.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/player_panel/kit/terraforming_rate.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/player_panel/kit/timer.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/player_panel/kit/victory_points.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/show_popup_with_tabs.dart';

class PlayerPanelView extends StatelessWidget {
  final PresentationPlayerPanelInfo playerPanelInfo;
  const PlayerPanelView({required this.playerPanelInfo});

  static const _productionBoxWidth = 45.0;
  static const _nameBoxWidth = 120.0;
  static const height = 48.0;
  _prepareResourceBoxList() {
    final PublicPlayerModel playerState = playerPanelInfo.playerState;
    addPadding(child) => Padding(
          padding: EdgeInsets.all(2.0),
          child: child,
        );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        addPadding(PlayerResourceView(
          width: _productionBoxWidth,
          height: height,
          productionCount: playerState.megaCreditProduction,
          resourceCount: playerState.megaCredits,
          icon: Image.asset(
            Assets.resources.megacredit.path,
          ),
          useRightArrow: false,
          showCountInsideIcon: true,
        )),
        addPadding(PlayerResourceView(
          width: _productionBoxWidth,
          height: height,
          productionCount: playerState.steelProduction,
          resourceCount: playerState.steel,
          icon: Image.asset(
            Assets.resources.steel.path,
          ),
          useRightArrow: false,
          cost: playerState.steelValue,
        )),
        addPadding(PlayerResourceView(
          width: _productionBoxWidth,
          height: height,
          productionCount: playerState.titaniumProduction,
          resourceCount: playerState.titanium,
          icon: Image.asset(
            Assets.resources.titanium.path,
          ),
          useRightArrow: false,
          cost: playerState.titaniumValue,
        )),
        addPadding(PlayerResourceView(
          width: _productionBoxWidth,
          height: height,
          productionCount: playerState.plantProduction,
          resourceCount: playerState.plants,
          icon: Image.asset(
            Assets.resources.plant.path,
          ),
          useRightArrow: false,
        )),
        Padding(
            padding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 2.0),
            child: PlayerResourceView(
              width: _productionBoxWidth,
              height: height,
              productionCount: playerState.energyProduction,
              resourceCount: playerState.energy,
              icon: Image.asset(
                Assets.resources.power.path,
              ),
              useRightArrow: false,
            )),
        Padding(
          padding: EdgeInsets.only(top: height / 2.8),
          child: ClipPath(
            clipper: _TriangleClipper(),
            child: Container(
              width: 6.0,
              height: height / 3,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color.fromARGB(117, 0, 0, 0),
              ),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: PlayerResourceView(
              width: _productionBoxWidth,
              height: height,
              productionCount: playerState.heatProduction,
              resourceCount: playerState.heat,
              icon: Image.asset(
                Assets.resources.heat.path,
              ),
              useRightArrow: false,
            ))
      ],
    );
  }

  _prepareNameBlock() {
    List<CardModel> corps = playerPanelInfo.playerState.corps;
    return Container(
      width: _nameBoxWidth,
      height: height,
      padding: EdgeInsets.only(bottom: 2.0),
      child: Column(
        children: [
          Expanded(
            flex: 12 ~/ (corps.length > 0 ? corps.length : 1),
            child: Padding(
              padding: EdgeInsets.only(
                  left: playerPanelInfo.showFirstMark ? height * 0.5 : 0.0),
              child: FittedBox(
                child: Text(
                  playerPanelInfo.playerState.name,
                  style: MAIN_TEXT_STYLE,
                ),
              ),
            ),
          ),
          corps.length == 0
              ? SizedBox.shrink()
              : Expanded(
                  flex: 10,
                  child: Column(
                    children: corps
                        .map((corp) => CardTooltip(
                              cardName: corp.name,
                              cardResourceCount: corp.resources,
                              sizeMultiplier: corps.length > 1 ? 1.5 : 1.1,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.0),
                                child: FittedBox(
                                  child: Text(
                                    corp.name.toString(),
                                    style: MAIN_TEXT_STYLE,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }

  final _timerBlockWidth = 80.0;
  _prepareTimerBlock() {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: SizedBox(
        width: _timerBlockWidth,
        height: height,
        child: TimerView(
          key: UniqueKey(),
          currentPhase: playerPanelInfo.actionLabel == null ||
                  playerPanelInfo.actionLabel == ActionLabel.NONE
              ? " "
              : playerPanelInfo.actionLabel.toString(),
          duration: Duration(
            milliseconds: playerPanelInfo.playerState.timer.sumElapsed +
                DateTime.now().millisecondsSinceEpoch -
                playerPanelInfo.playerState.timer.startedAt,
          ),
          isTimerTurnedOn: playerPanelInfo.playerState.timer.running,
        ),
      ),
    );
  }

  final _cardsButtonWidth = 80.0;
  _prepareCardsButton() {
    final cardsForPlay =
        playerPanelInfo.projectCardsTabsInfo.leftTabInfo?.cards;
    return MainCardsButton(
      allCardsDiscount: playerPanelInfo.allCardsDiscount,
      cardsInHandsCount: playerPanelInfo.playerState.cardsInHandNbr,
      cardsAvailableForPlayCount: cardsForPlay == null
          ? null
          : {
              CardType.ACTIVE: cardsForPlay
                  .where((card) =>
                      ClientCard.fromCardName(card.name).type ==
                      CardType.ACTIVE)
                  .length,
              CardType.AUTOMATED: cardsForPlay
                  .where((card) =>
                      ClientCard.fromCardName(card.name).type ==
                      CardType.AUTOMATED)
                  .length,
              CardType.EVENT: cardsForPlay
                  .where((card) =>
                      ClientCard.fromCardName(card.name).type == CardType.EVENT)
                  .length,
            },
      width: _cardsButtonWidth,
      tabsInfo: playerPanelInfo.projectCardsTabsInfo,
      tagsInfo: playerPanelInfo.tagsInfo,
    );
  }

  final _cardsActionCardsButton = 25.0;
  _prepareActionCardsButton() {
    return ActionCardsButton(
      availableActionsCount: playerPanelInfo.availableActionsCount,
      tabsInfo: playerPanelInfo.actionsOnCardsTabsInfo,
      height: height,
      width: _cardsActionCardsButton,
    );
  }

  _prepareVP() => VictoryPointsView(
        height: height,
        width: _productionBoxWidth,
        victoryPoints: playerPanelInfo.playerState.victoryPointsBreakdown,
      );

  _prepareRT() => TerraformingRateView(
        height: height,
        width: _productionBoxWidth,
        terraformingRate: playerPanelInfo.playerState.terraformRating,
      );

  _prepareTagRow(width) => Flexible(
        flex: 6,
        child: Padding(
          padding: EdgeInsets.only(right: 4.0),
          child: TagRowView(
            width: width,
            height: height,
            tagsInfo: playerPanelInfo.tagsInfo,
          ),
        ),
      );
  _preparePassButton() =>
      playerPanelInfo.passButtonInfo?.onConfirmButtonFn == null
          ? SizedBox.shrink()
          : PanelButton(
              panelButtonBorder: playerPanelInfo.skipButtonInfo == null
                  ? PanelButtonBorder.FULL
                  : PanelButtonBorder.LEFT,
              onClick: playerPanelInfo.passButtonInfo!.onConfirmButtonFn!,
              buttonText: playerPanelInfo.passButtonInfo?.buttonText ?? ' ',
              tooltipText: playerPanelInfo.passButtonInfo?.buttonText ?? ' ',
            );
  _prepareSkipButton() =>
      playerPanelInfo.skipButtonInfo?.onConfirmButtonFn == null
          ? SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.only(left: 1.0),
              child: PanelButton(
                panelButtonBorder: PanelButtonBorder.RIGHT,
                onClick: playerPanelInfo.skipButtonInfo!.onConfirmButtonFn!,
                buttonText: playerPanelInfo.skipButtonInfo?.buttonText ?? ' ',
                tooltipText: playerPanelInfo.skipButtonInfo?.buttonText ?? ' ',
              ),
            );

  _prepareTemperatureButton(color) =>
      playerPanelInfo.heatIncreaseButtonInfo?.onConfirmButtonFn == null
          ? SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.only(left: _productionBoxWidth * 10.3),
              child: _ButtonBackground(
                PanelButton(
                  panelButtonBorder: PanelButtonBorder.FULL,
                  onClick: playerPanelInfo
                      .heatIncreaseButtonInfo!.onConfirmButtonFn!,
                  child: Image.asset(
                    Assets.globalParameters.temperature.path,
                    height: height * 0.48,
                  ),
                ),
                color,
              ),
            );

  _prepareGreeneryButton(color, ValueNotifier<bool> hideButtonsN) =>
      playerPanelInfo.greeneryPlacementButtonInfo?.onConfirmButtonFn == null
          ? SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.only(left: _productionBoxWidth * 7.95),
              child: _ButtonBackground(
                PanelButton(
                  panelButtonBorder: PanelButtonBorder.FULL,
                  onClick: () {
                    hideButtonsN.value = true;
                    playerPanelInfo
                        .greeneryPlacementButtonInfo!.onConfirmButtonFn!();
                  },
                  child: Image.asset(
                    Assets.tiles.greeneryNoO2.path,
                    height: height * 0.48,
                  ),
                ),
                color,
              ),
            );
  _ButtonBackground(child, color) => Container(
        padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 2.0, top: 4.0),
        decoration: BoxDecoration(
            color: color,
            border: Border(
              top: BorderSide.none,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            )),
        child: child,
      );

  _commonButtonBlock(color, context, tabInfo, buttonName,
          callOnClickAutomatically, double? padding) =>
      tabInfo == null
          ? SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.only(
                  left: padding == null ? _productionBoxWidth * 11.5 : padding),
              child: _ButtonBackground(
                PanelButton(
                  panelButtonBorder: PanelButtonBorder.FULL,
                  onClick: () =>
                      showPopupWithTabs(context: context, tabsInfo: tabInfo!),
                  buttonText: buttonName ?? ' ',
                  tooltipText: buttonName ?? ' ',
                  callOnClickAutomatically: callOnClickAutomatically,
                ),
                color,
              ),
            );

  _prepareActionNotificationString(color, String? string) => string == null
      ? SizedBox.shrink()
      : Padding(
          padding: EdgeInsets.only(left: 200.0),
          child: _ButtonBackground(
            Text(string,
                style:
                    MAIN_TEXT_STYLE.copyWith(fontSize: 16, letterSpacing: 3.0)),
            color,
          ),
        );

  _preparePassAndSkipButtonsBlock(color) =>
      playerPanelInfo.passButtonInfo?.buttonText == null &&
              playerPanelInfo.skipButtonInfo?.buttonText == null
          ? SizedBox.shrink()
          : Row(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                width: _nameBoxWidth,
              ),
              _ButtonBackground(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _preparePassButton(),
                    _prepareSkipButton(),
                  ],
                ),
                color,
              )
            ]);

  @override
  Widget build(BuildContext context) {
    Color color = playerPanelInfo.playerState.color.toColor(true);
    ValueNotifier<bool> hideButtonsN = ValueNotifier(false);

    final panelView = LayoutBuilder(builder: (context, constraints) {
      final _tagsRowWidth = playerPanelInfo.tagsInfo.length * height * 0.53;
      final productionRowWidth = 8 * (_productionBoxWidth + 4.0);
      final fullPanelWidth = _nameBoxWidth +
          productionRowWidth +
          _timerBlockWidth +
          _cardsButtonWidth +
          _cardsActionCardsButton;
      final minimalScreenWidth =
          productionRowWidth + _cardsButtonWidth + _cardsActionCardsButton;
      final useLowWidthMode = (fullPanelWidth + 10) > constraints.maxWidth;
      final useMobileView = constraints.maxWidth < minimalScreenWidth + 10;

      final List<Widget> components = useMobileView
          ? [
              _prepareResourceBoxList(),
              _prepareTagRow(_tagsRowWidth),
            ]
          : useLowWidthMode
              ? [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    _prepareResourceBoxList(),
                    _prepareCardsButton(),
                    _prepareActionCardsButton(),
                  ]),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _prepareNameBlock(),
                      _prepareTimerBlock(),
                      _prepareRT(),
                      _prepareVP(),
                    ],
                  ),
                  _prepareTagRow(_tagsRowWidth),
                ]
              : [
                  _prepareNameBlock(),
                  _prepareTimerBlock(),
                  _prepareResourceBoxList(),
                  _prepareCardsButton(),
                  _prepareActionCardsButton(),
                  _prepareRT(),
                  _prepareVP(),
                  _prepareTagRow(_tagsRowWidth),
                ];

      return Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: color,
              border: Border.all(
                color: playerPanelInfo
                            .projectCardsTabsInfo.leftTabInfo?.tabTitle ==
                        null
                    ? Colors.black
                    : Colors.white,
                width: 1.0,
              ),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: components,
            ),
          ),
          if (!useMobileView)
            Padding(
              padding:
                  EdgeInsets.only(top: height * (useLowWidthMode ? 1.5 : 0.1)),
              child: playerPanelInfo.showFirstMark
                  ? Image.asset(
                      Assets.misc.firstPlayer.path,
                      width: height * 0.6,
                    )
                  : SizedBox.shrink(),
            ),
        ],
      );
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder(
            valueListenable: hideButtonsN,
            builder: (BuildContext context, bool hideButtons, Widget? child) {
              return Stack(
                children: [
                  if (!hideButtons) ...[
                    _preparePassAndSkipButtonsBlock(color),
                    _commonButtonBlock(
                      color,
                      context,
                      playerPanelInfo.cardsToSelectTabsInfo,
                      playerPanelInfo
                          .cardsToSelectTabsInfo?.rightTabInfo?.tabTitle,
                      true,
                      null,
                    ),
                    _commonButtonBlock(
                      color,
                      context,
                      playerPanelInfo.paymentTabsInfo,
                      playerPanelInfo.paymentTabsInfo?.rightTabInfo?.tabTitle,
                      true,
                      null,
                    ),
                    _commonButtonBlock(
                      color,
                      context,
                      playerPanelInfo.optionsTabsInfo,
                      playerPanelInfo.optionsTabsInfo?.rightTabInfo?.tabTitle,
                      true,
                      null,
                    ),
                    _commonButtonBlock(
                      color,
                      context,
                      playerPanelInfo.amountsTabsInfo,
                      playerPanelInfo.amountsTabsInfo?.rightTabInfo?.tabTitle,
                      true,
                      null,
                    ),
                    _commonButtonBlock(
                      color,
                      context,
                      playerPanelInfo.standartProjectsTabsInfo,
                      playerPanelInfo
                          .standartProjectsTabsInfo?.leftTabInfo?.tabTitle,
                      false,
                      null,
                    ),
                    _commonButtonBlock(
                      color,
                      context,
                      playerPanelInfo.initialTabsInfo,
                      (playerPanelInfo.initialTabsInfo?.leftTabInfo?.tabTitle ??
                              ' ') +
                          ' and ' +
                          (playerPanelInfo
                                  .initialTabsInfo?.rightTabInfo?.tabTitle ??
                              ' '),
                      true,
                      null,
                    ),
                    _prepareTemperatureButton(color),
                    _prepareGreeneryButton(color, hideButtonsN)
                  ],
                  _prepareActionNotificationString(
                    color,
                    playerPanelInfo.actionNotificationString ??
                        (hideButtons ? "Place greenery" : null),
                  ),
                ],
              );
            },
          ),
          panelView,
        ],
      ),
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..lineTo(0, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, size.height)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
