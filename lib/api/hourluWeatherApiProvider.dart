import 'dart:convert';
import 'package:app_weather/api/hourlyWeatherApi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_weather/api/weatherApi.dart';
import 'package:http/http.dart' as http;

final HorluWeatherApiRiverpodProvider =
    StateNotifierProvider<HorluWeatherApiProvider, List<WeatherApiHourly>>(
        (ref) {
  return HorluWeatherApiProvider();
});

class HorluWeatherApiProvider extends StateNotifier<List<WeatherApiHourly>> {
  HorluWeatherApiProvider() : super([]);

  String _apiKey = "c782c3ac53aa5dc240fefa3b359fd5b2";

  Future<List<WeatherApiHourly>> getHorluWeather(
      String city, double lat, double lon) async {
    var url = Uri.http('api.openweathermap.org', '/data/2.5/forecast', {
      'q': '$city',
      'lat': '$lat',
      'lon': '$lon',
      'appid': '${_apiKey}',
      'units': 'metric'
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      print('$url');
      final jsonData = json.decode(response.body);
      final List<WeatherApiHourly> data =
          (jsonData['list'] as List<dynamic>).map((item) {
        return WeatherApiHourly.fromJson(item);
      }).toList();
      state = data;
      return data;
    } else {
      throw ('Failed to load weather');
    }
  }
}
