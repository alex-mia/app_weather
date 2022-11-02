// @dart=2.9
import 'package:app_weather/map/map_screen.dart';
import 'package:app_weather/search/searchCity.dart';
import 'package:app_weather/start_screen.dart';
import 'package:app_weather/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main()  {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weather',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        initialRoute: '/',
        routes: {
          '/':(BuildContext context) => StartScreen(),
          '/weather':(BuildContext context) => Weather(),
          '/map':(BuildContext context) => MapScreen(),
          '/search':(BuildContext context) => SearchCity(),
        }
      // home: Add_new_todo(),
    );
  }
}