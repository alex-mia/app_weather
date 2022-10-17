import 'dart:async';

import 'package:app_weather/api/hourluWeatherApiProvider.dart';
import 'package:app_weather/api/weatherApiProvider.dart';
import 'package:app_weather/delegates/searchDelegate.dart';
import 'package:app_weather/weather/queryWeatherProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Weather extends ConsumerWidget {
  Weather({Key? key}) : super(key: key);

  Future<void> addCity(WidgetRef ref, cityName) async {
    ref.read(weatherQueryRiverpodProvider.notifier).addCity(cityName);
  }

  Future<void> getCurrentWeather(WidgetRef ref, city, lat, lon) async {
    ref
        .read(weatherApiRiverpodProvider.notifier)
        .getCurrentWeather(city, lat, lon);
  }

  Future<void> getCurrentLocation(WidgetRef ref) async {
    ref.read(weatherQueryRiverpodProvider.notifier).getCurrentLocation();
  }

  Future<void> getHorluWeather(WidgetRef ref, city, lat, lon) async {
    ref
        .read(HorluWeatherApiRiverpodProvider.notifier)
        .getHorluWeather(city, lat, lon);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.zoom_out_map_sharp,
              color: Colors.black,
            ),
            onPressed: () {
              Timer(Duration(seconds: 3), () {
                getHorluWeather(
                    ref,
                    ref.watch(weatherQueryRiverpodProvider).city,
                    ref.watch(weatherQueryRiverpodProvider).lat,
                    ref.watch(weatherQueryRiverpodProvider).lon);
                getCurrentWeather(
                    ref,
                    ref.watch(weatherQueryRiverpodProvider).city,
                    ref.watch(weatherQueryRiverpodProvider).lat,
                    ref.watch(weatherQueryRiverpodProvider).lon);
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.gps_fixed,
              color: Colors.black,
            ),
            onPressed: () {
              getCurrentLocation(ref);
              Timer(Duration(seconds: 2), () {
                getHorluWeather(
                    ref,
                    ref.watch(weatherQueryRiverpodProvider).city,
                    ref.watch(weatherQueryRiverpodProvider).lat,
                    ref.watch(weatherQueryRiverpodProvider).lon);
                getCurrentWeather(
                    ref,
                    ref.watch(weatherQueryRiverpodProvider).city,
                    ref.watch(weatherQueryRiverpodProvider).lat,
                    ref.watch(weatherQueryRiverpodProvider).lon);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(
                  (query) {
                    addCity(ref, query);
                    getHorluWeather(
                        ref,
                        ref.watch(weatherQueryRiverpodProvider).city,
                        ref.watch(weatherQueryRiverpodProvider).lat,
                        ref.watch(weatherQueryRiverpodProvider).lon);
                    getCurrentWeather(
                        ref,
                        ref.watch(weatherQueryRiverpodProvider).city,
                        ref.watch(weatherQueryRiverpodProvider).lat,
                        ref.watch(weatherQueryRiverpodProvider).lon);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${ref.watch(weatherApiRiverpodProvider).cityName}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                )),
            Text('${ref.watch(weatherApiRiverpodProvider).description}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                )),
            Text('${ref.watch(weatherApiRiverpodProvider).time}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: Column(
                    children: [
                      Image.asset('images/sunrise.png'),
                      Text('${ref.watch(weatherApiRiverpodProvider).sunrise}'),
                    ],
                  ),
                ),
                Image.network(
                    "http://openweathermap.org/img/wn/${ref.watch(weatherApiRiverpodProvider).iconCode}@2x.png"),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Column(
                    children: [
                      Image.asset('images/sunset.png'),
                      Text('${ref.watch(weatherApiRiverpodProvider).sunset}'),
                    ],
                  ),
                ),
              ],
            ),
            Text('${ref.watch(weatherApiRiverpodProvider).temperature}°',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                )),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                width: 520,
                height: 230,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        ref.watch(HorluWeatherApiRiverpodProvider).length,
                    itemBuilder: (context, i) {
                      return Card(
                        color: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 20.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(10)),
                            side: BorderSide(width: 1, color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              Text(
                                '${ref.watch(HorluWeatherApiRiverpodProvider)[i].time}',
                                maxLines: 10,
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                  '${ref.watch(HorluWeatherApiRiverpodProvider)[i].description}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  )),
                              Image.network(
                                  "http://openweathermap.org/img/wn/${ref.watch(HorluWeatherApiRiverpodProvider)[i].iconCode}@2x.png"),
                              Text(
                                '${ref.watch(HorluWeatherApiRiverpodProvider)[i].temperature}°',
                                style: TextStyle(fontSize: 35),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: Row(
                children: [
                  Image.asset('images/pressure.png'),
                  Text('  pressure - 776'),
                  SizedBox(width: 50,),
                  Image.asset('images/humidity.png'),
                  Text('  humidity - 67'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
