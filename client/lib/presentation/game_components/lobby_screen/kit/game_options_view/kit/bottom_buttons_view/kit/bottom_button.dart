import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  const BottomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 0,
      onPressed: onPressed,
      child: Text(text),
      color: Colors.white,
      textColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
