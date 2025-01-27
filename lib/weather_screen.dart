import 'dart:convert';
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
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "London";
      final result = await http.get(
        Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIkey&units=metric',
        ),
      );
      final data = jsonDecode(result.body);

      // Check for a successful response
      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      // Ensure that the list is not empty
      if (data['list'] == null || data['list'].isEmpty) {
        throw 'No forecast data available';
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh_rounded),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final data = snapshot.data!;

          final currentTemp = data['list'][0]['main']['temp'];
          final currentTempText = data['list'][0]['weather'][0]['main'];
          final pressure = data['list'][0]['main']['pressure'];
          final humidity = data['list'][0]['main']['humidity'];
          final windSpeed = data['list'][0]['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // ***** MAIN CARD *****
                SizedBox(
                  width:
                      double.infinity, // to take the complete space on screen
                  child: Card(
                    elevation: 10,
                    child: ClipRRect(
                      // creates 3D effect for the card
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              0, 15, 0, 15), // for top-bottom
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp°C',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Icon(
                                currentTempText == 'Clouds' ||
                                        currentTempText == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 65,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text('$currentTempText'),
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
                  child: const Text('Hourly Forecast'),
                ),
                // Align(
                //   alignment: Alignment.bottomLeft,
                //   child: SingleChildScrollView(
                //     scrollDirection: Axis.horizontal,
                //     child: Row(
                //       children: [
                //         // ** small cards **
                //         for (int i = 0; i < 39; i++)
                //           SmallCard(
                //             time: data['list'][i + 1]['dt'].toString(),
                //             icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                         'Clouds' ||
                //                     data['list'][i + 1]['weather'][0]['main'] ==
                //                         'Rain'
                //                 ? Icons.cloud
                //                 : Icons.sunny,
                //             temperature: '30°C',
                //           ),
                //       ],
                //     ),
                //   ),
                // ),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    // ListView is used to improve app performance.  It's useful when dealing with large or dynamic lists of data.
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SmallCard(
                        icon: data['list'][index + 1]['weather'][0]['main'] ==
                                    'Clouds' ||
                                data['list'][index + 1]['weather'][0]['main'] ==
                                    'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                        time: data['list'][index + 1]['dt_txt'].toString(),
                        temperature:
                            data['list'][index + 1]['main']['temp'].toString(),
                      );
                    },
                  ),
                ),

                // ***** ADDITIONAL INFO *****
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
                  alignment: Alignment.bottomLeft,
                  child: const Text('Additional Information'),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      AdditionalInfoBox(
                          icon: Icons.water_drop_rounded,
                          label: 'Humidity',
                          value: '$humidity'),
                      AdditionalInfoBox(
                          icon: Icons.air_rounded,
                          label: 'Wind Speed',
                          value: '$windSpeed'),
                      AdditionalInfoBox(
                          icon: Icons.speed,
                          label: 'Pressure',
                          value: '$pressure')
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// *** HOURLY FORECAST or SMALL CARD CLASS ***

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
              maxLines: 1,
              overflow: TextOverflow
                  .ellipsis, // if text overflows, ... is used to end the text
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


// laptop charger fail