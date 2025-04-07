//  This is for making HTTP requests
import 'package:http/http.dart' as http;
// For data encoding and decoding, we import this function...since we are using
// JSON for APIs
import 'dart:convert';

class WeatherService {
  //  Create a function to fetch the weather of the location
  // Thanks to the convert import, this function is converted to JSON strings
  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    // We're using this API
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true';
    // Now, we use a GET request to obtain the API values
    final response = await http.get(Uri.parse(url));
    // Now we convert our response into a JSON format
    return json.decode(response.body)['current_weather'];
  }
}
