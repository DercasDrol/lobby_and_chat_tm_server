import 'package:flutter/material.dart';
import 'package:mars_flutter/data/asset_paths_gen/assets.gen.dart';
import 'package:mars_flutter/domain/model/card/render/AltSecondaryTag.dart';
import 'package:mars_flutter/domain/model/card/render/CardComponents.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/empty_tag_view.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_body/utils.dart';
import 'package:mars_flutter/presentation/game_components/common/card/kit/card_requirements.dart';

class SecondaryTagView extends StatelessWidget {
  final SecondaryTag secondaryTag;
  final double width;
  final double height;
  const SecondaryTagView({
    super.key,
    required this.secondaryTag,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (secondaryTag.tag != null) {
      return Image(
        image: AssetImage(secondaryTag.tag!.toImagePath() ?? ""),
        width: width,
        height: height,
      );
    } else {
      switch (secondaryTag.secTag) {
        case AltSecondaryTag.REQ:
          return RequirementsBackground(
            height: height * 0.7,
            width: width,
            isMax: false,
          );
        case AltSecondaryTag.BLUE:
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
          );
        case AltSecondaryTag.NO_TAGS:
          return EmptyTagView(width: width, height: height);
        case AltSecondaryTag.NO_PLANETARY_TAG:
          return Stack(
            children: [
              Image(
                image: AssetImage(Assets.tags.clone.path),
                width: width,
                height: height,
              ),
              CrossView(
                size: width,
                color: Colors.red.withOpacity(0.5),
                strokeWidth: 1.0,
              ),
            ],
          );
        case AltSecondaryTag.DIVERSE:
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green,
                  Colors.yellow,
                  Colors.red,
                ],
              ),
            ),
          );
        default:
          return Image(
            image: AssetImage(secondaryTag.secTag!.toImagePath() ?? ""),
            width: width,
            height: height,
          );
      }
    }
  }
}
