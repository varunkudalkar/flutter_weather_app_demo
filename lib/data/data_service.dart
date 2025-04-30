import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class DataService {
  static const _apiKey = 'bbe85394433b42fc357aa539852fc87a';
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> fetchWeather(String city) async {
    final uri = Uri.parse(
      '$_baseUrl/weather?q=$city&units=metric&appid=$_apiKey',
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load weather');
    }

    final json = jsonDecode(response.body);
    return Weather.fromJson(json);
  }
}
