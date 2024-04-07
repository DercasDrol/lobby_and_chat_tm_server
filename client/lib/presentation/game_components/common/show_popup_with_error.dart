import 'package:flutter/material.dart';

void showPopupWithError({
  required final BuildContext context,
  required final String text,
}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(builder: (context, constraints) {
          return Center(
            child: Container(
              width: constraints.maxWidth * 0.80,
              height: constraints.maxHeight * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(96, 255, 255, 255),
              ),
              child: Text(text),
            ),
          );
        });
      });
}
