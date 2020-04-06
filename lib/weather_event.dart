import 'package:equatable/equatable.dart';
import 'package:flutterbloc/bloc.dart';

abstract class WeatherEvent extends Equatable {
   WeatherEvent([List properties = const[]]):super(properties);
}

class GetWeather extends WeatherEvent{
  final String cityName;
  GetWeather(this.cityName):super([cityName]);
}
