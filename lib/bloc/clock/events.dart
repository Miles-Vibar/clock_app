import 'package:equatable/equatable.dart';

abstract class ClockEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitializeEvent extends ClockEvent {}

class AddTimeZoneEvent extends ClockEvent {}

class SaveTimeZoneEvent extends ClockEvent {
  final String location;

  SaveTimeZoneEvent({required this.location});

  @override
  List<Object?> get props => [location];
}

class DeleteTimeZoneEvent extends ClockEvent {
  final String location;

  DeleteTimeZoneEvent({required this.location});

  @override
  List<Object?> get props => [location];
}
