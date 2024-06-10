import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/api_service.dart';
import 'traffic_light_page.dart';

class AlternativeRoutesPage extends StatefulWidget {
  final LatLng origin;
  final LatLng destination;

  AlternativeRoutesPage({required this.origin, required this.destination});

  @override
  _AlternativeRoutesPageState createState() => _AlternativeRoutesPageState();
}

class _AlternativeRoutesPageState extends State<AlternativeRoutesPage> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final ApiService apiService = ApiService();
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _loadAlternativeRoutes();
  }

  void _setMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('origin'),
          position: widget.origin,
          infoWindow: InfoWindow(
            title: 'Origin',
            snippet: '${widget.origin.latitude}, ${widget.origin.longitude}',
          ),
        ),
      );

      _markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position: widget.destination,
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: '${widget.destination.latitude}, ${widget.destination.longitude}',
          ),
        ),
      );
    });
  }

  void _loadAlternativeRoutes() async {
    try {
      final routes = await apiService.getAlternativeRoutes(widget.origin, widget.destination);
      setState(() {
        int routeIndex = 0;
        for (var route in routes) {
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route_$routeIndex'),
              points: route,
              color: routeIndex == 0 ? Colors.blue : Colors.grey,
              width: 5,
            ),
          );
          routeIndex++;
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load alternative routes: $e';
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alternative Routes'),
        actions: [
          IconButton(
            icon: Icon(Icons.traffic),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrafficLightPage(
                    origin: widget.origin,
                    destination: widget.destination,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: errorMessage.isEmpty
          ? GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: widget.origin,
                zoom: 11.0,
              ),
              markers: _markers,
              polylines: _polylines,
            )
          : Center(
              child: Text(errorMessage),
            ),
    );
  }
}
