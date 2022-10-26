import 'dart:convert';
import 'package:app_weather/api/hourly_weather_api.dart';
import 'package:app_weather/map/map_point_provider.dart';
import 'package:app_weather/weather/query_weather_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final horluWeatherApiRiverpodProvider =
    StateNotifierProvider<HorluWeatherApiProvider, List<WeatherApiHourly>>(
        (ref) {
  ref.read(weatherQueryRiverpodProvider);
  return HorluWeatherApiProvider(ref);
});

class HorluWeatherApiProvider extends StateNotifier<List<WeatherApiHourly>> {
  HorluWeatherApiProvider(this.ref) : super([]);

  String _apiKey = "c782c3ac53aa5dc240fefa3b359fd5b2";
  final Ref ref;

  Future<List<WeatherApiHourly>> getHorluWeather() async {
    var url = Uri.http('api.openweathermap.org', '/data/2.5/forecast', {
      'q': '${ref.watch(weatherQueryRiverpodProvider).city}',
      'lat': '${ref.watch(weatherQueryRiverpodProvider).lat}',
      'lon': '${ref.watch(weatherQueryRiverpodProvider).lon}',
      'appid': '${_apiKey}',
      'units': 'metric'
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
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

  Future<List<WeatherApiHourly>> getMapHorluWeather() async {
    var url = Uri.http('api.openweathermap.org', '/data/2.5/forecast', {
      'q': '${ref.watch(pointMapRiverpodProvider).city}',
      'lat': '${ref.watch(pointMapRiverpodProvider).lat}',
      'lon': '${ref.watch(pointMapRiverpodProvider).lon}',
      'appid': '${_apiKey}',
      'units': 'metric'
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
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
