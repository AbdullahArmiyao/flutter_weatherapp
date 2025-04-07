import 'package:geocoding/geocoding.dart';

Future<String> getLocationName(double lat, double lon) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
  return placemarks.first.locality ?? 'Unknown';
}
