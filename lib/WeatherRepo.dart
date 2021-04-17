import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather_app/weathermodel.dart';

class WeatherRepo {
  Future<WeatherModel> getWeather(String city) async {
    final result = await http.Client().get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=9f12d4f84f2a6290ebe096c0bd4f47e1",
      ),
    );

    if (result.statusCode != 200) throw Exception();

    return parsedJson(result.body);
  }

  WeatherModel parsedJson(final resposnse) {
    final jsonDecoded = json.decode(resposnse);
    final jsonWeather = jsonDecoded['main'];
    return WeatherModel.fromJson(jsonWeather);
  }
}
