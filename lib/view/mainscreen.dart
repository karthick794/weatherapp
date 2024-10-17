import 'package:flutter/material.dart';
import 'package:weatherapp/view/news_screen.dart';
import 'package:weatherapp/view/weather_home_screen.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // First widget at the top (taking half of the screen height)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 2,  // Half the screen height
            child: Container(
              child: Center(child: WeatherHomeScreen()),
            ),
          ),

          // Second widget at the bottom (taking half of the screen height)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height / 2,  // Half the screen height
            child: Container(
              child: Center(child: NewsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
