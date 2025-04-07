import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final double temperature;
  final double windSpeed;
  final String location;

  const WeatherCard({
    super.key,
    required this.temperature,
    required this.windSpeed,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(location, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('$temperature°C', style: TextStyle(fontSize: 48)),
            Text('Wind: $windSpeed km/h'),
          ],
        ),
      ),
    );
  }
}
