import 'package:app_weather/weather/weather_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final weatherQueryRiverpodProvider =
    StateNotifierProvider<WeatherQueryProvider, StateQueryWeather>((ref) {
  return WeatherQueryProvider();
});

class WeatherQueryProvider extends StateNotifier<StateQueryWeather> {
  WeatherQueryProvider() : super(StateQueryWeather('', 27.61, 53.84));

  Future<void> addCity(String city) async {
    state = StateQueryWeather(city, state.lon, state.lat);
  }

  Future<void> getCurrentLocation() async {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      state =
          StateQueryWeather(state.city, position.longitude, position.latitude);
    }).catchError((e) {
      return(e);
    });
  }

  void mapGetCurrentLocation(lon, lat) {
    state = StateQueryWeather(state.city, lon, lat);
  }
}
