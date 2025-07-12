import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_keys.dart'; // ✅ Imported and will use it
import '../models/weather.dart';

class WeatherService {
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5'; // ✅ Correct base URL

  /// ✅ Fetch current weather
  Future<Weather?> fetchWeather(String city, bool isCelsius) async {
    final unit = isCelsius ? 'metric' : 'imperial';

    final url = Uri.parse(
      '$_baseUrl/weather?q=$city&units=$unit&appid=$OPEN_WEATHER_MAP_API_KEY',
    );

    final response = await http.get(url);

    print('FetchWeather URL: $url');
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      print('Error fetching weather: ${response.statusCode}');
      return null;
    }
  }

  /// ✅ Fetch 5-day forecast
  Future<List<Weather>> fetchFiveDayForecast(String city, bool isCelsius) async {
    final unit = isCelsius ? 'metric' : 'imperial';

    final url = Uri.parse(
      '$_baseUrl/forecast?q=$city&units=$unit&appid=$OPEN_WEATHER_MAP_API_KEY',
    );

    final response = await http.get(url);

    print('FetchForecast URL: $url');
    print('Response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List forecasts = data['list'];

      final List<Weather> filteredForecasts = [];

      for (var entry in forecasts) {
        final dateTime = DateTime.fromMillisecondsSinceEpoch(entry['dt'] * 1000);
        if (dateTime.hour == 12) {
          filteredForecasts.add(Weather.fromForecastJson(entry));
        }
      }

      return filteredForecasts;
    } else {
      print('Error fetching forecast: ${response.statusCode}');
      return [];
    }
  }
}
