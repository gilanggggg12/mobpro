import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'search_page.dart';
import '../complaints_reports/complaint_report_list_page.dart';
import 'weather_page.dart';
import 'traffic_congestion_page.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  LocationData? _currentLocation;
  final LatLng _center = const LatLng(-6.917464, 107.619123); // Center the map in Bandung
  final Location _location = Location();
  final Set<Marker> _markers = {};
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    addCustomIcon();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      setState(() {
        _currentLocation = locationData;
        _updateCurrentLocationMarker();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentLocation = currentLocation;
        _updateCurrentLocationMarker();
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
              zoom: 14.0,
            ),
          ),
        );
      });
    });
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)), 
      'assets/marker1.png',
    ).then((icon) {
      setState(() {
        markerIcon = icon;
      });
    }).catchError((error) {
      print('Error loading custom marker icon: $error');
    });
  }

  void _updateCurrentLocationMarker() {
    if (_currentLocation != null) {
      final marker = Marker(
        markerId: MarkerId('current_location'),
        position: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        infoWindow: InfoWindow(
          title: 'Lokasi Anda',
        ),
        icon: markerIcon,
      );
      setState(() {
        _markers.add(marker);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.wb_sunny), // Icon cuaca
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherPage()), // Buka halaman cuaca
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
          ),
          Positioned(
            top: 20,
            right: 15,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ComplaintReportListPage()),
                    );
                  },
                  child: Icon(Icons.warning),
                  heroTag: null,
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TrafficCongestionPage()),
                    );
                  },
                  child: Icon(Icons.traffic),
                  heroTag: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
