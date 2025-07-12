import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weather_view_model.dart';
import '../viewmodels/theme_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherVM = Provider.of<WeatherViewModel>(context);
    final themeVM = Provider.of<ThemeViewModel>(context);

    return Scaffold(
      backgroundColor: themeVM.isDarkMode ? null : const Color(0xFFADD8E6),
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'Settings',
          style: TextStyle(
            color: themeVM.isDarkMode ? Colors.white : Colors.blue[900]!,
          ),
        ),
        iconTheme: IconThemeData(
          color: themeVM.isDarkMode ? Colors.white : Colors.blue[900]!,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text(
                'Temperature Unit (°C / °F)',
                style: TextStyle(
                  color: themeVM.isDarkMode ? Colors.white : Colors.blue[900]!,
                ),
              ),
              subtitle: Text(
                weatherVM.isCelsius ? 'Celsius' : 'Fahrenheit',
                style: TextStyle(
                  color: themeVM.isDarkMode ? Colors.white : Colors.blue[900]!,
                ),
              ),
              value: weatherVM.isCelsius,
              onChanged: (value) async {
                weatherVM.setUnit(value);
              },
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  color: themeVM.isDarkMode ? Colors.white : Colors.blue[900]!,
                ),
              ),
              value: themeVM.isDarkMode,
              onChanged: (value) {
                themeVM.toggleTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
