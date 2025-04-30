import 'package:flutter/material.dart';
import '../models/weather_model.dart';

/// A rounded search bar
class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSubmitted;
  const CustomSearchBar({
    Key? key,
    required this.controller,
    required this.onSubmitted,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        hintText: 'Enter city name',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

/// A card displaying weather information with icon, animations, and extra details
class WeatherCard extends StatefulWidget {
  final Weather weather;
  const WeatherCard({Key? key, required this.weather}) : super(key: key);
  @override
  _WeatherCardState createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weather = widget.weather;
    return FadeTransition(
      opacity: _fadeIn,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                weather.cityName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      // Background Color
                      Container(
                        width: 64, // Adjust size as needed
                        height: 64, // Adjust size as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color:
                              Colors
                                  .grey
                                  .shade300, // Choose your background color
                        ),
                      ),
                      // Network Image
                      Positioned(
                        top: 0,
                        left: 0,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Image.network(
                            weather.getIconUrl(),
                            width: 64,
                            height: 64,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${weather.temperature.toStringAsFixed(1)} °C',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                weather.description.capitalize(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Divider(height: 32, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _DetailTile(
                    icon: Icons.opacity,
                    label: '${weather.humidity}% Humidity',
                  ),
                  _DetailTile(
                    icon: Icons.air,
                    label: '${weather.windSpeed.toStringAsFixed(1)} m/s Wind',
                  ),
                  _DetailTile(
                    icon: Icons.water_drop,
                    label:
                        '${(weather.temperature - 0.5).toStringAsFixed(1)}° Feels like',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DetailTile({Key? key, required this.icon, required this.label})
    : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Icon(icon, size: 24, color: Colors.grey[700]),
      const SizedBox(height: 4),
      Text(label, style: Theme.of(context).textTheme.bodySmall),
    ],
  );
}

// String extension to capitalize first letter
extension StringCasingExtension on String {
  String capitalize() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
