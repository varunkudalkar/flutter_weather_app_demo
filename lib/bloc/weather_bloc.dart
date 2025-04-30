import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/data_service.dart';
import '../models/weather_model.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
  @override
  List<Object> get props => [];
}

class FetchWeather extends WeatherEvent {
  final String city;
  const FetchWeather(this.city);
  @override
  List<Object> get props => [city];
}

abstract class WeatherState extends Equatable {
  const WeatherState();
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  const WeatherLoaded(this.weather);
  @override
  List<Object?> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;
  const WeatherError(this.message);
  @override
  List<Object?> get props => [message];
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final DataService dataService;
  WeatherBloc(this.dataService) : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeather event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());
    try {
      final weather = await dataService.fetchWeather(event.city);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError('Could not fetch weather for "${event.city}"'));
    }
  }
}
