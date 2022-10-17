import 'dart:convert';
import 'package:app_weather/weather/queryWeatherProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_weather/api/weatherApi.dart';
import 'package:http/http.dart' as http;

final weatherApiRiverpodProvider =
    StateNotifierProvider<WeatherApiProvider, WeatherApi>((ref) {
  ref.read(weatherQueryRiverpodProvider);
  return WeatherApiProvider(ref);
});

class WeatherApiProvider extends StateNotifier<WeatherApi> {
  WeatherApiProvider(this.ref)
      : super(WeatherApi(
          cityName: 'City',
          temperature: 0,
          iconCode: "04d",
          description: '',
          time: '',
          sunrise: '8:24',
          sunset: '21:20',
          pressure: '700',
          humidity: '67',
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
}
