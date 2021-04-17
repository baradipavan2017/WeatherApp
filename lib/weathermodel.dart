//API = "https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=43ea6baaad7663dc17637e22ee6f78f2"
//

import 'package:flutter/foundation.dart';

class WeatherModel {
  final temp;
  final pressure;
  final humidity;
  final tempmax;
  final tempmin;

  double get getTemp => temp - 272.5;
  double get getMaxTemp => tempmax - 272.5;
  double get getMinTemp => tempmin - 272.5;

  WeatherModel({
    @required this.temp,
    @required this.pressure,
    @required this.humidity,
    @required this.tempmax,
    @required this.tempmin,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temp: json['temp'],
      pressure: json['pressure'],
      humidity: json['humidity'],
      tempmax: json['temp_max'],
      tempmin: json['temp_min'],
    );
  }
}
