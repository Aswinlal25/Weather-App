import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherApiClient {
  final String apiKey;

  WeatherApiClient({required this.apiKey});

  //Get current location
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('location service is disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('location permission is denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('location permission is denied permanently');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, dynamic>> fetchWeatherDataByLocation() async {
    Position position = await getCurrentPosition();
    double latitude = position.latitude;
    double longitude = position.longitude;

    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
