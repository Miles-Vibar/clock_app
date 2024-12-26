import 'package:clock_app/bloc/stopwatch/events.dart';
import 'package:clock_app/bloc/stopwatch/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StopwatchBloc extends Bloc<StopwatchEvent, StopwatchState> {
  StopwatchBloc() : super(StopwatchStopped()) {
    on<StopwatchStart>((event, emit) {
      emit(StopwatchRunning());
    });
    on<StopwatchPause>((event, emit) {
      emit(StopwatchPaused());
    });
    on<StopwatchStop>((event, emit) {
      emit(StopwatchStopped());
    });
    on<StopwatchLap>((event, emit) {});
  }
}
