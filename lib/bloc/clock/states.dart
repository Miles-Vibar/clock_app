import 'package:equatable/equatable.dart';
import 'package:timezone/timezone.dart';

abstract class ClockState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading<T extends ClockState> extends ClockState {}

class ClockStart extends ClockState {}

class ClockReady extends ClockState {
  final List<Location> locations;

  ClockReady({required this.locations});

  @override
  List<Object?> get props => [locations];
}

class TimeZonesReady extends ClockState {
  final Map<String, Location> timezones;

  TimeZonesReady({required this.timezones});

  @override
  List<Object?> get props => [timezones];
}

class TimeZoneAddedSuccessfully extends ClockState {
  final Location location;

  TimeZoneAddedSuccessfully({required this.location});

  @override
  List<Object?> get props => [location];
}

class TimeZoneDeletedSuccessfully extends ClockState {}

class Error<T extends ClockState> extends ClockState {
  final Exception exception;

  Error({required this.exception});

  @override
  List<Object?> get props => [exception];
}
