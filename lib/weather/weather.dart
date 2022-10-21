import 'dart:async';

import 'package:app_weather/api/hourluWeatherApiProvider.dart';
import 'package:app_weather/api/weatherApiProvider.dart';
import 'package:app_weather/delegates/searchDelegate.dart';
import 'package:app_weather/weather/imagesWeatherProvider.dart';
import 'package:app_weather/weather/queryWeatherProvider.dart';
import 'package:app_weather/weather/text%D0%A1olorProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Weather extends ConsumerWidget {
  Weather({Key? key}) : super(key: key);

  Future<void> addCity(WidgetRef ref, cityName) async {
    ref.read(weatherQueryRiverpodProvider.notifier).addCity(cityName);
  }

  Future<void> getCurrentWeather(WidgetRef ref) async {
    ref.read(weatherApiRiverpodProvider.notifier).getCurrentWeather();
  }

  Future<void> getCurrentLocation(WidgetRef ref) async {
    ref.read(weatherQueryRiverpodProvider.notifier).getCurrentLocation();
  }

  Future<void> getHorluWeather(WidgetRef ref) async {
    ref.read(horluWeatherApiRiverpodProvider.notifier).getHorluWeather();
  }

  Future<void> imagesSetting(WidgetRef ref) async {
    ref.read(imagesWeatherRiverpodProvider.notifier).imagesSetting();
  }

  Future<void> textColorSetting(WidgetRef ref) async {
    ref.read(textColorRiverpodProvider.notifier).textColorSetting();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(weatherApiRiverpodProvider).cityName;
    ref.read(weatherQueryRiverpodProvider).lon;
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
                Navigator.pushNamed(context, '/map');
                Timer(
                  Duration(seconds: 3),
                  () {
                    getCurrentWeather(
                      ref,
                    );
                  },
                );
              }),
          IconButton(
              icon: Icon(
                Icons.gps_fixed,
                color: Colors.black,
              ),
              onPressed: () {
                getCurrentLocation(ref);
                Timer(
                  Duration(seconds: 3),
                  () {
                    getHorluWeather(
                      ref,
                    );
                    getCurrentWeather(
                      ref,
                    );
                    Timer(Duration(seconds: 1), () {
                      imagesSetting(ref);
                      textColorSetting(ref);
                    });
                  },
                );
              }),
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
                    );
                    getCurrentWeather(
                      ref,
                    );
                    Timer(Duration(seconds: 1), () {
                      imagesSetting(ref);
                      textColorSetting(ref);
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 10),
              child: Text('${ref.watch(weatherApiRiverpodProvider).cityName}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  )),
            ),
            Text('${ref.watch(weatherApiRiverpodProvider).time}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                )),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Text(
                  '${ref.watch(weatherApiRiverpodProvider).description}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ),
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
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                width: 390,
                height: 235,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        ref.watch(horluWeatherApiRiverpodProvider).length,
                    itemBuilder: (context, i) {
                      ref.watch(imagesWeatherRiverpodProvider);
                      return Card(
                        color: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 5.0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              topRight: Radius.circular(10)),
                          side: BorderSide(width: 1, color: Colors.black),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(10)),
                            image: DecorationImage(
                              image: AssetImage(
                                  '${ref.read(imagesWeatherRiverpodProvider)[i]}'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${ref.watch(horluWeatherApiRiverpodProvider)[i].time}',
                                  maxLines: 10,
                                  style: TextStyle(
                                      color: ref
                                          .read(textColorRiverpodProvider)[i],
                                      fontSize: 20),
                                ),
                              ),
                              Text(
                                  '${ref.watch(horluWeatherApiRiverpodProvider)[i].description}',
                                  style: TextStyle(
                                      color: ref
                                          .read(textColorRiverpodProvider)[i],
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Image.network(
                                  "http://openweathermap.org/img/wn/${ref.watch(horluWeatherApiRiverpodProvider)[i].iconCode}@2x.png"),
                              Text(
                                '${ref.watch(horluWeatherApiRiverpodProvider)[i].temperature}°',
                                style: TextStyle(
                                    color:
                                        ref.read(textColorRiverpodProvider)[i],
                                    fontSize: 35),
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
                  Text(
                    '  pressure - ${ref.watch(weatherApiRiverpodProvider).pressure}',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Image.asset('images/humidity.png'),
                  Text(
                    '  humidity - ${ref.watch(weatherApiRiverpodProvider).humidity}%',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                  ),
                  Image.asset('images/speed.png'),
                  Text(
                    '  speed wind - ${ref.watch(weatherApiRiverpodProvider).speedwind} m/sec',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
