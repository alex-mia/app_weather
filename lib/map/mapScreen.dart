import 'dart:async';

import 'package:app_weather/api/hourluWeatherApiProvider.dart';
import 'package:app_weather/api/weatherApiProvider.dart';
import 'package:app_weather/map/mapApiProvider.dart';
import 'package:app_weather/map/mapPointProvider.dart';
import 'package:app_weather/weather/imagesWeatherProvider.dart';
import 'package:app_weather/weather/queryWeatherProvider.dart';
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

  Future<void> getHorluWeather(WidgetRef ref) async {
    ref.read(horluWeatherApiRiverpodProvider.notifier).getHorluWeather();
  }

  Future<void> getCurrentWeather(WidgetRef ref) async {
    ref.read(weatherApiRiverpodProvider.notifier).getCurrentWeather();
  }

  Future<void> imagesSetting(WidgetRef ref) async {
    ref.read(imagesWeatherRiverpodProvider.notifier).imagesSetting();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pointMapRiverpodProvider);
    ref.read(mapApiRiverpodProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
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
              icon: Icon(
                Icons.find_in_page_sharp,
                color: Colors.black,
              ),
              onPressed: () {
                mapGetCurrentLocation(
                    ref,
                    ref.read(pointMapRiverpodProvider).lon,
                    ref.read(pointMapRiverpodProvider).lat);
                getCurrentWeather(ref);
                getHorluWeather(ref);
                Timer(Duration(seconds: 1), () {
                  imagesSetting(ref);
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
                  icon: const Icon(Icons.add),
                  color: Colors.black,
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
                  icon: const Icon(Icons.minimize),
                  color: Colors.black,
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
