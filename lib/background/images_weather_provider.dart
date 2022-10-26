import 'dart:async';
import 'package:app_weather/api/hourly_weather_api_provider.dart';
import 'package:app_weather/api/weather_api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imagesWeatherRiverpodProvider =
    StateNotifierProvider<ImagesWeatherProvider, List<String>>((ref) {
  ref.read(weatherApiRiverpodProvider);
  return ImagesWeatherProvider(ref);
});
List<String> weatherHorlu = List.generate(40, (i) => 'images/background.jpg');
List<String> iconWeatherHorlu = List.generate(40, (i) => 'images/background.jpg');

class ImagesWeatherProvider extends StateNotifier<List<String>> {
  ImagesWeatherProvider(this.ref) : super(weatherHorlu);
  final Ref ref;

  Future<void> imagesSetting() async {
    int index = 0;
    while (index <= 39) {
      String weather =
          '${ref.watch(horluWeatherApiRiverpodProvider)[index].description}';
      String timeWeather =
          '${ref.watch(horluWeatherApiRiverpodProvider)[index].time}';
      if (weather == 'Clouds') {
        weatherHorlu[index] = 'images/cloud.jpg';
      }
      if (weather == 'Clear') {
        weatherHorlu[index] = 'images/clear.jpg';
      }
      if (weather == 'Rain') {
        weatherHorlu[index] = 'images/rain.jpg';
      }
      if (weather == 'Snow') {
        weatherHorlu[index] = 'images/snow.jpg';
      }
      if (timeWeather.contains('18:00') == true) {
        weatherHorlu[index] = 'images/night.jpg';
      }
      if (timeWeather.contains('21:00') == true) {
        weatherHorlu[index] = 'images/night.jpg';
      }
      if (timeWeather.contains('0:00') == true) {
        weatherHorlu[index] = 'images/night.jpg';
      }
      if (timeWeather.contains('3:00') == true) {
        weatherHorlu[index] = 'images/night.jpg';
      }
      index += 1;
    }
    state = weatherHorlu;
  }
}
