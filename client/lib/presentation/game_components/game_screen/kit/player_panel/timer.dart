import 'dart:async';
import 'package:flutter/material.dart';

class TimerView extends StatefulWidget {
  final bool isTimerTurnedOn;
  final Duration duration;
  final String currentPhase;
  TimerView({
    super.key,
    required this.isTimerTurnedOn,
    required this.duration,
    required this.currentPhase,
  });
  @override
  TimerViewState createState() => TimerViewState();
}

class TimerViewState extends State<TimerView> {
  Timer? timer;
  bool countDown = false;
  Duration? duration;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  @override
  void initState() {
    widget.isTimerTurnedOn ? startTimer() : stopTimer();
    duration = widget.duration;
    super.initState();
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = (duration?.inSeconds ?? 0) + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void stopTimer({bool resets = true}) {
    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration?.inHours ?? 0);
    final minutes = twoDigits((duration?.inMinutes ?? 0).remainder(60));
    final seconds = twoDigits((duration?.inSeconds ?? 0).remainder(60));
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.0),
      decoration: BoxDecoration(
        color: widget.isTimerTurnedOn
            ? Colors.white
            : Color.fromARGB(117, 0, 0, 0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(children: [
        Expanded(
            flex: 11,
            child: FittedBox(
                child: Text(widget.currentPhase,
                    style: TextStyle(
                        color: widget.isTimerTurnedOn
                            ? Colors.black
                            : const Color.fromARGB(150, 255, 255, 255))))),
        Expanded(
            flex: 12,
            child: FittedBox(
                child: Text(hours + ":" + minutes + ":" + seconds,
                    style: TextStyle(
                        color: widget.isTimerTurnedOn
                            ? Colors.black
                            : const Color.fromARGB(150, 255, 255, 255),
                        fontWeight: FontWeight.bold)))),
      ]),
    );
  }
}
