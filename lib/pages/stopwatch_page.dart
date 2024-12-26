import 'dart:async';

import 'package:clock_app/bloc/stopwatch/bloc.dart';
import 'package:clock_app/bloc/stopwatch/events.dart';
import 'package:clock_app/bloc/stopwatch/states.dart';
import 'package:clock_app/widgets/default_page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef RemovedItemBuilder<E> = Widget Function(
    E item, BuildContext context, Animation<double> animation);

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final _controller = ScrollController();
  final _timeList = <Duration>[];
  final _listKey = GlobalKey<SliverAnimatedListState>();
  final _stopwatch = Stopwatch();

  String _elapsedTime = '00:00.00';
  Timer? _timer;

  _start() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      final time = _stopwatch.elapsed;
      setState(() {
        _elapsedTime = _formatTimeString(time);
      });
    });
  }

  String _formatTimeString(Duration time) {
    return '${time.inMinutes.remainder(75).toString().padLeft(2, '0')}:${time.inSeconds.remainder(75).toString().padLeft(2, '0')}.${(time.inMilliseconds % 1000 ~/ 10).toString().padRight(2, '0')}';
  }

  _stop() {
    _listKey.currentState?.removeAllItems(
      (context, animation) => const SizedBox(),
    );
    _timeList.clear();
    _stopwatch.reset();
    setState(() {
      _elapsedTime = '00:00.00';
    });
    _timer?.cancel();
    _controller.animateTo(
      _controller.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
    _listKey.currentState?.didChangeDependencies();
  }

  _pause() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  _add() {
    if (_timeList.isEmpty) {
      _controller.animateTo(
        400,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
    _timeList.insert(0, _stopwatch.elapsed);
    _listKey.currentState?.insertItem(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StopwatchBloc, StopwatchState>(
      builder: (context, state) {
        return Scaffold(
          body: DefaultPageLayout(
            title: const Text(
              'Stopwatch',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SliverFillRemaining(
                child: CustomScrollView(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      floating: false,
                      delegate: HeaderDelegate(
                        elapsedTime: _elapsedTime,
                      ),
                    ),
                    SliverFillRemaining(
                      child: CustomScrollView(
                        slivers: [
                          SliverAnimatedList(
                            key: _listKey,
                            itemBuilder: (context, index, animation) {
                              return SizeTransition(
                                sizeFactor: animation,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        (_timeList.length - index)
                                            .toString()
                                            .padLeft(2, '0'),
                                      ),
                                      Text(
                                        '+ ${_formatTimeString(_timeList[index] - (_timeList.length - index > 1 ? _timeList[index + 1] : const Duration()))}',
                                      ),
                                      Text(
                                        _formatTimeString(_timeList[index]),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            initialItemCount: 0,
                          ),
                        ],
                      ),
                    ),
                    const SliverSafeArea(
                      sliver: SliverFillRemaining(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (state is StopwatchPaused)
                  SizedBox(
                    height: 75,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: FilledButton(
                        onPressed: () {
                          _stop();
                          context.read<StopwatchBloc>().add(StopwatchStop());
                        },
                        child: const Center(
                          child: Icon(
                            Icons.stop,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (state is StopwatchPaused)
                  SizedBox(
                    height: 75,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: FilledButton(
                        onPressed: () {
                          if (!_stopwatch.isRunning) {
                            _start();
                            context.read<StopwatchBloc>().add(StopwatchStart());
                          }
                        },
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (state is StopwatchStopped)
                  SizedBox(
                    width: 150,
                    height: 75,
                    child: FilledButton(
                      onPressed: () {
                        if (!_stopwatch.isRunning) {
                          _start();
                          context.read<StopwatchBloc>().add(StopwatchStart());
                        }
                      },
                      child: const Icon(
                        Icons.play_arrow,
                        size: 40,
                      ),
                    ),
                  ),
                if (state is StopwatchRunning)
                  SizedBox(
                    height: 75,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: FilledButton(
                        onPressed: () {
                          _add();
                          context.read<StopwatchBloc>().add(StopwatchLap());
                        },
                        child: const Center(
                          child: Icon(
                            Icons.flag,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (state is StopwatchRunning)
                  SizedBox(
                    height: 75,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: FilledButton(
                        onPressed: () {
                          if (_stopwatch.isRunning) {
                            _pause();
                            context.read<StopwatchBloc>().add(StopwatchPause());
                          }
                        },
                        child: const Center(
                          child: Icon(
                            Icons.pause,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  final String elapsedTime;

  HeaderDelegate({required this.elapsedTime});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Center(
        child: Text(
          elapsedTime,
          textScaler: TextScaler.linear(4 - (shrinkOffset / maxExtent)),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 500;

  @override
  double get minExtent => 100;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
