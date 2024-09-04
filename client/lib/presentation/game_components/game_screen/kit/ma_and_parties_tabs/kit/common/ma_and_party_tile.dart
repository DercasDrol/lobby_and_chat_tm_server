import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:mars_flutter/domain/model/game_models/TurmoilModel.dart';
import 'package:mars_flutter/domain/model/game_models/ma_model.dart';
import 'package:mars_flutter/domain/model/i_ma_and_party_score.dart';
import 'package:mars_flutter/domain/model/ma/MilestoneAwardMetadata.dart';
import 'package:mars_flutter/domain/model/turmoil/PartyName.dart';
import 'package:mars_flutter/domain/model/turmoil/Types.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/ma_and_parties_tabs/kit/common/party_policy_view.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/ma_and_parties_tabs/kit/turmoil/kit/party_body.dart';

class MaAndPartyTile extends StatelessWidget {
  final MaModel? ma;
  final PartyModel? party;
  final Agenda? agenda;
  final double width;
  final double height;
  final bool? isAvailableForClick;
  get _name => ma?.name ?? party?.name ?? ' ';
  Color? get _partyColor => party?.name.toColor();
  get _image => ma?.name.toImagePath() != null
      ? DecorationImage(
          fit: BoxFit.none,
          alignment: Alignment(0.0, -0.6),
          image: AssetImage(
            _name.toImagePath()!,
          ),
        )
      : null;
  get _partyBody => party != null && agenda != null
      ? PartyBodyView(agenda: agenda!, width: width, height: height)
      : null;
  const MaAndPartyTile({
    Key? key,
    this.ma,
    required this.width,
    required this.height,
    this.isAvailableForClick = false,
    this.party,
    this.agenda,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 1.0,
        right: 1.0,
        top: 1.0,
      ),
      alignment: Alignment.center,
      width: width,
      height: height * 1.12,
      child: JustTheTooltip(
        backgroundColor: Colors.black.withOpacity(0.1),
        content: (ma != null
            ? Text(
                MilestoneAwardMetadata.allMilestoneAwards
                    .firstWhere((m) => m.name == _name)
                    .description,
                style: TextStyle(fontSize: 16, color: Colors.white))
            : PartyPolicyView(
                width: width,
                height: height,
                agenda: agenda,
                partyName: party?.name,
              )),
        waitDuration: Duration(milliseconds: 500),
        child: Column(children: [
          ..._image == null && _partyBody == null
              ? []
              : [
                  FittedBox(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 4.0,
                            right: 4.0,
                            top: 4.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            color: (isAvailableForClick ?? false) &&
                                    _partyBody == null
                                ? Colors.white
                                : Colors.black,
                          ),
                          child: Container(
                            width: width * 1.2,
                            height: height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              boxShadow: List.filled(
                                2,
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 2,
                                ),
                              ),
                              image: _image,
                            ),
                            child: _partyBody,
                          ),
                        ),
                        if (_partyColor != null)
                          Container(
                            width: width * 1.2,
                            height: height * 0.31,
                            color: _partyColor,
                          ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            _name.toString().toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: _partyColor != null &&
                                      party?.name != PartyName.SCIENTISTS
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              color: _partyColor != null &&
                                      party?.name != PartyName.SCIENTISTS
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
          ...[
            Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: (ma?.scores ?? party?.delegates)!
                      .map(
                        (IMaAndPartyScore e) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.0),
                          child: Container(
                            width: width / 6 - 2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(3),
                                ),
                                color: e.color.toColor(true)),
                            child: Text(
                              e.number.toString(),
                              textAlign: TextAlign.center,
                              style: MAIN_TEXT_STYLE,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ))
          ]
        ]),
      ),
    );
  }
}
