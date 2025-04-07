import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/screens/login_screen.dart';
import 'package:weatherapp/services/auth_service.dart';
import '../services/weather_service.dart';
import '../utils/location_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // So basically Map is like a tuple with the first value being a string  in
  // our project and the second being of any data type since it is dynamic
  // and is usually used for api calls
  // Difference between Map and tuple is, Map is an unordered key-value pair
  Map<String, dynamic>? weather;
  String locationName = 'Loading...';

  // It is used to perform initialization tasks before the widget's build method
  // is executed. This is basically where all asynchronus operations are
  // performed
  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  // Function to load the weather
  Future<void> loadWeather() async {
    try {
      // First we request for the user's permission to access the location
      LocationPermission permission = await Geolocator.requestPermission();
      // If the permission is granted, get the location using the longitude and
      // latitude, then get the weather of the same location
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final pos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        final location = await getLocationName(pos.latitude, pos.longitude);
        final data =
            await WeatherService().getWeather(pos.latitude, pos.longitude);

        // display the weather and location
        setState(() {
          weather = data;
          locationName = location;
        });
      } else {
        // If permission is denied, simply say permission denied
        setState(() {
          locationName = 'Location permission denied';
        });
      }
    } catch (e) {
      String err = "An error occured: $e";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather')),
      body: Center(
        // check if the weather data is null and if not, display the information
        child: weather == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(locationName, style: TextStyle(fontSize: 24)),
                  SizedBox(height: 10),
                  Text('${weather!['temperature']}°C',
                      style: TextStyle(fontSize: 48)),
                  Text('Wind: ${weather!['windspeed']} km/h'),
                ],
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              activeIcon: Icon(Icons.home)),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout_sharp),
            label: 'Sign Out',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            AuthService().signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          }
        },
      ),
    );
  }
}
