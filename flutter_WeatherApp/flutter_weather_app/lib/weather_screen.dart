import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'weather_data.dart';
import 'location.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  late WeatherFactory ws;
  WeatherData? weatherData;
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    ws = WeatherFactory('d04e7442dc771d7e95cca6ef829e50d5',
        language: Language.ENGLISH);
    getCurrentLocationWS();
  }

  Future<void> getCurrentLocationWS() async {
    currentPosition = await Location.getCurrentLocation();
    if (currentPosition != null) {
      await getWeatherData();
    }
  }

  Future<void> getWeatherData() async {
    Weather weather = await ws.currentWeatherByLocation(
      currentPosition!.latitude,
      currentPosition!.longitude,
    );
    setState(() {
      double temperature = weather.temperature?.celsius ?? 0.0;
      weatherData = WeatherData(
        cityName: weather.areaName ?? 'Unknown',
        temperature: temperature,
        description: weather.weatherDescription ?? 'Unknown',
      );
    });
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  IconData getWeatherIcon(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return Icons.wb_sunny;
      case 'few clouds':
        return Icons.cloud;
      case 'scattered clouds':
      case 'broken clouds':
        return Icons.cloud_queue;
      case 'shower rain':
      case 'rain':
      case 'light rain':
        return Icons.cloudy_snowing;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
        return Icons.blur_on;
      default:
        return Icons.cloud;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Center(
        child: weatherData != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    getWeatherIcon(weatherData!.description),
                    size: 60,
                  ),
                  Text(
                    weatherData!.cityName,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    '${weatherData!.temperature.round()}°C',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    weatherData!.description,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    formatDate(DateTime.now()),
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
            child: const Icon(Icons.info),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/forecast');
            },
            child: const Icon(Icons.calendar_today),
          ),
        ],
      ),
    );
  }
}
