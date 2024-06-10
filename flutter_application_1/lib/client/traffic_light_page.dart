import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/traffic_light_model.dart';
import 'dart:async';

class TrafficLightPage extends StatefulWidget {
  final LatLng origin;
  final LatLng destination;

  TrafficLightPage({required this.origin, required this.destination});

  @override
  _TrafficLightPageState createState() => _TrafficLightPageState();
}

class _TrafficLightPageState extends State<TrafficLightPage> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  // Daftar lokasi lampu merah dari Kiaracondong ke Telkom University
  final List<TrafficLight> trafficLights = [
    TrafficLight(
      id: '1',
      position: LatLng(-6.931806, 107.643194), // Kiaracondong-Gatot Subroto
      locationName: 'Persimpangan Kiaracondong',
      directions: {
        'Arah Flyover Kiaracondong': '3.5 menit',
        'Arah Ibrahim Adjie': '2 menit',
        'Arah Gatot Subroto': '1 menit',
        'Arah Pindad': '1.5 menit',
      },
      directionStatuses: {
        'Arah Flyover Kiaracondong': 'Merah',
        'Arah Ibrahim Adjie': 'Hijau',
        'Arah Gatot Subroto': 'Merah',
        'Arah Pindad': 'Merah',
      },
      secondsLeft: {
        'Arah Flyover Kiaracondong': 210,
        'Arah Ibrahim Adjie': 120,
        'Arah Gatot Subroto': 60,
        'Arah Pindad': 90,
      },
    ),
    TrafficLight(
      id: '2',
      position: LatLng(-6.945398, 107.641889), // Samsat
      locationName: 'Persimpangan Samsat',
      directions: {
        'Arah Buah Batu': '330 detik',
        'Arah Kiaracondong': '2 menit',
        'Arah Pasar Kordon': '1 menit',
        'Arah Soekarno Hatta': '1.5 menit',
      },
      directionStatuses: {
        'Arah Buah Batu': 'Hijau',
        'Arah Kiaracondong': 'Merah',
        'Arah Pasar Kordon': 'Merah',
        'Arah Soekarno Hatta': 'Merah',
      },
      secondsLeft: {
        'Arah Buah Batu': 330,
        'Arah Kiaracondong': 120,
        'Arah Pasar Kordon': 60,
        'Arah Soekarno Hatta': 90,
      },
    ),
    TrafficLight(
      id: '3',
      position: LatLng(-6.947972, 107.633529), // Buah Batu
      locationName: 'Persimpangan Buah Batu',
      directions: {
        'Arah Terusan Buah Batu': '3 menit',
        'Arah Buah Batu': '2 menit',
        'Arah Soekarno Hatta': '1 menit',
        'Arah National': '1.5 menit',
      },
      directionStatuses: {
        'Arah Terusan Buah Batu': 'Merah',
        'Arah Buah Batu': 'Hijau',
        'Arah Soekarno Hatta': 'Merah',
        'Arah National': 'Merah',
      },
      secondsLeft: {
        'Arah Terusan Buah Batu': 180,
        'Arah Buah Batu': 120,
        'Arah Soekarno Hatta': 60,
        'Arah National': 90,
      },
    ),
    TrafficLight(
      id: '4',
      position: LatLng(-6.961888, 107.638611), // Tol Buah Batu
      locationName: 'Tol Buah Batu',
      directions: {
        'Arah Tol Buah Batu': '2 menit',
        'Arah Transmart Buah Batu': '1.5 menit',
        'Arah Terusan Buah Batu': '1 menit',
      },
      directionStatuses: {
        'Arah Tol Buah Batu': 'Hijau',
        'Arah Transmart Buah Batu': 'Merah',
        'Arah Terusan Buah Batu': 'Merah',
      },
      secondsLeft: {
        'Arah Tol Buah Batu': 120,
        'Arah Transmart Buah Batu': 90,
        'Arah Terusan Buah Batu': 60,
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setMarkers();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: LatLng(
          widget.origin.latitude < widget.destination.latitude ? widget.origin.latitude : widget.destination.latitude,
          widget.origin.longitude < widget.destination.longitude ? widget.origin.longitude : widget.destination.longitude,
        ),
        northeast: LatLng(
          widget.origin.latitude > widget.destination.latitude ? widget.origin.latitude : widget.destination.latitude,
          widget.origin.longitude > widget.destination.longitude ? widget.origin.longitude : widget.destination.longitude,
        ),
      ),
      50,
    ));
  }

  void _setMarkers() {
    setState(() {
      for (var trafficLight in trafficLights) {
        _markers.add(
          Marker(
            markerId: MarkerId(trafficLight.id),
            position: trafficLight.position,
            infoWindow: InfoWindow(
              title: 'Lampu Merah - ${trafficLight.status}',
              snippet: '${trafficLight.position.latitude}, ${trafficLight.position.longitude}',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrafficLightDetailPage(
                      trafficLight: trafficLight,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lokasi Lampu Merah'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: widget.origin,
          zoom: 12.0,
        ),
        markers: _markers,
      ),
    );
  }
}

class TrafficLightDetailPage extends StatefulWidget {
  final TrafficLight trafficLight;

  TrafficLightDetailPage({
    required this.trafficLight,
  });

  @override
  _TrafficLightDetailPageState createState() => _TrafficLightDetailPageState();
}

class _TrafficLightDetailPageState extends State<TrafficLightDetailPage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          widget.trafficLight.directions.forEach((direction, duration) {
            if (widget.trafficLight.secondsLeft[direction]! > 0) {
              widget.trafficLight.secondsLeft[direction] = widget.trafficLight.secondsLeft[direction]! - 1;
            } else {
              widget.trafficLight.directionStatuses[direction] = widget.trafficLight.directionStatuses[direction] == 'Merah' ? 'Hijau' : 'Merah';
              widget.trafficLight.secondsLeft[direction] = _parseDuration(duration);
            }
          });
        });
      }
    });
  }

  int _parseDuration(String duration) {
    try {
      if (duration.contains('menit')) {
        final parts = duration.split(' ');
        double minutes = double.parse(parts[0]);
        return (minutes * 60).toInt();
      } else if (duration.contains('detik')) {
        final parts = duration.split(' ');
        return int.parse(parts[0]);
      } else {
        return 0;
      }
    } catch (e) {
      print('Error parsing duration: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Waktu Lampu Merah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.trafficLight.locationName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: widget.trafficLight.directions.length,
                itemBuilder: (context, index) {
                  String direction = widget.trafficLight.directions.keys.elementAt(index);
                  return ListTile(
                    title: Text(direction),
                    subtitle: Text(
                      'Lampu ${widget.trafficLight.directionStatuses[direction]} - Waktu tersisa: ${widget.trafficLight.secondsLeft[direction]} detik',
                      style: TextStyle(
                        color: widget.trafficLight.directionStatuses[direction] == 'Merah' ? Colors.red : Colors.green,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
