class Weather {
  final String cityName;
  final double temperature;
  final double windSpeed;
  final int humidity;
  final int pressure;
  final String description;
  final DateTime? dateTime;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
    required this.description,
    this.dateTime,
  });

  /// ✅ For current weather endpoint
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
      description: json['weather'][0]['description'],
      dateTime: json['dt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000)
          : null,
    );
  }

  /// ✅ For 5-day forecast list items
  factory Weather.fromForecastJson(Map<String, dynamic> json) {
    return Weather(
      cityName: '', // Forecast list items don’t have city name
      temperature: (json['main']['temp'] as num).toDouble(),
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
      description: json['weather'][0]['description'],
      dateTime: json['dt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000)
          : null,
    );
  }
}
