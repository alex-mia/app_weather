import 'package:intl/intl.dart';

class WeatherApiHourly {
  String? cityName;
  int? temperature;
  String? iconCode;
  String? description;
  String? time;
  String? sunrise;
  String? sunset;
  String? images;

  WeatherApiHourly({
    this.cityName,
    this.temperature,
    this.iconCode,
    this.description,
    this.time,
  });

  factory WeatherApiHourly.fromJson(Map<String, dynamic> json) {
    return WeatherApiHourly(
      cityName: json['name'],
      temperature: double.parse(json['main']['temp'].toString()).toInt(),
      iconCode: json['weather'][0]['icon'],
      description: json['weather'][0]['main'],
      time: DateFormat('d MMMM \n     H:mm').format(
        DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      ),
    );
  }
}
