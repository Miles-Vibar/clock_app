import 'dart:async';

import 'package:clock_app/bloc/clock/bloc.dart';
import 'package:clock_app/bloc/clock/events.dart';
import 'package:clock_app/bloc/clock/states.dart';
import 'package:clock_app/widgets/custom_fab.dart';
import 'package:clock_app/widgets/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../widgets/default_page_layout.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late DateTime now;
  late Timer timer;

  List<tz.Location> locations = <tz.Location>[];

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClockBloc, ClockState>(
      listener: (context, state) {
        if (state is ClockReady) {
          locations = state.locations;
        }
        if (state is TimeZoneAddedSuccessfully) {
          locations.add(state.location);
        }
      },
      child: Scaffold(
        body: DefaultPageLayout(
          title: const Text(
            'Clock',
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        DateFormat.jms().format(now).toString(),
                        textScaler: const TextScaler.linear(3.0),
                      ),
                      Text('Current: ${DateFormat('dd/MM/yyyy').format(now)}'),
                    ],
                  ),
                ),
              ),
            ),
            BlocBuilder<ClockBloc, ClockState>(
              builder: (context, state) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Tile(
                          time: tz.TZDateTime.from(now, locations[index]),
                          location: locations[index].name.split('/').last,
                          trailing: IconButton(
                            onPressed: () {
                              context.read<ClockBloc>().add(
                                    DeleteTimeZoneEvent(
                                        location: locations[index].name),
                                  );
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      );
                    },
                    childCount: locations.length,
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: CustomFab(
            icon: Icons.add,
            onPressed: () {
              context.read<ClockBloc>().add(AddTimeZoneEvent());
              context.go('/clock/add');
            }),
      ),
    );
  }
}
