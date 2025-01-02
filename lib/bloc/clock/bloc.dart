import 'package:clock_app/bloc/clock/events.dart';
import 'package:clock_app/bloc/clock/states.dart';
import 'package:clock_app/data/repositories/location_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class ClockBloc extends Bloc<ClockEvent, ClockState> {
  ClockBloc(LocationRepository repository) : super(ClockStart()) {
    on<InitializeEvent>((event, emit) async {
      tz.initializeTimeZones();
      final locations = await repository.getAll();
      emit(
        ClockReady(
          locations: locations.map((l) => tz.getLocation(l.location)).toList(),
        ),
      );
    });
    on<AddTimeZoneEvent>((event, emit) {
      final timezones = tz.timeZoneDatabase.locations;
      emit(TimeZonesReady(timezones: timezones));
    });
    on<SaveTimeZoneEvent>((event, emit) async {
      try {
        emit(Loading<TimeZoneAddedSuccessfully>());
        final location = await repository.insert(event.location);
        emit(
          TimeZoneAddedSuccessfully(
            location: tz.getLocation(location.location),
          ),
        );
      } on Exception catch (e) {
        emit(Error<TimeZoneAddedSuccessfully>(exception: e));
      }
    });
    on<DeleteTimeZoneEvent>((event, emit) async {
      try {
        emit(Loading<TimeZoneDeletedSuccessfully>());
        await repository.delete(event.location);
        emit(TimeZoneDeletedSuccessfully());
      } on Exception catch (e) {
        emit(Error<TimeZoneDeletedSuccessfully>(exception: e));
      }

      add(InitializeEvent());
    });
  }
}
