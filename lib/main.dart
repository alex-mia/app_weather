// @dart=2.9
import 'package:app_weather/map/mapScreen.dart';
import 'package:app_weather/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
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
          '/':(BuildContext context) => Weather(),
          '/map':(BuildContext context) => MapScreen(),
        }
      // home: Add_new_todo(),
    );
  }
}