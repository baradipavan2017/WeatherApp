import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/WeatherRepo.dart';
import 'package:weather_app/weathermodel.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherRepo weatherRepo;
  // WeatherBloc(this.weatherRepo);
  //initial state of application
  WeatherBloc(this.weatherRepo) : super(WeatherIsNotSearched());

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    // implement mapEventToState
    if (event is FetchWeather) {
      yield WeatherIsLoading();
      try {
        WeatherModel weather = await weatherRepo.getWeather(event._city);
        yield WeatherIsLoaded(weather);
      } catch (_) {
        yield WeatherIsNotLoaded();
      }
    } else if (event is ResetWeather) {
      yield WeatherIsNotSearched();
    }
  }
}
