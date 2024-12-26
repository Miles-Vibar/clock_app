import 'package:equatable/equatable.dart';

abstract class StopwatchState extends Equatable {}

class StopwatchStopped extends StopwatchState {
  @override
  List<Object?> get props => [];
}

class StopwatchRunning extends StopwatchState {
  @override
  List<Object?> get props => [];
}

class StopwatchPaused extends StopwatchState {
  @override
  List<Object?> get props => [];
}
