import 'package:equatable/equatable.dart';

abstract class TimerState extends Equatable {}

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

class TimerRunning extends TimerState {
  @override
  List<Object?> get props => [];
}

class TimerPaused extends TimerState {
  @override
  List<Object?> get props => [];
}
