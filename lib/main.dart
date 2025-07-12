import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import ' views/home_screen.dart';
import 'views/home_screen.dart';
import 'viewmodels/weather_view_model.dart';
import 'viewmodels/theme_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: const WeatherApp(),
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = Provider.of<ThemeViewModel>(context);

    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        brightness: themeVM.isDarkMode ? Brightness.dark : Brightness.light,
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
