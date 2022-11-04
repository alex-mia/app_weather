import 'dart:convert';
import 'package:app_weather/map/map_point_provider.dart';
import 'package:app_weather/weather/query_weather_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_weather/api/weather_api.dart';
import 'package:http/http.dart' as http;

final weatherApiRiverpodProvider =
    StateNotifierProvider<WeatherApiProvider, WeatherApi>((ref) {
  ref.read(weatherQueryRiverpodProvider);
  return WeatherApiProvider(ref);
});

class WeatherApiProvider extends StateNotifier<WeatherApi> {
  WeatherApiProvider(this.ref)
      : super(WeatherApi(
          cityName: 'Choose a city!',
          temperature: 0,
          iconCode: "04d",
          description: '',
          time: '',
          sunrise: '00:00',
          sunset: '00:00',
          pressure: '0',
          humidity: '0',
          speedwind: '0',
        ));

  String _apiKey = "c782c3ac53aa5dc240fefa3b359fd5b2";
  final Ref ref;

  Future<WeatherApi> getCurrentWeather() async {
    var url = Uri.http('api.openweathermap.org', '/data/2.5/weather', {
      'q': '${ref.watch(weatherQueryRiverpodProvider).city}',
      'lat': '${ref.watch(weatherQueryRiverpodProvider).lat}',
      'lon': '${ref.watch(weatherQueryRiverpodProvider).lon}',
      'appid': '$_apiKey',
      'units': 'metric'
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      state = WeatherApi.fromJson(json.decode(response.body));
      return WeatherApi.fromJson(json.decode(response.body));
    } else {
      throw ('Failed to load weather');
    }
  }

  Future<WeatherApi> getMapCurrentWeather() async {
    var url = Uri.http('api.openweathermap.org', '/data/2.5/weather', {
      'q': '${ref.watch(pointMapRiverpodProvider).city}',
      'lat': '${ref.watch(pointMapRiverpodProvider).lat}',
      'lon': '${ref.watch(pointMapRiverpodProvider).lon}',
      'appid': '$_apiKey',
      'units': 'metric'
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      state = WeatherApi.fromJson(json.decode(response.body));
      return WeatherApi.fromJson(json.decode(response.body));
    } else {
          throw ('Failed to load weather');
    }
  }
}
