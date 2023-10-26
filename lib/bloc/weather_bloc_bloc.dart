import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/bloc/weather_bloc_event.dart';
import 'package:weather_app/bloc/weather_bloc_state.dart';
import 'package:weather_app/data/my_api_key.dart';

class WeatherBlocBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  WeatherBlocBloc() : super(WeatherBlocInitial()) {
    on<FetchWeather>(
      (event, emit) async {
        emit(
          WeatherBlocLoading(),
        );
        try {
          WeatherFactory wf =
              WeatherFactory(API_KEY, language: Language.ENGLISH);

          Weather weather = await wf.currentWeatherByLocation(
              event.position.latitude, event.position.longitude);
          emit(
            WeatherBlocSuccessful(weather),
          );
        } catch (e) {
          emit(
            WeatherBlocFailure(),
          );
        }
      },
    );
  }
}
