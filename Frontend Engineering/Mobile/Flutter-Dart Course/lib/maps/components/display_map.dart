import 'package:flutter/material.dart';
import 'package:flutter_course/maps/components/use_current_location.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

class DisplayMap extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng dropoffLocation;

  const DisplayMap({
    super.key,
    required this.pickupLocation,
    required this.dropoffLocation,
  });

  @override
  State<DisplayMap> createState() => _DisplayMapState();
}

class _DisplayMapState extends State<DisplayMap> {
  late GoogleMapController mapController;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];

  final PolylinePoints _polylinePoints = PolylinePoints();

// Custom Map Style (generated from the Google Maps Styling Wizard)
  final String _mapStyle = '''
  [
    {
      "featureType": "all",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#f1f6f9"
        }
      ]
    },
    {
      "featureType": "all",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#c9d8e4"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#d7e5f0"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#87a2c7"
        }
      ]
    }
  ]
  ''';

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  // Initialize map elements
  Future<void> _initializeMap() async {
    await _setMarkers();
    await _getRoutePolyline();
    _updateCameraPosition();
    _addCurrentLocationMarker();
  }

  void _addCurrentLocationMarker() async {
    loc.Location location = loc.Location();
    loc.LocationData currentLocation = await location.getLocation();
    final userLocation = Get.find<RouteController>().userLocation.value;

    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: userLocation!,
          // LatLng(currentLocation.latitude!, currentLocation.longitude!),
          infoWindow: const InfoWindow(title: 'Your Location'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(currentLocation.latitude!, currentLocation.longitude!),
          15.0,
        ),
      );
    });
  }

  // Set custom markers with addresses
  Future<void> _setMarkers() async {
    BitmapDescriptor pickupIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/l4.png', // Replace with your custom icon path
    );

    BitmapDescriptor dropoffIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/l5.png', // Replace with your custom icon path
    );

    String pickupAddress = await _getAddress(widget.pickupLocation);
    String dropoffAddress = await _getAddress(widget.dropoffLocation);

    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: widget.pickupLocation,
          infoWindow:
              InfoWindow(title: 'Pickup Location', snippet: pickupAddress),
          icon: pickupIcon,
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('dropoff'),
          position: widget.dropoffLocation,
          infoWindow:
              InfoWindow(title: 'Dropoff Location', snippet: dropoffAddress),
          icon: dropoffIcon,
        ),
      );
    });
  }

  Future<void> _getRoutePolyline() async {
    // Create a PolylineRequest object
    PolylineRequest request = PolylineRequest(
      origin: PointLatLng(
          widget.pickupLocation.latitude, widget.pickupLocation.longitude),
      destination: PointLatLng(
          widget.dropoffLocation.latitude, widget.dropoffLocation.longitude),
      mode: TravelMode.driving, // Specify travel mode
    );

    // Fetch the polyline result using the request
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      request: request,
    );

    if (result.points.isNotEmpty) {
      setState(() {
        _polylineCoordinates.clear();
        _polylineCoordinates.addAll(
          result.points.map((point) => LatLng(point.latitude, point.longitude)),
        );
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue,
            width: 5,
            points: _polylineCoordinates,
          ),
        );
      });
    } else {
      print(
          'No route found or error fetching polyline: ${result.errorMessage}');
    }
  }

  // Convert LatLng to address
  Future<String> _getAddress(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return "${placemark.street}, ${placemark.locality}, ${placemark.country}";
      }
      return 'Unknown Address';
    } catch (e) {
      return 'Error retrieving address';
    }
  }

  // Update camera to show both markers
  void _updateCameraPosition() {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        widget.pickupLocation.latitude < widget.dropoffLocation.latitude
            ? widget.pickupLocation.latitude
            : widget.dropoffLocation.latitude,
        widget.pickupLocation.longitude < widget.dropoffLocation.longitude
            ? widget.pickupLocation.longitude
            : widget.dropoffLocation.longitude,
      ),
      northeast: LatLng(
        widget.pickupLocation.latitude > widget.dropoffLocation.latitude
            ? widget.pickupLocation.latitude
            : widget.dropoffLocation.latitude,
        widget.pickupLocation.longitude > widget.dropoffLocation.longitude
            ? widget.pickupLocation.longitude
            : widget.dropoffLocation.longitude,
      ),
    );

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
          mapController.setMapStyle(_mapStyle);
        },
        trafficEnabled: true, // Enable traffic layer
        initialCameraPosition: CameraPosition(
          target: widget.pickupLocation,
          zoom: 12.0,
        ),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true, // Add zoom controls
        tiltGesturesEnabled: true, // Allow map tilting
      ),
    );
  }
}
