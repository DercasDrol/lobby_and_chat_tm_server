import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';

class StarsBackground extends StatelessWidget {
  const StarsBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          Assets.stars.path,
          repeat: ImageRepeat.repeat,
        ));
  }
}
