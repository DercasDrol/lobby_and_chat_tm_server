import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/turmoil/Types.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/card_body.dart';

class PartyBodyView extends StatelessWidget {
  final Agenda? agenda;
  final bool showPolicy;
  final double width;
  final double height;
  const PartyBodyView({
    super.key,
    required this.agenda,
    required this.width,
    required this.height,
    this.showPolicy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: showPolicy
            ? null
            : BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade400,
            Colors.grey.shade500,
            Colors.grey.shade400,
            Colors.grey.shade300,
            Colors.grey.shade400,
            Colors.grey.shade500,
            Colors.grey.shade400,
            Colors.grey.shade300,
          ],
        ),
      ),
      child: agenda != null
          ? Container(
              padding: EdgeInsets.only(bottom: width * 0.15),
              alignment: Alignment.center,
              child: CardBody(
                width: width,
                height: height,
                elementsSizeMultiplicator: showPolicy ? 2.3 : 2.2,
                renderData: showPolicy
                    ? agenda!.policyId.renderData
                    : agenda!.bonusId.renderData,
              ))
          : null,
    );
  }
}
