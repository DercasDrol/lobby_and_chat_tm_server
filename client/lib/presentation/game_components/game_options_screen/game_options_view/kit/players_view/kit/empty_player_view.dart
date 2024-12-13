import 'package:flutter/material.dart';

class EmptyPlayerView extends StatelessWidget {
  final bool isSharedGame;
  const EmptyPlayerView({super.key, required this.isSharedGame});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          isSharedGame
              ? 'Waiting for player...'
              : 'Publish the game\nso that someone can join!',
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
