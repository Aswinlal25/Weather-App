
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/utils/colors/colors.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String apiKey = 'bd5e378503939ddaee76f12ad7a97608';
  String city = 'Montreal';
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeatherData('india');
  }

  void fetchWeatherData(String city) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF34495E),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(205, 38, 17, 85),
              Colors.black,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.back,
                        color: white,
                      )),
                  const Text(
                    'Weather',
                    style: TextStyle(
                        color: white,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1),
                  ),
                ],
              ),
              SearchBar(onSubmitted: (value) {
                setState(() {
                  fetchWeatherData(value);
                });
              }),
              weatherData == null
                  ? CircularProgressIndicator()
                  : WeatherCard(
                      temperature: weatherData!['main']['temp'].toInt(),
                      high: weatherData!['main']['temp_max'].toInt(),
                      low: weatherData!['main']['temp_min'].toInt(),
                      city: weatherData!['name'],
                      icon: Icons.wb_sunny,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final Function(String) onSubmitted;
  final TextEditingController _controller = TextEditingController();

  SearchBar({required this.onSubmitted});

  String getCity() {
    return _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        height: 40,
        child: TextField(
          controller: _controller,
          onSubmitted: (value) {
            onSubmitted(value);
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            hintText: 'Search for a city',
            hintStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.search, color: Colors.white70),
            filled: true,
            fillColor: Color.fromARGB(255, 19, 26, 33),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class WeatherCard extends StatelessWidget {
  final int temperature;
  final int high;
  final int low;
  final String city;
  final IconData icon;

  WeatherCard({
    required this.temperature,
    required this.high,
    required this.low,
    required this.city,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E44AD), Color(0xFF2980B9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$temperature°',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'H:$high° L:$low°',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 5),
                Text(
                  city,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
            Spacer(),
            Icon(icon, color: Colors.white, size: 50),
          ],
        ),
      ),
    );
  }
}
