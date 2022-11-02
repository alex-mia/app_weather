import 'dart:async';
import 'package:app_weather/api/hourly_weather_api_provider.dart';
import 'package:app_weather/api/weather_api_provider.dart';
import 'package:app_weather/background/background_provider.dart';
import 'package:app_weather/background/images_weather_provider.dart';
import 'package:app_weather/background/text_color_provider.dart';
import 'package:app_weather/weather/query_weather_provider.dart';
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
  final Shader linearGradient = const LinearGradient(
    colors: <Color>[Colors.red, Colors.orange],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 70.0));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(weatherApiRiverpodProvider).cityName;
    ref.read(weatherQueryRiverpodProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 2.0,
                blurRadius: 2.0,
              ),
            ],
            gradient: LinearGradient(
              colors: [Colors.red, Colors.orange],
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
              highlightColor: Colors.red,
              splashRadius: 20,
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
              highlightColor: Colors.red,
              splashRadius: 20,
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
            highlightColor: Colors.red,
            splashRadius: 20,
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');

                    }),
      ],
                ),


      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  '${ref.watch(backgroundRiverpodProvider).image}'),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height - 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(
                    '${ref.watch(weatherApiRiverpodProvider).cityName}',
                    style: new TextStyle(
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            color: ref.watch(backgroundRiverpodProvider).color,
                            offset: Offset(1, 2),
                          ),
                        ],
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()..shader = linearGradient),
                  )),
              Text('${ref.watch(weatherApiRiverpodProvider).time}',
                  style: TextStyle(
                    color: ref.watch(backgroundRiverpodProvider).color,
                    fontSize: 15,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Text(
                    '${ref.watch(weatherApiRiverpodProvider).description}',
                    style: TextStyle(
                        color: ref.watch(backgroundRiverpodProvider).color,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 20),
                child:
                Text('${ref.watch(weatherApiRiverpodProvider).temperature}°',
                    style: TextStyle(
                      color: ref.watch(backgroundRiverpodProvider).color,
                      fontSize: 50,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          spreadRadius: 2.0,
                          blurRadius: 10.0,
                          offset: Offset(3.0, 3.0))
                    ],
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.red],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 50),
                        child: Column(
                          children: [
                            Image.asset('images/sunrise.png'),
                            Text(
                                '${ref.watch(weatherApiRiverpodProvider).sunrise}'),
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
                            Text(
                                '${ref.watch(weatherApiRiverpodProvider).sunset}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: 390,
                height: 235,
                child: ref.watch(horluWeatherApiRiverpodProvider).length == 0 ? Padding(
                  padding: EdgeInsets.only(left: 100, right: 100, top: 25, bottom: 25),
                  child: CircularProgressIndicator(backgroundColor: Colors.orangeAccent,
                    valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
                    strokeWidth: 10.0,
                  ),
                )
               : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                    ref.watch(horluWeatherApiRiverpodProvider).length,
                    itemBuilder: (context, i) {
                      ref.watch(imagesWeatherRiverpodProvider)[i];
                      return Card (
                        color: Colors.black,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              topRight: Radius.circular(10)),
                          side: BorderSide(width: 2, color: Colors.orange),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 2.0,
                                  blurRadius: 2.0,
                                  offset: Offset(3.0, 3.0))
                            ],
                            borderRadius: const BorderRadius.only(
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
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          spreadRadius: 2.0,
                          blurRadius: 10.0,
                          offset: Offset(3.0, 3.0))
                    ],
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.orange],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        Image.asset('images/pressure.png'),
                        Text(
                          '  pressure - ${ref.watch(weatherApiRiverpodProvider).pressure}',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 20,
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 55, right: 55),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black,
                          spreadRadius: 2.0,
                          blurRadius: 10.0,
                          offset: Offset(3.0, 3.0))
                    ],
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.red],
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset('images/speed.png'),
                      ),
                      Text(
                        '  speed wind - ${ref.watch(weatherApiRiverpodProvider).speedwind} m/sec',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}