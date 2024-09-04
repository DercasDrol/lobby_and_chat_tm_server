import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/turmoil/PartyName.dart';
import 'package:mars_flutter/domain/model/turmoil/Types.dart';
import 'package:mars_flutter/presentation/game_components/game_screen/kit/ma_and_parties_tabs/kit/turmoil/kit/party_body.dart';

class PartyPolicyView extends StatelessWidget {
  final double width;
  final double height;
  final Agenda? agenda;
  final PartyName? partyName;
  const PartyPolicyView({
    super.key,
    required this.width,
    required this.height,
    this.agenda,
    required this.partyName,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 4.0,
              right: 4.0,
            ),
            child: Container(
              width: width * 1.2,
              height: height * 0.8,
              decoration: BoxDecoration(
                boxShadow: List.filled(
                  2,
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 2,
                  ),
                ),
              ),
              child: PartyBodyView(
                agenda: agenda,
                width: width,
                height: height * 0.8,
                showPolicy: true,
              ),
            ),
          ),
          if (partyName != null && partyName?.toColor() != null)
            Container(
              width: width * 1.2,
              height: height * 0.27,
              color: partyName!.toColor(),
            ),
          if (partyName != null)
            Padding(
              padding: EdgeInsets.only(bottom: 2.0),
              child: Text(
                partyName.toString().toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: partyName?.toColor() != null &&
                          partyName != PartyName.SCIENTISTS
                      ? FontWeight.w500
                      : FontWeight.bold,
                  color: partyName?.toColor() != null &&
                          partyName != PartyName.SCIENTISTS
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
