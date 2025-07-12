import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weather_view_model.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherVM = Provider.of<WeatherViewModel>(context);
    final weather = weatherVM.weather;

    if (weather == null) {
      return const Scaffold(
        body: Center(child: Text('No weather data available')),
      );
    }

    final unit = weatherVM.isCelsius ? '°C' : '°F';
    final isFavorite = weatherVM.favoriteCities
        .any((w) => w.cityName.toLowerCase() == weather.cityName.toLowerCase());

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.blue[900]!; // If you still use blue[900]

    return Scaffold(
      backgroundColor: isDark ? null : const Color(0xFFADD8E6), // ✅ Safe sky blue
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'Weather Details',
          style: TextStyle(color: textColor),
        ),
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : textColor,
            ),
            onPressed: () async {
              if (isFavorite) {
                await weatherVM.removeFavorite(weather);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Removed from favorites')),
                );
              } else {
                await weatherVM.addFavorite(weather);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to favorites')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                weather.cityName,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('🌡 Temperature: ${weather.temperature}$unit',
                style: textStyle(textColor)),
            Text('🌬 Wind Speed: ${weather.windSpeed} m/s',
                style: textStyle(textColor)),
            Text('💧 Humidity: ${weather.humidity}%',
                style: textStyle(textColor)),
            Text('📈 Pressure: ${weather.pressure} hPa',
                style: textStyle(textColor)),
            Text('📝 Description: ${weather.description}',
                style: textStyle(textColor)),
          ],
        ),
      ),
    );
  }

  TextStyle textStyle(Color color) => TextStyle(
    fontSize: 18,
    color: color,
  );
}
