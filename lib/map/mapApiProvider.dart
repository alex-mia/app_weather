import 'dart:convert';
import 'package:app_weather/map/mapPointProvider.dart';
import 'package:app_weather/map/mapWeatherState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final mapApiRiverpodProvider =
    StateNotifierProvider<MapApiProvider, MapWeatherApi>((ref) {
  ref.read(pointMapRiverpodProvider);
  return MapApiProvider(ref);
});

class MapApiProvider extends StateNotifier<MapWeatherApi> {
  MapApiProvider(this.ref)
      : super(MapWeatherApi(
          cityName: 'Сhoose a city!',
          temperature: '',
        ));

  String _apiKey = "c782c3ac53aa5dc240fefa3b359fd5b2";
  final Ref ref;

  Future<MapWeatherApi> getCurrentWeathers() async {
    var url = Uri.http('api.openweathermap.org', '/data/2.5/weather', {
      'q': '${ref.watch(pointMapRiverpodProvider).city}',
      'lat': '${ref.watch(pointMapRiverpodProvider).lat}',
      'lon': '${ref.watch(pointMapRiverpodProvider).lon}',
      'appid': '$_apiKey',
      'units': 'metric'
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      state = MapWeatherApi.fromJson(json.decode(response.body));
      return MapWeatherApi.fromJson(json.decode(response.body));
    } else {
      throw ('Failed to load weather');
    }
  }
}
