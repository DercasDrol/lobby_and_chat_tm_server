import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';

class CardTypeHeaderView extends StatelessWidget {
  final CardType type;
  final double cardWidth;
  final double cardHeight;
  final double cardBodyTopPadding;
  const CardTypeHeaderView({
    super.key,
    required this.cardWidth,
    required this.cardHeight,
    required this.type,
    required this.cardBodyTopPadding,
  });

  @override
  Widget build(BuildContext context) {
    getLeftTopView() => Container(
          alignment: Alignment.center,
          margin:
              EdgeInsets.only(top: cardHeight * 0.04, left: cardWidth * 0.06),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 0, 0, 0),
              width: 0.2,
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0)),
            color: type.toColor(),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 0, 0, 0),
                offset: Offset(0.0, 0.0),
                blurRadius: 0.2,
                spreadRadius: 0.2,
              )
            ],
          ),
          width: cardWidth * 0.3,
          height: cardHeight * 0.075,
          child: Text(
            type.toString().toUpperCase(),
            style: TextStyle(
              color: Colors.black,
              fontSize: cardHeight * 0.04,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
        );
    switch (type) {
      case CardType.CORPORATION:
        final double topPadding = cardBodyTopPadding - cardHeight * 0.045;
        return Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 0, 0, 0),
                  width: 0.2,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2.0),
                  topRight: Radius.circular(2.0),
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 255, 153, 0),
                    Color.fromARGB(255, 255, 153, 0),
                    Colors.yellow,
                    Color.fromARGB(255, 255, 153, 0),
                    Color.fromARGB(255, 255, 153, 0),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0),
                    offset: Offset(0.0, 0.0),
                    blurRadius: 0.2,
                    spreadRadius: 0.2,
                  )
                ],
              ),
              width: cardWidth * 0.5,
              height: cardHeight * 0.04,
              child: Center(
                child: Text(
                  'CORPORATION',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: cardHeight * 0.03,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
        );
      case CardType.PRELUDE:
        return getLeftTopView();
      case CardType.CEO:
        return getLeftTopView();
      default:
        return SizedBox.shrink();
    }
  }
}
