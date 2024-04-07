import 'package:equatable/equatable.dart';

class TimerModel extends Equatable {
  final int sumElapsed;
  final int startedAt;
  final bool running;
  final bool afterFirstAction;
  final int lastStoppedAt;

  TimerModel({
    required this.sumElapsed,
    required this.startedAt,
    required this.running,
    required this.afterFirstAction,
    required this.lastStoppedAt,
  });

  static fromJson(Map<String, dynamic> json) {
    return TimerModel(
      sumElapsed: json['sumElapsed'] as int,
      startedAt: json['startedAt'] as int,
      running: json['running'] as bool,
      afterFirstAction: json['afterFirstAction'] as bool,
      lastStoppedAt: json['lastStoppedAt'] as int,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [sumElapsed, startedAt, running, afterFirstAction, lastStoppedAt];
}
