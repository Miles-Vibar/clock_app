import 'package:clock_app/bloc/clock/bloc.dart';
import 'package:clock_app/bloc/clock/events.dart';
import 'package:clock_app/bloc/clock/states.dart';
import 'package:clock_app/widgets/default_page_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TimeZonePage extends StatefulWidget {
  const TimeZonePage({super.key});

  @override
  State<TimeZonePage> createState() => _TimeZonePageState();
}

class _TimeZonePageState extends State<TimeZonePage> {
  String _filter = '';
  List<String> timezones = [];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClockBloc, ClockState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        if (state is TimeZonesReady) {
          timezones =
              state.timezones.values.map((value) => value.name).toList();
        }
        return Scaffold(
          appBar: AppBar(),
          body: DefaultPageLayout(
            title: const Text('Select City'),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SearchAnchor(
                    viewOnChanged: (value) {
                      setState(() {
                        _filter = value;
                      });
                    },
                    builder: (context, controller) {
                      return SearchBar(
                        leading: const Icon(Icons.search),
                        hintText: 'Search for country or city',
                        onTap: () => controller.openView(),
                      );
                    },
                    suggestionsBuilder: (context, controller) {
                      if (state is TimeZonesReady) {
                        final regExp = RegExp(_filter);
                        return timezones
                            .where((location) =>
                                regExp.hasMatch(location.toLowerCase()))
                            .toList()
                            .sublist(0, 20)
                            .map(
                              (location) => ListTile(
                                  onTap: () {
                                    context.read<ClockBloc>().add(
                                        SaveTimeZoneEvent(location: location));
                                    controller.closeView(location);
                                    context.pop();
                                  },
                                  title: Text(location)),
                            );
                      }

                      return [];
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
