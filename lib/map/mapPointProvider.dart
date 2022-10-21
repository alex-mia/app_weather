import 'package:app_weather/map/stateMap.dart';
import 'package:app_weather/weather/weatherState.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

final pointMapRiverpodProvider =
    StateNotifierProvider<PointMapProvider, StateMap>((ref) {
  return PointMapProvider();
});

MapController mapController = MapController();

class PointMapProvider extends StateNotifier<StateMap> {
  PointMapProvider() : super(StateMap('', 4.0, 27.61, 53.84, mapController));

  void getPointLocation(lon, lat) {
    state = StateMap(state.city, state.zoom, lon, lat, state.mapController);
  }

  Future<void> getCurrentLocation() async {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      state = StateMap(state.city, state.zoom, position.longitude, position.latitude,
          state.mapController);
    }).catchError((e) {
      print(e);
    });
  }

  void plusZoom() {
    double zoom = state.zoom;
    zoom += 1.0;
    state = StateMap(state.city, zoom, state.lon, state.lat, state.mapController);
  }

  void minusZoom() {
    double zoom = state.zoom;
    zoom -= 1.0;
    state = StateMap(state.city, zoom, state.lon, state.lat, state.mapController);
  }

  void controllerMap() {
    LatLng currentCenter = LatLng(state.lat, state.lon);
    double center = state.zoom;
    mapController.move(currentCenter, center);
    state = StateMap(state.city, state.zoom, state.lon, state.lat, mapController);
  }
}
