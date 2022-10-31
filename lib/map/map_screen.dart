import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:app_weather/api/hourly_weather_api_provider.dart';
import 'package:app_weather/api/weather_api_provider.dart';
import 'package:app_weather/background/text_color_provider.dart';
import 'package:app_weather/map/map_api_provider.dart';
import 'package:app_weather/map/map_point_provider.dart';
import 'package:app_weather/background/images_weather_provider.dart';
import 'package:app_weather/weather/query_weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

// set an initial location of the Map
  CameraPosition _initialCameraPosition =
      CameraPosition(target: LatLng(20.5937, 78.9629));

  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pointMapRiverpodProvider);
    ref.read(mapApiRiverpodProvider);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.orange],
            ),
          ),
        ),
        leading: IconButton(
          highlightColor: Colors.red,
          splashRadius: 20,
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/weather');
          },
        ),
        automaticallyImplyLeading: false,
        title: Text('${ref.watch(mapApiRiverpodProvider).cityName}'),
        backgroundColor: Colors.white70,
        actions: <Widget>[
          IconButton(
              highlightColor: Colors.red,
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
                Timer(Duration(seconds: 2), () {
                  getMapCurrentWeather(ref);
                  getMapHorluWeather(ref);
                });
                Timer(Duration(seconds: 3), () {
                  imagesSetting(ref);
                  textColorSetting(ref);
                });
                Navigator.pushNamed(context, '/weather');
              }),
        ],
      ),
      body:
          GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.terrain,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController c) {
                // to control the camera position of the map
                googleMapController = c;
              },
              onTap: (point) {
                getPointLocation(ref, point.longitude, point.latitude);
                getCurrentWeathers(ref);
              },
              markers: {
                Marker(
                  markerId: MarkerId('1 point'),
                  position: LatLng(ref.watch(pointMapRiverpodProvider).lat,
                      ref.watch(pointMapRiverpodProvider).lon),
                  infoWindow: InfoWindow(
                      title:
                          '${ref.watch(mapApiRiverpodProvider).cityName}  ${ref.watch(mapApiRiverpodProvider).temperature}°'),
                ),
              }),
    );
  }
}
