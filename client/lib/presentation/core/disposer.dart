import 'package:flutter/material.dart';

class Disposer extends StatefulWidget {
  const Disposer({super.key, required this.dispose, required this.child});
  final Widget child;
  final void Function() dispose;
  @override
  State<Disposer> createState() => _DisposerState();
}

class _DisposerState extends State<Disposer> {
  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
