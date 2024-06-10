import 'package:flutter/material.dart';
import 'client/map_page.dart';
import 'complaints_reports/complaint_report_add_page.dart';
import 'complaints_reports/complaint_report_list_page.dart';
import 'client/alternative_routes_page.dart';
import 'client/traffic_light_page.dart';
import 'server/admin_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/add-complaint-report': (context) => ComplaintReportAddPage(),
        '/complaint-reports': (context) => ComplaintReportListPage(),
        '/map': (context) => MapPage(),
        '/alternative-routes': (context) => AlternativeRoutesPage(
          origin: LatLng(-6.917464, 107.619123), // Example origin
          destination: LatLng(-6.21462, 106.84513), // Example destination
        ),
        '/traffic-light-locations': (context) => TrafficLightPage(
          origin: LatLng(-6.917464, 107.619123), // Example origin
          destination: LatLng(-6.21462, 106.84513), // Example destination
        ),
        '/admin': (context) => AdminPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/map');
              },
              child: Text('Go to Map'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/admin');
              },
              child: Text('Admin Page'),
            ),
          ],
        ),
      ),
    );
  }
}
