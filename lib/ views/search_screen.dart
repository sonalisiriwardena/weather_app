import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weather_view_model.dart';
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final weatherVM = Provider.of<WeatherViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? null : Colors.lightBlue[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Search City Here',
          style: TextStyle(color: const Color(0xFF000080)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                labelStyle: TextStyle(
                  color: isDark ? Colors.purple[200] : Colors.purple[800],
                ),
                border: const OutlineInputBorder(),
              ),
              style: TextStyle(
                color: isDark ? Colors.purple[200] : Colors.purple[800],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF000080),
              ),
              onPressed: () async {
                final city = _controller.text.trim();
                if (city.isNotEmpty) {
                  await weatherVM.searchCity(city);

                  if (weatherVM.weather != null) {
                    await weatherVM.addFavorite(weatherVM.weather!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('City added to favorites')),
                    );

                    // Navigate to DetailsScreen to show weather details
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const DetailsScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('City not found')),
                    );
                  }
                }
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
