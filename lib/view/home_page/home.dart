import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/utils/colors/colors.dart';
import 'package:weather_app/view/detail_page/details.dart';
import 'package:weather_app/view/search_page/search.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String apiKey = 'bd5e378503939ddaee76f12ad7a97608';
  Map<String, dynamic>? weatherData;
  double latitude = 35.0;
  double longitude = 139.0;

  @override
  void initState() {
    super.initState();
    fetchWeatherDataByLocation();
  }

  //Get current location
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('location service is disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('location permission is denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('location permission is denied permanently');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> fetchWeatherDataByLocation() async {
    getCurrentPosition().then((value) async {
      latitude = value.latitude;
      longitude = value.longitude;
    });

    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');

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
    final screensize = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: bgcolor,
      body: Column(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 701,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/bg image.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    color: bgcolor,
                    height: screensize.height * 0.16,
                  )
                ],
              ),
              Positioned(
                left: 130,
                top: 110,
                child: Column(
                  children: [
                    Text(
                      weatherData!['name'] ?? '',
                      style: const TextStyle(
                          color: white,
                          fontSize: 30,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1),
                    ),
                    Text(
                      weatherData!['main']['temp'].toString(),
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
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: InkWell(
                    child: ClipRRect(
                      child: SizedBox(
                        width: double.infinity,
                        height: screensize.height * 0.38,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            tileMode: TileMode.clamp,
                            sigmaX: 15.0,
                            sigmaY: 10.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white12),
                              color: const Color.fromARGB(255, 239, 239, 239)
                                  .withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Hourly forecast',
                                      style: TextStyle(
                                          color: fwhite, fontSize: 12),
                                    ),
                                    SizedBox(
                                      width: 190,
                                    ),
                                    Text(
                                      'Weekly forecast',
                                      style: TextStyle(
                                          color: fwhite, fontSize: 12),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 140,
                                        width: 400,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: 10,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.all(0),
                                              child: Container(
                                                width: 60,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Colors.white10,
                                                  border:
                                                      Border.all(color: white),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 2,
                                                      blurRadius: 7,
                                                      offset:
                                                          const Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.location_on,
                                          color: white,
                                        )),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const WeatherScreen()));
                                      },
                                      child: const CircleAvatar(
                                        radius: 30,
                                        backgroundColor: white,
                                        child: Icon(
                                          Icons.add,
                                          color: black,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      WeatherDetailScreen(
                                                        city: weatherData![
                                                            'name'],
                                                        temp:
                                                            weatherData!['main']
                                                                    ['temp']
                                                                .toString(),
                                                        latitude: latitude,
                                                        longitude: longitude,
                                                      )));
                                        },
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: white,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
