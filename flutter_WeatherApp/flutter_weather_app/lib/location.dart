import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Location {
  static Future<Position?> getCurrentLocation() async {
    final status = await Permission.location.request();
    print('Location permission status: $status');
    if (status.isGranted) {
      try {
        final currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        );
        print('Current position: $currentPosition');
        return currentPosition;
      } catch (e) {
        print('Error getting location: $e');
      }
    } else if (status.isDenied) {
    } else if (status.isPermanentlyDenied) {}
    return null;
  }
}
