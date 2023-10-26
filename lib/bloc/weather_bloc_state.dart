import 'package:equatable/equatable.dart';
import 'package:weather/weather.dart';

sealed class WeatherBlocState extends Equatable {
  const WeatherBlocState();

  @override
  List<Object> get props => [];
}

final class WeatherBlocInitial extends WeatherBlocState {}

final class WeatherBlocLoading extends WeatherBlocState {}

final class WeatherBlocFailure extends WeatherBlocState {}

final class WeatherBlocSuccessful extends WeatherBlocState {
  final Weather weather;

  const WeatherBlocSuccessful(this.weather);

  @override
  List<Object> get props => [weather];
}
