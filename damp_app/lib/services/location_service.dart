
import 'package:geolocator/geolocator.dart';
import '../models/camp.dart';

class LocationService {
  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  static bool isWithinSafeZone(Position position, List<Camp> camps, double safeDistanceMeters) {
    for (var camp in camps) {
      double distance = _calculateDistance(position.latitude, position.longitude, camp.latitude, camp.longitude);
      if (distance <= safeDistanceMeters) {
        return true;
      }
    }
    return false;
  }

  static double _calculateDistance(lat1, lon1, lat2, lon2) {
    const p = 0.017453292519943295; // pi/180
    final a = 0.5 - (cos((lat2 - lat1) * p) / 2) + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000; // Distance in meters
  }
}
