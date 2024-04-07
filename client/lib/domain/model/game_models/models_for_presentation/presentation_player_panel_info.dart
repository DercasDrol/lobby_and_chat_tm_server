import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/game_models/ActionLabel.dart';
import 'package:mars_flutter/domain/model/game_models/PlayerModel.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_button_info.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tabs_info.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tag_info.dart';

class PresentationPlayerPanelInfo {
  final PublicPlayerModel playerState;
  final List<PlayerColor> passedPlayers;
  final ActionLabel? actionLabel;
  final bool showFirstMark;
  final int availableActionsCount;
  final PresentationButtonInfo? greeneryPlacementButtonInfo;
  final PresentationButtonInfo? heatIncreaseButtonInfo;
  final PresentationButtonInfo? passButtonInfo;
  final PresentationButtonInfo? skipButtonInfo;
  final PresentationTabsInfo? actionsOnCardsTabsInfo;
  final PresentationTabsInfo projectCardsTabsInfo;
  final PresentationTabsInfo? standartProjectsTabsInfo;
  final PresentationTabsInfo? paymentTabsInfo;
  final PresentationTabsInfo? optionsTabsInfo;
  final PresentationTabsInfo? initialTabsInfo;
  final PresentationTabsInfo? cardsToSelectTabsInfo;
  final List<TagInfo> tagsInfo;
  final int allCardsDiscount;
  PresentationPlayerPanelInfo({
    this.standartProjectsTabsInfo,
    this.greeneryPlacementButtonInfo,
    this.heatIncreaseButtonInfo,
    this.passButtonInfo,
    this.skipButtonInfo,
    required this.projectCardsTabsInfo,
    required this.playerState,
    required this.passedPlayers,
    this.actionLabel,
    required this.showFirstMark,
    required this.availableActionsCount,
    this.actionsOnCardsTabsInfo,
    this.paymentTabsInfo,
    this.optionsTabsInfo,
    this.initialTabsInfo,
    required this.tagsInfo,
    required this.allCardsDiscount,
    this.cardsToSelectTabsInfo,
  });
}
