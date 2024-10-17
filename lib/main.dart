import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/view/mainscreen.dart';
import 'package:weatherapp/view/news_screen.dart';
import 'package:weatherapp/view/weather_home_screen.dart';
import 'package:weatherapp/view_model/weather_news_viewmodel.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WeatherNewsViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
     debugShowCheckedModeBanner: false,
      home: Mainscreen() ,
    );
  }
}

