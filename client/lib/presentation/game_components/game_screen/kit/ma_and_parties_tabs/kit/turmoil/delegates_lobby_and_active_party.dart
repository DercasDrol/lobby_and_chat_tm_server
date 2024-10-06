import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/game_models/TurmoilModel.dart';
import 'package:mars_flutter/presentation/game_components/common/game_button_with_cost.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/ma_and_parties_tabs/kit/common/party_policy_view.dart';

class DelegatesLobbyAndActiveParty extends StatelessWidget {
  final TurmoilModel turmoilModel;
  final double width;
  final double height;
  final void Function()? onApplyPolicyAction;
  const DelegatesLobbyAndActiveParty({
    super.key,
    required this.turmoilModel,
    required this.width,
    required this.height,
    this.onApplyPolicyAction,
  });

  @override
  Widget build(BuildContext context) {
    final delegatesLobby = Padding(
      padding: EdgeInsets.only(top: 1.0, bottom: 1.0),
      child: turmoilModel.lobby.length > 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: turmoilModel.lobby
                  .map(
                    (PlayerColor color) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1.0),
                      child: Container(
                        width: width / 6 - 2,
                        height: height * 0.21,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(3),
                          ),
                          color: color.toColor(true),
                        ),
                        child: Text(
                          ' ',
                          textAlign: TextAlign.center,
                          style: MAIN_TEXT_STYLE,
                        ),
                      ),
                    ),
                  )
                  .cast<Widget>()
                  .toList(),
            )
          : Container(
              width: width * 1.2,
              height: height * 0.21,
            ),
    );

    final availableDelegates = Padding(
        padding: EdgeInsets.only(top: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: turmoilModel.reserve
              .map(
                (DelegatesModel playerDelegates) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0),
                  child: Container(
                    width: width / 6 - 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),
                        ),
                        color: playerDelegates.color.toColor(true)),
                    child: Text(
                      playerDelegates.number.toString(),
                      textAlign: TextAlign.center,
                      style: MAIN_TEXT_STYLE,
                    ),
                  ),
                ),
              )
              .cast<Widget>()
              .toList(),
        ));
    final activeParty = PartyPolicyView(
      width: width,
      height: height,
      agenda: turmoilModel.ruling != null
          ? turmoilModel.politicalAgendas?.getAgenda(turmoilModel.ruling!)
          : null,
      partyName: turmoilModel.ruling,
      chairman: turmoilModel.chairman,
      showBorder: onApplyPolicyAction != null,
    );
    final showButtonN = ValueNotifier<bool>(false);

    return ValueListenableBuilder(
        valueListenable: showButtonN,
        builder: (context, showButton, child) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 3.0,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: onApplyPolicyAction == null
                        ? null
                        : () {
                            showButtonN.value = !showButtonN.value;
                          },
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 1.0,
                        right: 1.0,
                        top: 1.0,
                      ),
                      alignment: Alignment.center,
                      width: width,
                      height: height * 1.12,
                      child: Column(children: [
                        delegatesLobby,
                        activeParty,
                        availableDelegates,
                      ]),
                    )),
                showButton
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 3.0),
                        child: GameButtonWithCost(
                          onPressed: onApplyPolicyAction,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              'Apply Policy',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ))
                    : SizedBox.shrink()
              ]);
        });
  }
}
