import 'package:flutter_map/flutter_map.dart';

class StateMap {
  String city;
  double zoom;
  double lon;
  double lat;
  MapController mapController;

  StateMap(this.city, this.zoom, this.lon, this.lat, this.mapController);
}
