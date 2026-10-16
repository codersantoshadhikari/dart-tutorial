// Weather App – Flutter project
// Full explanation and Run in browser: https://flutter.dart-tutorial.dev/projects/weather-app/
// Use as lib/main.dart after: flutter pub add http

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.lightBlue),
      home: const WeatherPage(),
    ));

class Weather {
  const Weather({required this.city, required this.country, required this.temperature, required this.wind, required this.code});
  final String city;
  final String country;
  final double temperature;
  final double wind;
  final int code;

  (String, IconData) get description => switch (code) {
        0 => ('Clear sky', Icons.wb_sunny),
        1 || 2 => ('Partly cloudy', Icons.wb_cloudy),
        3 => ('Cloudy', Icons.cloud),
        45 || 48 => ('Fog', Icons.foggy),
        >= 51 && <= 67 => ('Rain', Icons.umbrella),
        >= 71 && <= 77 => ('Snow', Icons.ac_unit),
        >= 80 && <= 82 => ('Showers', Icons.grain),
        >= 95 => ('Thunderstorm', Icons.thunderstorm),
        _ => ('Unknown', Icons.help_outline),
      };
}

class WeatherApi {
  Future<Weather> fetch(String city) async {
    // 1. Find the city's coordinates
    final geo = await http.get(Uri.https(
      'geocoding-api.open-meteo.com', '/v1/search', {'name': city, 'count': '1'},
    ));
    if (geo.statusCode != 200) throw Exception('Search failed (${geo.statusCode})');
    final results = (jsonDecode(geo.body)['results'] as List?) ?? [];
    if (results.isEmpty) throw Exception('City "$city" not found');
    final place = results.first as Map<String, dynamic>;

    // 2. Get the current weather there
    final res = await http.get(Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${place['latitude']}',
      'longitude': '${place['longitude']}',
      'current': 'temperature_2m,wind_speed_10m,weather_code',
    }));
    if (res.statusCode != 200) throw Exception('Weather failed (${res.statusCode})');
    final current = jsonDecode(res.body)['current'] as Map<String, dynamic>;

    return Weather(
      city: place['name'] as String,
      country: (place['country'] ?? '') as String,
      temperature: (current['temperature_2m'] as num).toDouble(),
      wind: (current['wind_speed_10m'] as num).toDouble(),
      code: (current['weather_code'] as num).toInt(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _api = WeatherApi();
  final _controller = TextEditingController(text: 'Pokhara');
  Future<Weather>? _future;

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final city = _controller.text.trim();
    if (city.isEmpty) return;
    setState(() => _future = _api.fetch(city));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _search(),
            decoration: InputDecoration(
              labelText: 'City',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: _search),
            ),
          ),
          const SizedBox(height: 32),
          FutureBuilder<Weather>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Column(
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    Text('${snapshot.error}'.replaceFirst('Exception: ', ''), textAlign: TextAlign.center),
                    TextButton(onPressed: _search, child: const Text('Try again')),
                  ],
                );
              }
              if (!snapshot.hasData) return const SizedBox.shrink();
              final w = snapshot.data!;
              final (label, icon) = w.description;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      Text('${w.city}, ${w.country}', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Icon(icon, size: 72, color: Colors.orange),
                      Text('${w.temperature.round()}°C', style: Theme.of(context).textTheme.displayMedium),
                      Text(label, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Wind ${w.wind.round()} km/h'),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text('Weather data by Open-Meteo.com', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
