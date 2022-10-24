
import 'dart:async';

import 'package:app_weather/api/hourluWeatherApiProvider.dart';
import 'package:app_weather/api/weatherApiProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final textColorRiverpodProvider =
StateNotifierProvider<TextColorProvider, List<Color>>((ref) {
  ref.read(weatherApiRiverpodProvider);
  return TextColorProvider(ref);
});
List<Color> textColor = List.generate(40, (i) => Colors.black);

class TextColorProvider extends StateNotifier<List<Color>> {
  TextColorProvider(this.ref) : super(textColor);
  final Ref ref;
  Future<void> textColorSetting() async {
    int index = 0;
      while (index <= 39) {
        String timeWeather = '${ref.watch(horluWeatherApiRiverpodProvider)[index]
            .time}';
        if (timeWeather.contains('18:00') == true){textColor[index] = Colors.white;}
        if (timeWeather.contains('21:00') == true){textColor[index] = Colors.white;}
        if (timeWeather.contains('0:00') == true){textColor[index] = Colors.white;}
        if (timeWeather.contains('3:00') == true){textColor[index] = Colors.white;}
        index += 1;
      }
      state = textColor;
  }
}