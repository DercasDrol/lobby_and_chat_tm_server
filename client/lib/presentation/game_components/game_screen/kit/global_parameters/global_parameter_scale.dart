import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_global_scales_info.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';

class GlobalParameterScaleView extends StatelessWidget {
  final int startValue;
  final int endValue;
  final int stepValue;
  final int currentValue;
  final Map<int, Widget>? bonusItems;
  final double width;
  final double height;
  final List<Color> colors;
  final Widget icon;
  final String? header;
  final String? suffix;
  final bool? showPlusForPositiveValues;
  final double? backgroundImageOpacity;
  final String? backgroundImage;
  final ScaleAction? scaleAction;
  final Function()? onApplyScaleAction;
  const GlobalParameterScaleView({
    required this.startValue,
    required this.endValue,
    required this.stepValue,
    required this.width,
    required this.height,
    required this.colors,
    required this.icon,
    required this.currentValue,
    this.bonusItems,
    this.header,
    this.suffix,
    this.showPlusForPositiveValues,
    this.backgroundImage,
    this.backgroundImageOpacity,
    this.scaleAction,
    this.onApplyScaleAction,
  });

  @override
  Widget build(BuildContext context) {
    final double maxPadding = 3.0;
    final int itemsCount = (endValue - startValue) ~/ stepValue + 1;
    final int itemsCountWithBonus = (bonusItems?.length ?? 0) + itemsCount;
    final Widget separator = Container(
      height: 1.0,
      width: width - maxPadding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
      ),
    );
    Widget prepareItem(int index) {
      final int indexValue = startValue + (index * stepValue);
      final Widget? bonusItem = bonusItems?[indexValue];
      final double itemHeight =
          (bonusItem == null ? 1 : 2) * (height / itemsCountWithBonus) - 1;
      final String text =
          (indexValue > 0 && (showPlusForPositiveValues ?? false) ? "+" : "") +
              indexValue.toString() +
              (suffix ?? '');
      return Column(children: [
        separator,
        Container(
          height: (currentValue == indexValue ? 6 : 0) + itemHeight,
          width: width - maxPadding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: currentValue == indexValue
                  ? Color.fromARGB(255, 255, 217, 0)
                  : Colors.transparent,
              width: currentValue == indexValue ? 2.0 : 0.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                style: MAIN_TEXT_STYLE,
                text == "" ? " " : text,
              ),
              bonusItem != null
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 0.5),
                      height: itemHeight / 2 - 1.0,
                      width: width - maxPadding,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 9,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: bonusItem,
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ]);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: maxPadding * 0.33),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: Colors.grey[900],
          border: Border.all(
            color: Colors.white.withOpacity(0.4),
            width: 1.0,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(maxPadding * 0.66),
          width: width,
          decoration: BoxDecoration(
            image: backgroundImage == null
                ? null
                : DecorationImage(
                    opacity: backgroundImageOpacity ?? 0.35,
                    image: AssetImage(backgroundImage!),
                    fit: BoxFit.fill,
                  ),
            borderRadius: BorderRadius.circular(3.0),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            verticalDirection: VerticalDirection.up,
            children: [
              if (scaleAction != null)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2.0),
                  child: TextButton.icon(
                    onPressed: onApplyScaleAction,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Colors.white.withOpacity(0.6),
                      ),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    label: Center(
                        child: Text(
                      scaleAction == ScaleAction.INCREASE ? "+" : "-",
                      style: MAIN_TEXT_STYLE,
                    )),
                  ),
                ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.0),
                width: width - maxPadding,
                height: width - maxPadding,
                child: icon,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      spreadRadius: 3,
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              separator,
              ...List.generate(
                itemsCount,
                prepareItem,
              ),
              if (header != null)
                Text(
                  header!,
                  style: MAIN_TEXT_STYLE,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
