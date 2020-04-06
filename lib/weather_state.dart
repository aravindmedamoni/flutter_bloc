import 'package:equatable/equatable.dart';

import 'models/weather.dart';

abstract class WeatherState extends Equatable {
   WeatherState([List properties = const[]]):super([properties]);
}

class WeatherInitialState extends WeatherState {
  @override
  List<Object> get props => [];
}

class WeatherLoading extends WeatherState{}
class WeatherLoaded extends WeatherState{
  final Weather weather;
  WeatherLoaded(this.weather):super([weather]);
}
