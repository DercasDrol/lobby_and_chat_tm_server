import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/game_models/models_for_presentation/presentation_tag_info.dart';
import 'package:mars_flutter/presentation/game_components/common/cost.dart';
import 'package:mars_flutter/presentation/game_components/common/styles.dart';

class TagRowView extends StatelessWidget {
  final double width;
  final double height;
  final List<TagInfo> tagsInfo;

  const TagRowView({
    required this.width,
    required this.height,
    required this.tagsInfo,
  });

  _prepareButtonView(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.only(left: 1.0, top: 1.0, right: 1.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Color.fromARGB(117, 0, 0, 0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: tagsInfo
            .map(
              (tagInfo) => Column(mainAxisSize: MainAxisSize.min, children: [
                Flexible(
                  flex: 10,
                  child: Tooltip(
                    message: tagInfo.tag.toString(),
                    textStyle: TextStyle(fontSize: 16, color: Colors.white),
                    waitDuration: Duration(milliseconds: 500),
                    child: Padding(
                      padding: EdgeInsets.only(left: 0.5, top: 0.5, right: 0.5),
                      child: Stack(
                        children: [
                          Image.asset(
                            opacity: tagInfo.count > 0
                                ? null
                                : AlwaysStoppedAnimation(.3),
                            height: height * 0.50,
                            tagInfo.tag.toImagePath() ?? Assets.tags.wild.path,
                          ),
                          tagInfo.discont > 0
                              ? CostView(
                                  cost: -tagInfo.discont,
                                  width: height * 0.31,
                                  height: height * 0.31,
                                  multiplier: false,
                                  useGreyMode: false,
                                  useShadow: true,
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 6,
                  child: tagInfo.count > 0
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 2.0),
                          child: Text(
                            tagInfo.count.toString(),
                            textAlign: TextAlign.center,
                            style: MAIN_TEXT_STYLE,
                          ))
                      : SizedBox.shrink(),
                ),
              ]),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.0, left: 10.0, bottom: 2.0),
      child: _prepareButtonView(context),
    );
  }
}
