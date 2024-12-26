import 'package:equatable/equatable.dart';

abstract class StopwatchEvent extends Equatable {}

class StopwatchStart extends StopwatchEvent {
  @override
  List<Object?> get props => [];
}

class StopwatchPause extends StopwatchEvent {
  @override
  List<Object?> get props => [];
}

class StopwatchStop extends StopwatchEvent {
  @override
  List<Object?> get props => [];
}

class StopwatchLap extends StopwatchEvent {
  @override
  List<Object?> get props => [];
}
