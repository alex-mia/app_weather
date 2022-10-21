import 'dart:async';

import 'package:app_weather/api/hourluWeatherApiProvider.dart';
import 'package:app_weather/api/weatherApiProvider.dart';
import 'package:app_weather/map/mapApiProvider.dart';
import 'package:app_weather/map/mapPointProvider.dart';
import 'package:app_weather/weather/imagesWeatherProvider.dart';
import 'package:app_weather/weather/queryWeatherProvider.dart';
import 'package:app_weather/weather/text%D0%A1olorProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends ConsumerWidget {
  MapScreen({Key? key}) : super(key: key);

  void getPointLocation(WidgetRef ref, lon, lat) {
    ref.read(pointMapRiverpodProvider.notifier).getPointLocation(lon, lat);
  }

  void getCurrentLocation(WidgetRef ref) {
    ref.read(pointMapRiverpodProvider.notifier).getCurrentLocation();
  }

  void getCurrentWeathers(WidgetRef ref) {
    ref.read(mapApiRiverpodProvider.notifier).getCurrentWeathers();
  }

  void plusZoom(WidgetRef ref) {
    ref.read(pointMapRiverpodProvider.notifier).plusZoom();
  }

  void minusZoom(WidgetRef ref) {
    ref.read(pointMapRiverpodProvider.notifier).minusZoom();
  }

  void controllerMap(WidgetRef ref) {
    ref.read(pointMapRiverpodProvider.notifier).controllerMap();
  }

  void mapGetCurrentLocation(WidgetRef ref, lon, lat) {
    ref
        .read(weatherQueryRiverpodProvider.notifier)
        .mapGetCurrentLocation(lon, lat);
  }

  Future<void> getMapHorluWeather(WidgetRef ref) async {
    ref.read(horluWeatherApiRiverpodProvider.notifier).getMapHorluWeather();
  }

  Future<void> getMapCurrentWeather(WidgetRef ref) async {
    ref.read(weatherApiRiverpodProvider.notifier).getMapCurrentWeather();
  }

  Future<void> imagesSetting(WidgetRef ref) async {
    ref.read(imagesWeatherRiverpodProvider.notifier).imagesSetting();
  }

  Future<void> textColorSetting(WidgetRef ref) async {
    ref.read(textColorRiverpodProvider.notifier).textColorSetting();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pointMapRiverpodProvider);
    ref.read(mapApiRiverpodProvider);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.red, Colors.orange],
            ),
          ),
        ),
        leading: IconButton(
          highlightColor: Colors.purpleAccent,
          splashRadius: 20,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        automaticallyImplyLeading: false,
        title: Text('${ref.watch(mapApiRiverpodProvider).cityName}'),
        backgroundColor: Colors.white70,
        actions: <Widget>[
          IconButton(
              highlightColor: Colors.purpleAccent,
              splashRadius: 20,
              icon: Icon(
                Icons.find_in_page_sharp,
                color: Colors.black,
              ),
              onPressed: () {
                mapGetCurrentLocation(
                    ref,
                    ref.read(pointMapRiverpodProvider).lon,
                    ref.read(pointMapRiverpodProvider).lat);
                Timer(
                Duration(seconds: 2),
                 () {
                  getMapCurrentWeather(ref);
                  getMapHorluWeather(ref);
                 });
                Timer(Duration(seconds: 3), () {
                  imagesSetting(ref);
                  textColorSetting(ref);
                });
                Navigator.pushNamed(context, '/');
              }),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: ref.watch(pointMapRiverpodProvider).mapController,
            options: MapOptions(
              onTap: (tapPosition, point) {
                getPointLocation(ref, point.longitude, point.latitude);
                getCurrentWeathers(ref);
              },
              center: LatLng(ref.read(pointMapRiverpodProvider).lat,
                  ref.read(pointMapRiverpodProvider).lon),
              zoom: ref.read(pointMapRiverpodProvider).zoom,
              minZoom: 3.0,
              maxZoom: 12.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 100.0,
                    height: 100.0,
                    point: LatLng(ref.read(pointMapRiverpodProvider).lat,
                        ref.read(pointMapRiverpodProvider).lon),
                    builder: (ctx) => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${ref.watch(mapApiRiverpodProvider).temperature}',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 2),
                        Container(
                          child: Image.asset('images/location.png'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 230, right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.add, size: 40),
                  color: Colors.deepOrange,
                  onPressed: () {
                    plusZoom(ref);
                    controllerMap(ref);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 290, right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.minimize, size: 40),
                  color: Colors.deepOrange,
                  onPressed: () {
                    minusZoom(ref);
                    controllerMap(ref);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
