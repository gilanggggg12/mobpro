import 'package:flutter/material.dart';

class TrafficCongestionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Kemacetan'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.traffic),
            title: Text('Jalan Sudirman'),
            subtitle: Text('Kemacetan: Parah'),
          ),
          ListTile(
            leading: Icon(Icons.traffic),
            title: Text('Jalan Thamrin'),
            subtitle: Text('Kemacetan: Sedang'),
          ),
          ListTile(
            leading: Icon(Icons.traffic),
            title: Text('Jalan Gatot Subroto'),
            subtitle: Text('Kemacetan: Ringan'),
          ),
          // Add more traffic information here
        ],
      ),
    );
  }
}
