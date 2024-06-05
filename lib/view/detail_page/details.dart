import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors/colors.dart';
import 'package:http/http.dart' as http;

class WeatherDetailScreen extends StatefulWidget {
  final String city;
  final String temp;
  final double latitude;
  final double longitude;
  const WeatherDetailScreen(
      {super.key,
      required this.city,
      required this.temp,
      required this.latitude,
      required this.longitude});

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  String apiKey = 'bd5e378503939ddaee76f12ad7a97608';

  Map<String, dynamic>? airPollutionData;
  Map<String, dynamic>? weatherAlertsData;
  Map<String, dynamic>? historicalWeatherData;

  @override
  void initState() {
    super.initState();
    fetchAirPollutionData();
    fetchWeatherAlerts();
    fetchHistoricalWeatherData();
  }

  Future<void> fetchAirPollutionData() async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/air_pollution?lat=${widget.latitude}&lon=${widget.longitude} longitude&appid=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        airPollutionData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load air pollution data');
    }
  }

  Future<void> fetchWeatherAlerts() async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall?lat=${widget.latitude}&lon=${widget.longitude}&exclude=current,minutely,hourly,daily&appid=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        weatherAlertsData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load weather alerts data');
    }
  }

  Future<void> fetchHistoricalWeatherData() async {
    final now = DateTime.now();
    final fiveDaysAgo = now.subtract(const Duration(days: 5));
    final unixTimestamp = fiveDaysAgo.millisecondsSinceEpoch ~/ 1000;

    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/onecall/timemachine?lat=${widget.latitude}&lon=${widget.longitude}&dt=$unixTimestamp&appid=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        historicalWeatherData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load historical weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    var boxDecoration = BoxDecoration(
        color: const Color.fromARGB(57, 46, 70, 85),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromARGB(40, 33, 149, 243)));
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(205, 21, 3, 60),
            Colors.black,
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Text(
              widget.city,
              style: const TextStyle(
                  color: white,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1),
            ),
            Text(
              widget.temp,
              style: const TextStyle(
                  color: white,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Mostly Clear',
              style: TextStyle(
                  color: fwhite,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: boxDecoration,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 165,
                          height: 200,
                          decoration: boxDecoration,
                          child: airPollutionData != null
                              ? Text(
                                  'Air Pollution: ${airPollutionData!['list'][0]['main']['aqi']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                )
                              : const Text('Not Available')),
                      Container(
                          width: 165,
                          height: 200,
                          decoration: boxDecoration,
                          child: weatherAlertsData != null
                              ? Text(
                                  'Weather Alerts: ${weatherAlertsData!['alerts'].length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                )
                              : const Text('Not Available')),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 165,
                        height: 200,
                        decoration: boxDecoration,
                      ),
                      Container(
                        width: 165,
                        height: 200,
                        decoration: boxDecoration,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 165,
                        height: 200,
                        decoration: boxDecoration,
                      ),
                      Container(
                        width: 165,
                        height: 200,
                        decoration: boxDecoration,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
