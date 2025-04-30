import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_bloc.dart';
import 'custom_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF73AEF5),
              Color(0xFF61A4F1),
              Color(0xFF478DE0),
              Color(0xFF398AE5),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CustomSearchBar(
                  controller: _cityController,
                  onSubmitted:
                      (value) =>
                          context.read<WeatherBloc>().add(FetchWeather(value)),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _buildState(context, state),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildState(BuildContext context, WeatherState state) {
    if (state is WeatherLoading) {
      return const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(color: Colors.white),
      );
    } else if (state is WeatherLoaded) {
      return Center(
        key: const ValueKey('loaded'),
        child: WeatherCard(weather: state.weather),
      );
    } else if (state is WeatherError) {
      return Center(
        key: const ValueKey('error'),
        child: Text(state.message, style: const TextStyle(color: Colors.white)),
      );
    }
    return const Center(
      key: ValueKey('initial'),
      child: Text(
        'Search a city to get weather',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}
