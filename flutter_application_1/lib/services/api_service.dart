import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/location_model.dart';
import '../models/complaint_report_model.dart';
import 'dart:developer' as developer;

class ApiService {
  final String baseUrl = "http://192.168.37.194:3000"; // URL server backend Anda dengan protokol
  final String googlePlacesApiKey = "AIzaSyBponYX9GIEmuVbVUmoyP6qmPecLzCqsh0"; // Ganti dengan API Key Google Places yang benar
  final String googleDirectionsApiKey = "AIzaSyBponYX9GIEmuVbVUmoyP6qmPecLzCqsh0"; // Ganti dengan API Key Google Directions yang benar

  // Lokasi
  Future<List<Location>> fetchLocations() async {
    final response = await http.get(Uri.parse('$baseUrl/locations'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Location.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load locations');
    }
  }

  Future<void> createLocation(Location location) async {
    final response = await http.post(
      Uri.parse('$baseUrl/locations'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(location.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create location');
    }
  }

  Future<void> updateLocation(int id, Location location) async {
    final response = await http.put(
      Uri.parse('$baseUrl/locations/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(location.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update location');
    }
  }

  Future<void> deleteLocation(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/locations/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete location');
    }
  }

  // Pencarian Lokasi
  Future<List<Location>> searchLocations(String query) async {
    final url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$googlePlacesApiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return (data['results'] as List).map((place) => Location.fromJson(place)).toList();
      } else {
        throw Exception('Failed to load places: ${data['status']}');
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  // Rute Alternatif
  Future<List<List<LatLng>>> getAlternativeRoutes(LatLng origin, LatLng destination) async {
    final url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&alternatives=true&key=$googleDirectionsApiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return (data['routes'] as List)
            .map((route) => decodePolyline(route['overview_polyline']['points']))
            .toList();
      } else if (data['status'] == 'ZERO_RESULTS') {
        throw Exception('No routes found between the given locations.');
      } else {
        throw Exception('Failed to load directions: ${data['status']}');
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      LatLng point = LatLng(lat / 1E5, lng / 1E5);
      polyline.add(point);
    }
    return polyline;
  }

  // Pengaduan dan Laporan
  Future<List<ComplaintReport>> fetchComplaintReports() async {
    final response = await http.get(Uri.parse('$baseUrl/complaint-reports'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ComplaintReport.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load complaint reports');
    }
  }

  Future<void> createComplaintReport(ComplaintReport complaintReport) async {
    final response = await http.post(
      Uri.parse('$baseUrl/complaint-reports'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(complaintReport.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create complaint report');
    }
  }

  Future<void> updateComplaintReport(int id, ComplaintReport complaintReport) async {
    final response = await http.put(
      Uri.parse('$baseUrl/complaint-reports/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(complaintReport.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update complaint report');
    }
  }

  Future<void> deleteComplaintReport(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/complaint-reports/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete complaint report');
    }
  }
}
