import 'package:flutter/material.dart';
import 'about_screen.dart';
import 'weather_screen.dart';
import 'forecast_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'weather',
      routes: {
        'weather': (context) => const WeatherScreen(),
        '/about': (context) => const AboutScreen(),
        '/forecast': (context) => const ForecastScreen(),
      },
    );
  }
}
