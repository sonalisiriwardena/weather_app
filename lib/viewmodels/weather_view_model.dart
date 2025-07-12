import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import 'dart:convert';

class WeatherViewModel with ChangeNotifier {
  Weather? weather;
  List<Weather> fiveDayForecast = [];
  bool isLoading = false;
  bool isCelsius = true;

  List<Weather> favoriteCities = [];

  WeatherViewModel() {
    loadUnit();
    loadFavorites();
  }

  /// Load temperature unit preference
  Future<void> loadUnit() async {
    final prefs = await SharedPreferences.getInstance();
    isCelsius = prefs.getBool('isCelsius') ?? true;
    notifyListeners();
  }

  /// Set temperature unit preference and save
  Future<void> setUnit(bool celsius) async {
    isCelsius = celsius;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCelsius', isCelsius);
    notifyListeners();
  }

  /// Search city weather and forecast
  Future<void> searchCity(String city) async {
    isLoading = true;
    notifyListeners();

    weather = await WeatherService().fetchWeather(city, isCelsius);
    if (weather != null) {
      fiveDayForecast = await WeatherService().fetchFiveDayForecast(city, isCelsius);
    } else {
      fiveDayForecast = [];
    }

    isLoading = false;
    notifyListeners();
  }

  /// Load favorites from storage
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesString = prefs.getString('favorites');
    if (favoritesString != null) {
      final List decoded = jsonDecode(favoritesString);
      favoriteCities = decoded.map((e) => Weather.fromJson(e)).toList();
      notifyListeners();
    }
  }

  /// Save favorites to storage
  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List encoded = favoriteCities.map((w) => {
      'name': w.cityName,
      'main': {
        'temp': w.temperature,
        'humidity': w.humidity,
        'pressure': w.pressure,
      },
      'weather': [
        {'description': w.description}
      ],
      'wind': {'speed': w.windSpeed},
    }).toList();
    await prefs.setString('favorites', jsonEncode(encoded));
  }

  /// Add city to favorites
  Future<void> addFavorite(Weather city) async {
    if (!favoriteCities.any((w) => w.cityName == city.cityName)) {
      favoriteCities.add(city);
      await saveFavorites();
      notifyListeners();
    }
  }

  /// Remove city from favorites
  Future<void> removeFavorite(Weather city) async {
    favoriteCities.removeWhere((w) => w.cityName == city.cityName);
    await saveFavorites();
    notifyListeners();
  }

  /// Check if a city is in favorites
  bool isFavorite(String cityName) {
    return favoriteCities.any((w) => w.cityName == cityName);
  }

  /// Sort by name
  void sortByName() {
    favoriteCities.sort((a, b) => a.cityName.compareTo(b.cityName));
    notifyListeners();
  }

  /// Sort by temperature
  void sortByTemperature() {
    favoriteCities.sort((a, b) => a.temperature.compareTo(b.temperature));
    notifyListeners();
  }
}