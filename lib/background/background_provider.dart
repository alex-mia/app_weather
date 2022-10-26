
import 'package:app_weather/api/weather_api_provider.dart';
import 'package:app_weather/background/background_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final backgroundRiverpodProvider =
StateNotifierProvider<BackgroundProvider, StateBackground>((ref) {
  ref.read(weatherApiRiverpodProvider);
  return BackgroundProvider(ref);
});

class BackgroundProvider extends StateNotifier<StateBackground> {
  BackgroundProvider(this.ref) : super(StateBackground('images/background_day.jpg', Colors.black));
  final Ref ref;

  void backgroundSetting() {
      if(DateTime.now().hour <= 6){
      String image = 'images/background_night.jpg';
      Color color = Colors.white;
      state = StateBackground(image, color);
      }
      if(DateTime.now().hour >= 18){
        String image = 'images/background_night.jpg';
        Color color = Colors.white;
        state = StateBackground(image, color);
      }
  }

}
