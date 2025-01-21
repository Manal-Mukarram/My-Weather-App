import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    String cityName = "London";
    final result = await http.get(
      Uri.parse(
          'http://api.openweathermap.org/data/2.5/weather?q=$cityName&APPID=$openWeatherAPIkey'),
    );
    print(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ***** HEADER *****
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // actions are used for navigation properties such as profile or settings
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh_rounded),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // ***** MAIN CARD *****
            SizedBox(
              width: double.infinity, // to take the complete space on screen
              child: Card(
                elevation: 10,
                child: ClipRRect(
                  // creates 3D effect for the card
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: const Padding(
                      padding:
                          EdgeInsets.fromLTRB(0, 15, 0, 15), // for top-bottom
                      child: Column(
                        children: [
                          Text(
                            '30°C',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Icon(
                            Icons.cloud,
                            size: 65,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('Raining'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ***** SMALL CARDS ******
            Container(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
              alignment: Alignment.bottomLeft,
              child: const Text('Weather Forecast'),
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // ** small cards **
                    SmallCard(
                      time: '3:00',
                      icon: Icons.cloud,
                      temperature: '30°C',
                    ),
                    SmallCard(
                      time: '3:00',
                      icon: Icons.cloud,
                      temperature: '30°C',
                    ),
                    SmallCard(
                      time: '3:00',
                      icon: Icons.cloud,
                      temperature: '30°C',
                    ),
                    SmallCard(
                      time: '3:00',
                      icon: Icons.cloud,
                      temperature: '30°C',
                    ),
                    SmallCard(
                      time: '3:00',
                      icon: Icons.cloud,
                      temperature: '30°C',
                    ),
                    SmallCard(
                      time: '3:00',
                      icon: Icons.cloud,
                      temperature: '30°C',
                    ),
                    SmallCard(
                      time: '3:00',
                      icon: Icons.cloud,
                      temperature: '30°C',
                    ),
                  ],
                ),
              ),
            ),
            // ***** ADDITIONAL INFO *****
            Container(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
              alignment: Alignment.bottomLeft,
              child: const Text('Weather Forecast'),
            ),
            const Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    AdditionalInfoBox(
                        icon: Icons.water_drop_rounded,
                        label: 'Humidity',
                        value: '94'),
                    AdditionalInfoBox(
                        icon: Icons.air_rounded,
                        label: 'Wind Speed',
                        value: '7.67'),
                    AdditionalInfoBox(
                        icon: Icons.speed, label: 'Pressure', value: '1004')
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

// *** WEATHER FORECAST or SMALL CARD CLASS ***

class SmallCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const SmallCard(
      {super.key,
      required this.icon,
      required this.time,
      required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 125,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              temperature,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// *** ADDITIONAL INFO BOX CLASS ***

class AdditionalInfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AdditionalInfoBox(
      {super.key,
      required this.icon,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
          ),
          Text(
            label,
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 25),
          ),
        ],
      ),
    );
  }
}
