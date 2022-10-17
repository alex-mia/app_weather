import 'package:intl/intl.dart';

class WeatherApi {
  String? cityName;
  int? temperature;
  String? iconCode;
  String? description;
  String? time;
  String? sunrise;
  String? sunset;

  WeatherApi(
      {this.cityName,
        this.temperature,
        this.iconCode,
        this.description,
        this.time,
        this.sunrise,
        this.sunset,
      }
      );

  factory WeatherApi.fromJson(Map<String, dynamic> json) {
    return WeatherApi(
        cityName: json['name'],
        temperature: double.parse(json['main']['temp'].toString()).toInt(),
        iconCode: json['weather'][0]['icon'],
        description: json['weather'][0]['main'],
        time: DateFormat('d/M/y \n  hh:mm:ss').format(
        DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      ),
      sunrise:  DateFormat('H:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),),
        sunset:  DateFormat('H:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),),
    );
  }
}