import 'dart:ui';

import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

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
                            '30 °C',
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
            const SizedBox(
              height: 30,
            ),
            Placeholder(
              fallbackHeight: 150,
            ),
            SizedBox(
              height: 30,
            ),
            // ***** ADDITIONAL INFO *****
            Placeholder(
              fallbackHeight: 150,
            )
          ],
        ),
      ),
    );
  }
}
