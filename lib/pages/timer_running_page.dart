import 'dart:async';

import 'package:clock_app/bloc/timer/bloc.dart';
import 'package:clock_app/bloc/timer/events.dart';
import 'package:clock_app/bloc/timer/states.dart';
import 'package:clock_app/data/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_fab.dart';

class TimerRunningPage extends StatefulWidget {
  const TimerRunningPage({
    super.key,
    required this.originalDuration,
  });

  final Duration originalDuration;

  @override
  State<TimerRunningPage> createState() => _TimerRunningPageState();
}

class _TimerRunningPageState extends State<TimerRunningPage> {
  late int _hours;
  late int _minutes;
  late int _seconds;

  late Timer _timer;

  late Duration _duration;
  double _progress = 1.0;
  int _ticks = 0;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _duration = widget.originalDuration;
    _start();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _start() {
    _hours = _duration.inHours;
    _minutes = _duration.inMinutes;
    _seconds = _duration.inSeconds;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress = (((widget.originalDuration.inMilliseconds / 100) -
                (timer.tick + _ticks)) /
            (widget.originalDuration.inMilliseconds / 100));

        if (_minutes.remainder(60) == 0 &&
            _seconds.remainder(60) == 0 &&
            _minutes >= 60 &&
            (timer.tick + _ticks).remainder(10) == 0) {
          _hours--;
        }

        if (_seconds.remainder(60) == 0 &&
            _seconds >= 60 &&
            (timer.tick + _ticks).remainder(10) == 0) {
          _minutes--;
        }

        if ((timer.tick + _ticks).remainder(10) == 0) {
          _seconds--;
        }
      });

      if ((timer.tick + _ticks) ==
          (widget.originalDuration.inMilliseconds / 100)) {
        timer.cancel();
        NotificationService().showNotification(
          title: 'Timer Finished',
          body: 'Timer has finished counting down!',
        );
        setState(() {
          _isFinished = true;
        });
      }
    });
  }

  void _pause() {
    _timer.cancel();
    _duration = Duration(
        hours: _hours,
        minutes: _minutes.remainder(60),
        seconds: _seconds.remainder(60));
    _ticks += _timer.tick;
  }

  void _stop() {
    _timer.cancel();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(builder: (context, state) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: BackButton(
              style: IconButton.styleFrom(
                elevation: 0,
              ),
              onPressed: () {
                context.pop();
                context.read<TimerBloc>().add(TimerStop());
              },
            ),
          ),
          body: Center(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 8,
                    strokeCap: StrokeCap.round,
                    color: (state is TimerPaused)
                        ? Theme.of(context).disabledColor
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  '${_hours.toString().padLeft(2, '0')}:${_minutes.remainder(60).toString().padLeft(2, '0')}:${_seconds.remainder(60).toString().padLeft(2, '0')}',
                  textScaler: const TextScaler.linear(3.0),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (state is TimerPaused || state is TimerRunning)
                CustomFab(
                  icon: Icons.stop,
                  onPressed: () {
                    _stop();
                    context.read<TimerBloc>().add(TimerStop());
                  },
                ),
              if (state is TimerPaused)
                CustomFab(
                  icon: Icons.play_arrow,
                  onPressed: () {
                    context.read<TimerBloc>().add(TimerStart());
                    _start();
                  },
                ),
              if (state is TimerRunning && !_isFinished)
                CustomFab(
                  icon: Icons.pause,
                  onPressed: () {
                    _pause();
                    context.read<TimerBloc>().add(TimerPause());
                  },
                ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ),
      );
    });
  }
}
