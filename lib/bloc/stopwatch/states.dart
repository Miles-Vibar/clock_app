import 'package:equatable/equatable.dart';

abstract class StopwatchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StopwatchStopped extends StopwatchState {}

class StopwatchRunning extends StopwatchState {}

class StopwatchPaused extends StopwatchState {}
