import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/screens/login_screen.dart';
import 'package:weatherapp/services/auth_service.dart';
import 'package:gif/gif.dart';
import '../services/weather_service.dart';
import '../utils/location_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final GifController _controller;
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
    _controller = GifController(vsync: this);
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
    IconData getWeatherIcon(int condition) {
      if (condition == 0 || condition == 1) {
        return Icons.wb_sunny;
      } else if (condition == 2) {
        return Icons.wb_cloudy_outlined;
      } else if (condition == 3) {
        return Icons.wb_cloudy;
      } else if (condition == 45 || condition == 48) {
        return Icons.foggy;
      } else if (condition == 51 || condition == 53 || condition == 55) {
        return Icons.grain;
      } else if (condition == 61 || condition == 63 || condition == 65) {
        return Icons.umbrella;
      } else if (condition == 66 || condition == 67) {
        return Icons.ac_unit;
      } else if (condition == 80 || condition == 81 || condition == 82) {
        return Icons.grain;
      } else if (condition == 95) {
        return Icons.thunderstorm;
      } else if (condition == 96 || condition == 99) {
        return Icons.flash_on;
      }

      return Icons.help_outline;
    }

    String getDayTime(int dayTime) {
      if (dayTime == 0) {
        return "Nighttime";
      } else if (dayTime == 1) {
        return "Daytime";
      }
      return "Couldn't get day value";
    }

    String getWeatherCondition(int condition) {
      if (condition == 0) {
        return "Clear sky";
      } else if (condition == 1) {
        return "Mainly clear";
      } else if (condition == 2) {
        return "Partly cloudy";
      } else if (condition == 3) {
        return "Overcast";
      } else if (condition == 45 || condition == 48) {
        return "Foggy";
      } else if (condition == 51 || condition == 53 || condition == 55) {
        return "Drizzle";
      } else if (condition == 61 || condition == 63 || condition == 65) {
        return "Rain";
      } else if (condition == 66 || condition == 67) {
        return "Freezing rain";
      } else if (condition == 71 || condition == 73 || condition == 75) {
        return "Snowfall";
      } else if (condition == 77) {
        return "Snow grains";
      } else if (condition == 80 || condition == 81 || condition == 82) {
        return "Rain showers";
      } else if (condition == 85 || condition == 86) {
        return "Snow showers";
      } else if (condition == 95) {
        return "Thunderstorm";
      } else if (condition == 96 || condition == 99) {
        return "Thunderstorm with hail";
      }
      return "Couldn't identify weather condition";
    }

    String wallpaperPath() {
      try {
        if (weather == null) {
          return "";
        }
        if (weather!['is_day'] == 0) {
          return "assets/gif3.gif";
        } else if (weather!['is_day'] == 1) {
          return "assets/gif4.gif";
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
      return "";
    }

    Widget getCurrentWallpaper(String wallpaper) {
      if (wallpaper == "assets/gif4.gif") {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              getWeatherIcon(weather!['weathercode']),
              size: 48,
              color: Colors.black,
            ),
            Text(locationName,
                style: TextStyle(color: Colors.black, fontSize: 24)),
            SizedBox(height: 10),
            Text(getDayTime(weather!['is_day']),
                style: TextStyle(color: Colors.black)),
            Text('${weather!['temperature']}°C',
                style: TextStyle(color: Colors.black, fontSize: 48)),
            Text(getWeatherCondition(weather!['weathercode']),
                style: TextStyle(color: Colors.black)),
            SizedBox(
              height: 20,
            ),
            Text(
              'Wind Speed: ${weather!['windspeed']} km/h',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Wind direction: ${weather!['winddirection']}',
                style: TextStyle(color: Colors.black)),
          ],
        );
      } else if (wallpaper == "assets/gif3.gif") {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              getWeatherIcon(weather!['temperature']),
              size: 48,
              color: Colors.white,
            ),
            Text(locationName,
                style: TextStyle(color: Colors.white, fontSize: 24)),
            SizedBox(height: 10),
            Text(getDayTime(weather!['is_day']),
                style: TextStyle(color: Colors.white)),
            Text('${weather!['temperature']}°C',
                style: TextStyle(color: Colors.white, fontSize: 48)),
            Text(getWeatherCondition(weather!['weathercode']),
                style: TextStyle(color: Colors.white)),
            SizedBox(
              height: 20,
            ),
            Text(
              'Wind Speed: ${weather!['windspeed']} km/h',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Wind direction: ${weather!['winddirection']}',
                style: TextStyle(color: Colors.white)),
          ],
        );
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            getWeatherIcon(weather!['temperature']),
            size: 48,
            color: Colors.white,
          ),
          Text(locationName,
              style: TextStyle(color: Colors.white, fontSize: 24)),
          SizedBox(height: 10),
          Text(getDayTime(weather!['is_day']),
              style: TextStyle(color: Colors.white)),
          Text('${weather!['temperature']}°C',
              style: TextStyle(color: Colors.white, fontSize: 48)),
          Text(getWeatherCondition(weather!['weathercode']),
              style: TextStyle(color: Colors.white)),
          SizedBox(
            height: 20,
          ),
          Text(
            'Wind Speed: ${weather!['windspeed']} km/h',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text('Wind direction: ${weather!['winddirection']}',
              style: TextStyle(color: Colors.white)),
        ],
      );
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Weather',
      //     textAlign: TextAlign.center,
      //   ),
        // backgroundColor: Colors.transparent, elevation: 0,
      // ),
      body: RefreshIndicator(
        onRefresh: loadWeather,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Gif(
                      image: AssetImage(wallpaperPath()),
                      controller: _controller,
                      // fps: 30
                      // duration: const Duration(seconds: 5)
                      autostart: Autostart.loop,
                      placeholder: (context) => const Text("Loading..."),
                      onFetchCompleted: () => {
                        if (mounted)
                          {
                            _controller.reset(),
                            _controller.forward(),
                          }
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                      // check if the weather data is null and if not, display the information
                      child: weather == null
                          ? CircularProgressIndicator(
                              color: Colors.black,
                            )
                          : getCurrentWallpaper(wallpaperPath())),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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
          if (index == 0) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else if (index == 1) {
            AuthService().signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          }
        },
        // backgroundColor: Colors.transparent, elevation: 0,
      ),
    );
  }
}
