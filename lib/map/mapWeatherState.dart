import 'package:intl/intl.dart';

class MapWeatherApi {
  String? cityName;
  String? temperature;

  MapWeatherApi({
    this.cityName,
    this.temperature,
  });

  factory MapWeatherApi.fromJson(Map<String, dynamic> json) {
    return MapWeatherApi(
      cityName: json['name'],
      temperature: json['main']['temp'].toString(),
    );
  }
}
