import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrafficLight {
  final String id;
  final LatLng position;
  final String locationName;
  final Map<String, String> directions;
  Map<String, String> directionStatuses;
  Map<String, int> secondsLeft;

  var status;

  TrafficLight({
    required this.id,
    required this.position,
    required this.locationName,
    required this.directions,
    required this.directionStatuses,
    required this.secondsLeft,
  });
}
