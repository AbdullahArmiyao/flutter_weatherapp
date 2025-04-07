// To convert from longitude and latitude to human readable addresses
import 'package:geocoding/geocoding.dart';

Future<String> getLocationName(double lat, double lon) async {
  // This gets the name of the location of the given longitude and latitude
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
  return placemarks.first.locality ?? 'Unknown';
}
