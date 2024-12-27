import 'package:clock_app/bloc/timer/events.dart';
import 'package:clock_app/bloc/timer/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc() : super(TimerStopped(hours: 0, minutes: 0, seconds: 0)) {
    on<TimerStart>((event, emit) async {
      if (event.minutes != null &&
          event.hours != null &&
          event.seconds != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('hours', event.hours!);
        await prefs.setInt('minutes', event.minutes!);
        await prefs.setInt('seconds', event.seconds!);
      }

      emit(TimerRunning());
    });
    on<TimerPause>((event, emit) {
      emit(TimerPaused());
    });
    on<TimerStop>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      int hours = prefs.getInt('hours') ?? 0;
      int minutes = prefs.getInt('minutes') ?? 0;
      int seconds = prefs.getInt('seconds') ?? 0;
      emit(
        TimerStopped(
          hours: hours,
          minutes: minutes,
          seconds: seconds,
        ),
      );
    });
  }
}
