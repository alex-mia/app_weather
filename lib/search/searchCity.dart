import 'dart:async';

import 'package:app_weather/api/hourly_weather_api_provider.dart';
import 'package:app_weather/api/weather_api_provider.dart';
import 'package:app_weather/background/images_weather_provider.dart';
import 'package:app_weather/background/text_color_provider.dart';
import 'package:app_weather/weather/query_weather_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchCity extends ConsumerWidget {
  SearchCity({Key? key}) : super(key: key);

  addCity(WidgetRef ref, cityName) {
    ref.read(weatherQueryRiverpodProvider.notifier).addCity(cityName);
  }

  Future<void> getHorluWeather(WidgetRef ref) async {
    ref.read(horluWeatherApiRiverpodProvider.notifier).getHorluWeather();
  }

  Future<void> getCurrentWeather(WidgetRef ref) async {
    ref.read(weatherApiRiverpodProvider.notifier).getCurrentWeather();
  }

  Future<void> imagesSetting(WidgetRef ref) async {
    ref.read(imagesWeatherRiverpodProvider.notifier).imagesSetting();
  }

  Future<void> textColorSetting(WidgetRef ref) async {
    ref.read(textColorRiverpodProvider.notifier).textColorSetting();
  }

  TextEditingController editingController = TextEditingController();
  List<String> cityName = [
    'Minsk',
    'Moscow',
    'Kiev',
    'St. Petersburg',
    'Astana',
    'Tbilisi'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('City'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onSubmitted: (value) {
                  addCity(ref, value);
                  Timer(Duration(seconds: 2), () {
                    getCurrentWeather(ref);
                    getHorluWeather(ref);
                  });
                  Timer(Duration(seconds: 3), () {
                    imagesSetting(ref);
                    textColorSetting(ref);
                  });
                  Navigator.pushNamed(context, '/weather');
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "City",
                    hintText: "Search",
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.red,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Container(
              height: 450,
              width: 300,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(8),
                  itemCount: cityName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        addCity(ref, cityName[index]);
                        Timer(Duration(seconds: 2), () {
                          getCurrentWeather(ref);
                          getHorluWeather(ref);
                        });
                        Timer(Duration(seconds: 3), () {
                          imagesSetting(ref);
                          textColorSetting(ref);
                        });
                        Navigator.pushNamed(context, '/weather');
                      },
                      title: Text(
                        cityName[index],
                        style: TextStyle(fontSize: 22),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
