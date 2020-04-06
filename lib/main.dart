import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/bloc.dart';
import 'package:flutterbloc/models/weather.dart';
import 'package:shimmer/shimmer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  WeatherPage({Key key}) : super(key: key);

  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final weatherBloc = WeatherBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fake Weather App"),
      ),
      body: BlocProvider(
        bloc: weatherBloc,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: BlocListener(
            bloc: weatherBloc,
            listener: (context, WeatherState state){
              if(state is WeatherLoaded){
                print('${state.weather.cityName}');
              }
            },
            child: BlocBuilder(bloc: weatherBloc, builder: (BuildContext context,WeatherState state){
              if(state is WeatherInitialState){
                return buildInitialInput();
              }else if (state is WeatherLoading){
                return buildLoading();
              }else if(state is WeatherLoaded){
                return buildColumnWithData(state.weather);
              }else {
                return Scaffold();
              }
            }),
          ),
        ),
      ),
    );
  }
  Widget buildInitialInput(){
    return CityInputField();
  }

  Widget buildLoading(){
    return ShimmerEffect();
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "${weather.cityName}",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "${weather.temperature.toStringAsFixed(1)}°C",
            style: TextStyle(fontSize: 80),
          ),
          CityInputField(),
        ],
      );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    weatherBloc.dispose();
  }
}

class CityInputField extends StatefulWidget {
  const CityInputField({
    Key key,
  }) : super(key: key);

  @override
  _CityInputFieldState createState() => _CityInputFieldState();
}

class _CityInputFieldState extends State<CityInputField> {
  TextEditingController cityNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        controller: cityNameController,
        onSubmitted: submitCityName,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: GestureDetector(child: Icon(Icons.search),
            onTap: (){
            if(cityNameController.text != ""){
              submitCityName(cityNameController.text);
            }else{
              print("Fail");
            }
            },
          ),
        ),
      ),
    );
  }

  void submitCityName(String cityName) {
    // We will use the city name to search for the fake forecast
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    if(cityName != ''){
      weatherBloc.dispatch(GetWeather(cityName));
    }else{
      print("fail");
    }
  }
}

class ShimmerEffect extends StatefulWidget {
  @override
  _ShimmerEffectState createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(padding:const EdgeInsets.all(15.0),
            child:Shimmer.fromColors(
              baseColor: Colors.grey[400],
              highlightColor: Colors.white,
              period: Duration(seconds: 2),
              child: Container(
                margin: EdgeInsets.symmetric(vertical:4),
                child: Center(
                  child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 30.0,
                              width: 280.0,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              height: 40.0,
                              width: 280.0,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              height: 20.0,
                              width: 160.0,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                ),
        ),
            ) ,
        ),
      );

  }
}
