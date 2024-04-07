import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/CardResouce.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';

class CardResources extends StatelessWidget {
  final int resourceCount;
  final CardResource resourceType;
  final double width;
  final double height;

  const CardResources({
    required this.resourceCount,
    required this.width,
    required this.height,
    required this.resourceType,
  });

  @override
  Widget build(BuildContext context) {
    final String? imagePath = resourceType.toImagePath();
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: imagePath == null
          ? SizedBox.shrink()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 1.0),
                    child:
                        Text(resourceCount.toString(), style: MAIN_TEXT_STYLE),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(height * 0.08),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          spreadRadius: 1,
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      resourceType.toImagePath() ?? '',
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
