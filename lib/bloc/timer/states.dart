import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TimerStopped extends TimerState {
  final int hours, minutes, seconds;

  TimerStopped({
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  @override
  List<Object?> get props => [
        hours,
        minutes,
        seconds,
      ];
}

class TimerRunning extends TimerState {}

class TimerPaused extends TimerState {}
