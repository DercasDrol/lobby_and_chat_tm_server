import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/CardType.dart';

class CardTypeHeaderView extends StatelessWidget {
  final CardType type;
  final double topPadding;
  final double width;
  final double height;
  const CardTypeHeaderView(
      {super.key,
      required this.width,
      required this.height,
      required this.type,
      required this.topPadding});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case CardType.CORPORATION:
        return Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              //margin: EdgeInsets.only(right: width * 0.25),
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
              width: width,
              height: height,
              child: Center(
                child: Text(
                  'CORPORATION',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: height,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }
}
