import 'package:flutter/material.dart';

class FilterItemView extends StatelessWidget {
  final String text;
  final List<String> images;
  const FilterItemView({super.key, required this.text, required this.images});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: Text(text,
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1.15))),
        ...images
            .map(
              (image) => Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Image.asset(
                  image,
                  width: 20.0,
                  height: 20.0,
                ),
              ),
            )
            .toList(),
      ],
    );
  }
}
