import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteController extends GetxController {
  Rx<LatLng?> pickupLocation = Rx<LatLng?>(null);
  Rx<LatLng?> dropoffLocation = Rx<LatLng?>(null);

  void setPickupLocation(LatLng location) {
    pickupLocation.value = location;
  }

  void setDropoffLocation(LatLng location) {
    dropoffLocation.value = location;
  }
}
