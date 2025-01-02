import 'package:equatable/equatable.dart';

abstract class StopwatchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StopwatchStart extends StopwatchEvent {}

class StopwatchPause extends StopwatchEvent {}

class StopwatchStop extends StopwatchEvent {}

class StopwatchLap extends StopwatchEvent {}
