import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location_model.dart';
import '../services/api_service.dart';
import 'alternative_routes_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final ApiService apiService = ApiService();
  final List<Location> _searchHistory = [];

  void _searchLocation() async {
    final origin = _originController.text;
    final destination = _destinationController.text;
    if (origin.isNotEmpty && destination.isNotEmpty) {
      try {
        final resultsOrigin = await apiService.searchLocations(origin);
        final resultsDestination = await apiService.searchLocations(destination);
        if (resultsOrigin.isNotEmpty && resultsDestination.isNotEmpty) {
          final locationOrigin = resultsOrigin.first;
          final locationDestination = resultsDestination.first;

          setState(() {
            _searchHistory.add(locationOrigin);
            _searchHistory.add(locationDestination);
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlternativeRoutesPage(
                origin: LatLng(locationOrigin.latitude, locationOrigin.longitude),
                destination: LatLng(locationDestination.latitude, locationDestination.longitude),
              ),
            ),
          );
        } else {
          print('No locations found');
        }
      } catch (e) {
        print('Error searching locations: $e');
      }
    } else {
      print('Origin and destination must not be empty');
    }
  }

  void _deleteFromHistory(Location location) {
    setState(() {
      _searchHistory.remove(location);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cari Lokasi'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _originController,
              decoration: InputDecoration(
                labelText: 'Lokasi Anda',
                prefixIcon: Icon(Icons.my_location),
              ),
            ),
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(
                labelText: 'Lokasi Tujuan',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchLocation,
              child: Text('Cari'),
            ),
            SizedBox(height: 20),
            Text('Riwayat Pencarian', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _searchHistory.length,
                itemBuilder: (context, index) {
                  final location = _searchHistory[index];
                  return ListTile(
                    title: Text(location.name),
                    subtitle: Text('Lat: ${location.latitude}, Lng: ${location.longitude}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteFromHistory(location),
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
