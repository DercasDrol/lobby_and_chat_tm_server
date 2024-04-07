import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';

class TerraformingRateView extends StatelessWidget {
  final double width;
  final double height;
  final int terraformingRate;

  const TerraformingRateView({
    super.key,
    required this.width,
    required this.height,
    required this.terraformingRate,
  });

  _prepareButtonView(BuildContext context) => Container(
        width: width,
        padding: EdgeInsets.only(left: 1.0, top: 1.0, right: 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Color.fromARGB(117, 0, 0, 0),
        ),
        child: Column(children: [
          Flexible(
              flex: 8,
              child: Padding(
                padding: EdgeInsets.only(left: 1.0, top: 1.0, right: 1.0),
                child: Image.asset(
                  Assets.resources.tr.path,
                ),
              )),
          Flexible(
              flex: 6,
              child: Text(
                terraformingRate.toString(),
                style: MAIN_TEXT_STYLE,
              )),
        ]),
      );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.0, left: 10.0, bottom: 2.0),
      child: Tooltip(
        message: 'TR',
        textStyle: TextStyle(fontSize: 16, color: Colors.white),
        waitDuration: Duration(milliseconds: 500),
        child: _prepareButtonView(context),
      ),
    );
  }
}
