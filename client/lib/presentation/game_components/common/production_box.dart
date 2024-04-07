import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

class ProductionBox extends StatelessWidget {
  final Widget child;
  final double padding;
  final double innerPadding;
  const ProductionBox({
    super.key,
    required this.child,
    required this.padding,
    required this.innerPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
          padding: EdgeInsets.all(innerPadding),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 136, 136, 136)),
            borderRadius: BorderRadius.circular(1),
            image: DecorationImage(
              image:
                  Image(image: AssetImage(Assets.misc.production.path)).image,
              fit: BoxFit.fill,
              opacity: 0.95,
            ),
          ),
          child: child),
    );
  }
}
