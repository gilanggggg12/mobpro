import 'package:flutter/material.dart';
import '../models/complaint_report_model.dart';
import '../services/api_service.dart';

class ComplaintReportListPage extends StatefulWidget {
  @override
  _ComplaintReportListPageState createState() => _ComplaintReportListPageState();
}

class _ComplaintReportListPageState extends State<ComplaintReportListPage> {
  late Future<List<ComplaintReport>> futureComplaintReports;

  @override
  void initState() {
    super.initState();
    futureComplaintReports = ApiService().fetchComplaintReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Reports'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add-complaint-report');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<ComplaintReport>>(
        future: futureComplaintReports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No complaint reports available'));
          } else {
            final complaintReports = snapshot.data!;
            return ListView.builder(
              itemCount: complaintReports.length,
              itemBuilder: (context, index) {
                final report = complaintReports[index];
                return ListTile(
                  title: Text(report.title),
                  subtitle: Text(report.description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      ApiService().deleteComplaintReport(report.id).then((_) {
                        setState(() {
                          futureComplaintReports = ApiService().fetchComplaintReports();
                        });
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
                      });
                    },
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
