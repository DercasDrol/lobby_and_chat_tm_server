import 'package:flutter/material.dart';

class PoliticView extends StatelessWidget {
  final bool withRedBorder;
  final String imagePath;
  const PoliticView(
      {super.key, required this.withRedBorder, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(2.0),
          bottomRight: Radius.circular(2.0),
        ),
        color: Colors.black.withOpacity(0.95),
        border: withRedBorder
            ? Border.all(
                color: Colors.red,
                width: 1.5,
              )
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(2.0),
        child: Image(image: AssetImage(imagePath)),
      ),
    );
  }
}
