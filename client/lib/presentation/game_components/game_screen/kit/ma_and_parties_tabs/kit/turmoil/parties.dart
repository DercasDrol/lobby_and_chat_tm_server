import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/Color.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_parties_info.dart';
import 'package:mars_flutter/domain/model/turmoil/PartyName.dart';
import 'package:mars_flutter/presentation/game_components/common/game_button_with_cost.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/ma_and_parties_tabs/kit/common/ma_and_party_tile.dart';

class PartyLineView extends StatelessWidget {
  final double width;
  final double height;
  final PresentationTurmoilInfo presentationInfo;
  final PlayerColor playerColor;

  const PartyLineView({
    super.key,
    required this.width,
    required this.height,
    required this.presentationInfo,
    required this.playerColor,
  });

  @override
  Widget build(BuildContext context) {
    final partyNotifiers = Map<PartyName, ValueNotifier<bool>>.fromIterable(
      presentationInfo.turmoilModel.parties,
      key: (e) => e.name,
      value: (e) => ValueNotifier<bool>(false),
    );
    return Container(
      child: Wrap(
        children: presentationInfo.turmoilModel.parties.map(
          (party) {
            final isAvailableForClick =
                (presentationInfo.availableParties ?? []).contains(party.name);
            return ValueListenableBuilder(
              valueListenable: partyNotifiers[party.name]!,
              builder: (context, showButton, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: !isAvailableForClick
                          ? null
                          : () {
                              final bool oldValue =
                                  partyNotifiers[party.name]!.value;
                              partyNotifiers
                                  .forEach((key, value) => value.value = false);
                              partyNotifiers[party.name]!.value = !oldValue;
                            },
                      child: Stack(children: [
                        MaAndPartyTile(
                          party: party,
                          agenda: presentationInfo.turmoilModel.politicalAgendas
                              ?.getAgenda(party.name),
                          isAvailableForClick: isAvailableForClick,
                          height: height,
                          width: width,
                          dominant: presentationInfo.turmoilModel.dominant,
                        )
                      ]),
                    ),
                    showButton
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 3.0),
                            child: GameButtonWithCost(
                              counter: presentationInfo.turmoilModel.lobby
                                      .contains(playerColor)
                                  ? 0
                                  : presentationInfo.delegateCost,
                              onPressed: presentationInfo.onSendDelegate == null
                                  ? null
                                  : () => presentationInfo
                                      .onSendDelegate!(party.name),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ))
                        : SizedBox.shrink()
                  ],
                );
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
