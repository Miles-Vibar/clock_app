import 'package:clock_app/bloc/stopwatch/bloc.dart';
import 'package:clock_app/bloc/timer/bloc.dart';
import 'package:clock_app/bloc/timer/events.dart';
import 'package:clock_app/pages/alarm_page.dart';
import 'package:clock_app/pages/clock_page.dart';
import 'package:clock_app/pages/stopwatch_page.dart';
import 'package:clock_app/pages/timer_page.dart';
import 'package:clock_app/pages/timer_running_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:clock_app/resources/strings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiBlocProvider(
      providers: [
        BlocProvider<StopwatchBloc>(
          create: (context) => StopwatchBloc(),
        ),
        BlocProvider<TimerBloc>(
          create: (context) => TimerBloc()..add(TimerStop()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: colorScheme,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: 5,
            shape: const CircleBorder(),
            backgroundColor: colorScheme.onPrimary,
            foregroundColor: colorScheme.primary,
          ),
          iconButtonTheme: IconButtonThemeData(
            style: IconButton.styleFrom(
              elevation: 5,
              shadowColor: colorScheme.onSurface.withValues(alpha: 0.5),
              padding: EdgeInsets.zero,
              backgroundColor: colorScheme.onPrimary,
            ),
          ),
          iconTheme: IconThemeData(
            color: colorScheme.primary,
          ),
          useMaterial3: true,
        ),
        routerConfig: GoRouter(
          initialLocation: '/alarm',
          routes: [
            StatefulShellRoute.indexedStack(
              branches: [
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/alarm',
                      builder: (context, state) {
                        return const AlarmPage();
                      },
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/clock',
                      builder: (context, state) {
                        return const ClockPage();
                      },
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/stopwatch',
                      builder: (context, state) {
                        return const StopwatchPage();
                      },
                    ),
                  ],
                ),
                StatefulShellBranch(
                  routes: [
                    GoRoute(
                      path: '/timer',
                      routes: [
                        GoRoute(
                          path: '/running',
                          name: '/running',
                          builder: (context, state) {
                            final duration = Duration(
                              hours: int.parse(
                                state.uri.queryParameters['hours'] ?? '0',
                              ),
                              minutes: int.parse(
                                state.uri.queryParameters['minutes'] ?? '0',
                              ),
                              seconds: int.parse(
                                state.uri.queryParameters['seconds'] ?? '0',
                              ),
                            );
                            return TimerRunningPage(originalDuration: duration);
                          },
                        ),
                      ],
                      builder: (context, state) {
                        return const TimerPage();
                      },
                    ),
                  ],
                ),
              ],
              builder: (context, state, navigationShell) {
                return MainLayout(
                  navigationShell: navigationShell,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: Pages.alarm,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_clock),
            label: Pages.clock,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.punch_clock),
            label: Pages.stopwatch,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: Pages.timer,
          ),
        ],
      ),
    );
  }
}
