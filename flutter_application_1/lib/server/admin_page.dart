import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/complaint_report_model.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final ApiService apiService = ApiService();
  Future<List<ComplaintReport>>? futureReports;

  @override
  void initState() {
    super.initState();
    futureReports = apiService.fetchComplaintReports();
  }

  void _deleteReport(int id) async {
    try {
      await apiService.deleteComplaintReport(id);
      setState(() {
        futureReports = apiService.fetchComplaintReports();
      });
    } catch (e) {
      print('Failed to delete report: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: FutureBuilder<List<ComplaintReport>>(
        future: futureReports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No reports available'));
          } else {
            final reports = snapshot.data!;
            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return ListTile(
                  title: Text(report.title),
                  subtitle: Text(report.description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteReport(report.id),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
