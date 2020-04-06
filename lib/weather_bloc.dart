import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutterbloc/models/weather.dart';
import './bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  @override
  WeatherState get initialState => WeatherInitialState();

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if(event is GetWeather){
      yield WeatherLoading();
      final weather = await _fetchWaetherFromFakeApi(event.cityName);
      yield WeatherLoaded(weather);
    }
  }

  Future<Weather> _fetchWaetherFromFakeApi(String cityName){
    return Future.delayed(Duration(seconds: 1),(){
      return Weather(cityName: cityName, temperature: 20+Random().nextInt(15)+Random().nextDouble());
    });
  }
}
