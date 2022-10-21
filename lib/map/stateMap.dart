import 'package:flutter_map/flutter_map.dart';

class StateMap {
  double zoom;
  double lon;
  double lat;
  MapController mapController;

  StateMap(this.zoom, this.lon, this.lat, this.mapController);
}
