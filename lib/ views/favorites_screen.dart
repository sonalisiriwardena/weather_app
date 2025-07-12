import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weather_view_model.dart';
import 'details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String sortCriteria = 'name';

  @override
  void initState() {
    super.initState();
    final weatherVM = Provider.of<WeatherViewModel>(context, listen: false);
    weatherVM.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final weatherVM = Provider.of<WeatherViewModel>(context);

    // Reusable text color:
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.blue[900];

    return Scaffold(
      backgroundColor: isDark ? null : Colors.lightBlue[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'Favorite Cities',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: textColor,
          ),
        ),
        iconTheme: IconThemeData(
          color: textColor,
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                sortCriteria = value;
                if (value == 'name') {
                  weatherVM.sortByName();
                } else if (value == 'temperature') {
                  weatherVM.sortByTemperature();
                }
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'name', child: Text('Sort by Name')),
              const PopupMenuItem(
                value: 'temperature',
                child: Text('Sort by Temperature'),
              ),
            ],
            icon: Icon(Icons.sort, color: Colors.red),
          ),
        ],
      ),
      body: weatherVM.favoriteCities.isEmpty
          ? Center(
        child: Text(
          'No favorite cities added.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            color: textColor?.withOpacity(0.7),
          ),
        ),
      )
          : ListView.builder(
        itemCount: weatherVM.favoriteCities.length,
        itemBuilder: (context, index) {
          final city = weatherVM.favoriteCities[index];
          return ListTile(
            title: Text(
              city.cityName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            subtitle: Text(
              '${city.temperature.toStringAsFixed(1)}°C',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                color: textColor?.withOpacity(0.7),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                weatherVM.removeFavorite(city);
              },
            ),
            onTap: () {
              weatherVM.weather = city;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DetailsScreen()),
              );
            },
          );
        },
      ),
    );
  }
}
