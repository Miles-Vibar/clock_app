import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {}

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

class TimerPause extends TimerEvent {
  @override
  List<Object?> get props => [];
}

class TimerStop extends TimerEvent {
  @override
  List<Object?> get props => [];
}
