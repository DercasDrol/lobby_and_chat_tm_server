import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';
import 'package:mars_flutter/domain/model/card/ClientCard.dart';
import 'package:mars_flutter/domain/model/card/GameModule.dart';
import 'package:mars_flutter/domain/model/card/Tag.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tag_info.dart';
import 'package:mars_flutter/presentation/core/on_hover.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_background.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_body/card_body.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_resources.dart';
import 'package:mars_flutter/presentation/game_components/common/cost.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_module_icon.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_name.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_requirements.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_tag.dart';

const double CARD_WIDTH = 215;
const double CARD_HEIGHT = 280;
final Color? CARD_BACKGROUND_COLOR = Colors.grey[200];

class CardView extends StatelessWidget {
  CardView({
    required this.card,
    this.onSelect,
    required this.isDeactivated,
    required this.isSelected,
    this.sizeRatio,
    this.resourcesCount,
    this.allCardsDiscount,
    this.tagsDiscounts,
  });

  final double _zoomedCardSizeRatio = 1.2;
  final ClientCard card;
  final bool isSelected;
  final Function? onSelect;
  final bool isDeactivated;
  final double? sizeRatio;
  final int? resourcesCount;
  final int? allCardsDiscount;
  final List<TagInfo>? tagsDiscounts;

  @override
  Widget build(BuildContext context) {
    final double cadr_width = CARD_WIDTH * (sizeRatio ?? 1);
    final double card_height = CARD_HEIGHT * (sizeRatio ?? 1);
    final double _kCardPadding = 6 * (sizeRatio ?? 1);
    Widget _getCardView() {
      final background = CardBackground(
        padding: _kCardPadding,
        borderRadius: _kCardPadding * 2,
        color: CARD_BACKGROUND_COLOR,
        isSelected: isSelected,
      );
      final cardResources = card.resourceType == null
          ? SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.only(
                  top: card_height * 0.033, left: card_height * 0.16),
              child: CardResources(
                resourceCount: resourcesCount ?? 0,
                resourceType: card.resourceType!,
                width: cadr_width * 0.2,
                height: card_height * 0.09,
              ),
            );
      final cardName = Align(
        alignment: Alignment.topCenter,
        child: CardNameView(
          width: (cadr_width - (_kCardPadding * 2) - 4),
          height: card_height * 0.09,
          topPadding: card_height * 0.13,
          type: card.type,
          name: card.name,
        ),
      );
      final cardCost = card.cost == null ||
              [CardType.CORPORATION, CardType.PRELUDE].contains(card.type)
          ? SizedBox.shrink()
          : CostView(
              height: card_height * 0.15,
              width: card_height * 0.15,
              fontSize: _kCardPadding * 3.9,
              cost: card.cost!,
              multiplier: false,
              useGreyMode: isDeactivated,
              discount: card.tags.fold<int?>(
                allCardsDiscount,
                (acc, tag) => (tagsDiscounts?.fold<int?>(
                        acc,
                        (acc0, tagInfo) => tagInfo.tag == tag
                            ? tagInfo.discont + (acc0 ?? 0)
                            : acc0) ??
                    acc),
              ),
            );
      final cardTags = Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: card.tags
                  .map((tag) =>
                      TagView(tagRadius: card_height * 0.135, tag: tag))
                  .toList() +
              (card.type == CardType.EVENT
                  ? [TagView(tagRadius: card_height * 0.135, tag: Tag.EVENT)]
                  : []),
        ),
        alignment: Alignment.topRight,
      );
      final requirementsHeight = card_height * 0.10;
      final cardRequirements = card.requirements == null
          ? SizedBox.shrink()
          : Padding(
              padding: EdgeInsets.only(top: card_height * 0.24),
              child: Align(
                alignment: Alignment.topCenter,
                child: CardRequirementsView(
                  width: cadr_width - 30,
                  height: requirementsHeight,
                  requirements: card.requirements!.requirements,
                ),
              ),
            );
      final cardBodyTopPadding = card.requirements != null
          ? card_height * 0.25 + requirementsHeight
          : card_height * 0.25;
      final cardBody = Padding(
        padding: EdgeInsets.only(top: cardBodyTopPadding),
        child: Align(
          alignment: Alignment.topCenter,
          child: CardBody(
            card: card,
            height: card_height - (card_height * 0.35),
            width: cadr_width - 24,
          ),
        ),
      );
      final cardModuleIcon = card.module == GameModule.BASE
          ? SizedBox.shrink()
          : Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ModuleIconView(
                    iconRadius: 14.0,
                    module: card.module,
                  )));

      return Stack(
        children: [
          background,
          cardResources,
          cardName,
          cardCost,
          cardTags,
          cardRequirements,
          cardModuleIcon,
          cardBody,
        ],
      );
    }

    return sizeRatio == null
        ? OnHoverZoom(
            width: cadr_width,
            height: card_height,
            ratio: _zoomedCardSizeRatio,
            builder: (isHovered) => GestureDetector(
              onTap: () {
                if (onSelect != null) onSelect!(!isSelected);
              },
              child: Opacity(
                opacity: isDeactivated ? 0.8 : 1.0,
                child: _getCardView(),
              ),
            ),
          )
        : _getCardView();
  }
}
