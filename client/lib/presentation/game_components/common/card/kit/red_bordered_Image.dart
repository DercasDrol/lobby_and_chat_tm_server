import 'package:flutter/material.dart';

class RedBorderedImage extends StatelessWidget {
  final String imagePath;
  final Widget? child;
  const RedBorderedImage({super.key, required this.imagePath, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image(
          image: AssetImage(imagePath),
          color: Colors.red,
        ),
        Padding(
          padding: EdgeInsets.all(2),
          child: child ??
              Image(
                image: AssetImage(imagePath),
              ),
        )
      ],
    );
  }
}
