import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:clock_app/bloc/timer/bloc.dart';
import 'package:clock_app/bloc/timer/states.dart';
import 'package:clock_app/data/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/timer/events.dart';
import '../widgets/custom_fab.dart';
import '../widgets/default_page_layout.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final _hoursController = CarouselSliderController();
  final _minutesController = CarouselSliderController();
  final _secondsController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    NotificationService().init();
  }

  @override
  Widget build(BuildContext context) {
    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    return BlocBuilder<TimerBloc, TimerState>(builder: (context, state) {
      if (state is TimerStopped) {
        hours = state.hours;
        minutes = state.minutes;
        seconds = state.seconds;

        SchedulerBinding.instance.addPostFrameCallback((duration) {
          _hoursController.jumpToPage(hours);
          _minutesController.jumpToPage(minutes);
          _secondsController.jumpToPage(seconds);
        });
      }
      return Scaffold(
        body: DefaultPageLayout(
          physics: const NeverScrollableScrollPhysics(),
          title: const Text(
            'Timer',
          ),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TimerCarouselSlider(
                    value: 24,
                    controller: _hoursController,
                    onPageChanged: (value) => hours = value,
                  ),
                  const TimerVerticalSliderDivider(),
                  TimerCarouselSlider(
                    value: 60,
                    controller: _minutesController,
                    onPageChanged: (value) => minutes = value,
                  ),
                  const TimerVerticalSliderDivider(),
                  TimerCarouselSlider(
                    value: 60,
                    controller: _secondsController,
                    onPageChanged: (value) => seconds = value,
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (state is TimerStopped)
              CustomFab(
                width: 150,
                icon: Icons.play_arrow,
                onPressed: () {
                  context.goNamed(
                    '/running',
                    queryParameters: {
                      'hours': '$hours',
                      'minutes': '$minutes',
                      'seconds': '${hours == 0 && minutes == 0 && seconds == 0 ? 3 : seconds}',
                    },
                  );
                  context.read<TimerBloc>().add(TimerStart(hours: hours, minutes: minutes, seconds: seconds));
                },
              ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    });
  }
}

class TimerCarouselSlider extends StatelessWidget {
  const TimerCarouselSlider({
    super.key,
    required this.value,
    this.controller,
    required this.onPageChanged,
  });

  final int value;
  final CarouselSliderController? controller;
  final Function(int index) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: CarouselSlider.builder(
        options: CarouselOptions(
          enlargeCenterPage: true,
          height: 500,
          aspectRatio: 1 / 5,
          viewportFraction: 0.2,
          enableInfiniteScroll: true,
          scrollDirection: Axis.vertical,
          onPageChanged: (index, reason) => onPageChanged(index),
        ),
        carouselController: controller,
        itemCount: value,
        itemBuilder: (context, itemIndex, pageViewIndex) {
          return Center(
            child: Text(
              itemIndex.toString().padLeft(2, '0'),
              textScaler: const TextScaler.linear(3.0),
            ),
          );
        },
      ),
    );
  }
}

class TimerVerticalSliderDivider extends StatelessWidget {
  const TimerVerticalSliderDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        SizedBox(
          height: 500,
          child: VerticalDivider(
            color: Colors.grey[300],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          height: 100,
          child: const Center(
            child: Text(
              ':',
              textScaler: TextScaler.linear(3.0),
            ),
          ),
        )
      ],
    );
  }
}
