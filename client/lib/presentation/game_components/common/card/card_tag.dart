import 'package:flutter/material.dart';
import 'package:mars_flutter/domain/model/card/Tag.dart';

class TagView extends StatelessWidget {
  final double tagRadius;

  const TagView({
    required this.tag,
    required this.tagRadius,
  });
  final Tag tag;
  @override
  Widget build(BuildContext context) {
    String? imagePath = tag.toImagePath();
    return Padding(
      padding: EdgeInsets.only(left: 1, top: 4, right: 1, bottom: 4),
      child: SizedBox(
        height: tagRadius,
        width: tagRadius,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 0, 0, 0),
                offset: Offset(0.0, 0.0),
                blurRadius: 0.2,
                spreadRadius: 0.2,
              )
            ],
          ),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              imagePath == null
                  ? SizedBox.shrink()
                  : Image(image: AssetImage(imagePath)),
            ],
          ),
        ),
      ),
    );
  }
}
