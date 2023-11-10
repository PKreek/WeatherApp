import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'location.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  ForecastScreenState createState() => ForecastScreenState();
}

class ForecastScreenState extends State<ForecastScreen> {
  late WeatherFactory ws;
  List<Weather> forecastData = [];
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    ws = WeatherFactory('d04e7442dc771d7e95cca6ef829e50d5',
        language: Language.ENGLISH);
    getCurrentLocationFS();
  }

  Future<void> getCurrentLocationFS() async {
    currentPosition = await Location.getCurrentLocation();
    if (currentPosition != null) {
      await getForecastData();
    }
  }

  Future<void> getForecastData() async {
    forecastData = await ws.fiveDayForecastByLocation(
      currentPosition!.latitude,
      currentPosition!.longitude,
    );
    setState(() {});
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';
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

  Widget buildForecastListItem(Weather forecast) {
    return ListTile(
      leading:
          Icon(getWeatherIcon(forecast.weatherDescription ?? ''), size: 40),
      title: Text('${forecast.temperature?.celsius?.round() ?? 0}°C'),
      subtitle: Text(forecast.weatherDescription ?? 'Unknown'),
      trailing: Text(formatDate(forecast.date)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
      ),
      body: Center(
        child: forecastData.isNotEmpty
            ? ListView.builder(
                itemCount: forecastData.length,
                itemBuilder: (context, index) {
                  return buildForecastListItem(forecastData[index]);
                },
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
