import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tabs_info.dart';
import 'package:mars_flutter/presentation/game_components/common/card/card_view.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/popups/show_popup_with_tabs.dart';

class ActionCardsButton extends StatelessWidget {
  final double width;
  final double height;
  final int availableActionsCount;
  final PresentationTabsInfo? tabsInfo;

  const ActionCardsButton({
    super.key,
    required this.width,
    required this.height,
    required this.availableActionsCount,
    this.tabsInfo,
  });

  Widget _prepareButtonView(BuildContext context) => Container(
      width: width,
      padding: EdgeInsets.only(left: 3.0, top: 3.0, right: 3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Color.fromARGB(117, 0, 0, 0),
      ),
      child: Stack(alignment: Alignment.center, children: [
        Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(alignment: Alignment.center, children: [
            Container(
                width: width * 0.7,
                height: width * 0.5 * 1.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: CARD_BACKGROUND_COLOR,
                )),
            Padding(
              padding: EdgeInsets.only(bottom: width * 0.3),
              child: Container(
                decoration: BoxDecoration(
                  color: CardType.ACTIVE.toColor(),
                ),
                child: SizedBox(
                  width: width * 0.7,
                  height: width * 0.2,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: width * 0.3, left: width * 0.1, right: width * 0.1),
                child: Image.asset(Assets.misc.arrow.path))
          ]),
          Text(
            availableActionsCount.toString(),
            style: MAIN_TEXT_STYLE.copyWith(fontSize: height * 0.32),
          ),
        ]),
        MaterialButton(
          onPressed: () {
            if (tabsInfo != null)
              showPopupWithTabs(context: context, tabsInfo: tabsInfo!);
          },
          child: Container(),
        )
      ]));
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Tooltip(
        message: 'Cards with available actions: $availableActionsCount',
        textStyle: TextStyle(fontSize: 16, color: Colors.white),
        waitDuration: Duration(milliseconds: 500),
        child: _prepareButtonView(context),
      ),
    );
  }
}
