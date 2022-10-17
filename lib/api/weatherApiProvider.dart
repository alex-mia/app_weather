import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_weather/api/weatherApi.dart';
import 'package:http/http.dart' as http;

final weatherApiRiverpodProvider =
    StateNotifierProvider<WeatherApiProvider, WeatherApi>((ref) {
  return WeatherApiProvider();
});

class WeatherApiProvider extends StateNotifier<WeatherApi> {
  WeatherApiProvider()
      : super(WeatherApi(
            cityName: 'City',
            temperature: 0,
            iconCode: "04d",
            description: '',
            time: '',
            sunrise: '8:24',
            sunset: '21:20'));

  String _apiKey = "c782c3ac53aa5dc240fefa3b359fd5b2";

  Future<WeatherApi> getCurrentWeather(
      String city, double lat, double lon) async {
    var url = Uri.http('api.openweathermap.org', '/data/2.5/weather', {
      'q': '$city',
      'lat': '$lat',
      'lon': '$lon',
      'appid': '${_apiKey}',
      'units': 'metric'
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('$url');

      state = WeatherApi.fromJson(json.decode(response.body));
      return WeatherApi.fromJson(json.decode(response.body));
    } else {
      throw ('Failed to load weather');
    }
  }
}
