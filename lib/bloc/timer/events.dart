import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TimerStart extends TimerEvent {
  final int? hours, minutes, seconds;

  TimerStart({
    this.hours,
    this.minutes,
    this.seconds,
  });

  @override
  List<Object?> get props => [
        hours,
        minutes,
        seconds,
      ];
}

class TimerPause extends TimerEvent {}

class TimerStop extends TimerEvent {}
