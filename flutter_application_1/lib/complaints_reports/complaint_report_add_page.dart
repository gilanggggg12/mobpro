import 'package:flutter/material.dart';
import '../models/complaint_report_model.dart';
import '../services/api_service.dart';

class ComplaintReportAddPage extends StatefulWidget {
  @override
  _ComplaintReportAddPageState createState() => _ComplaintReportAddPageState(); // Correct class name
}

class _ComplaintReportAddPageState extends State<ComplaintReportAddPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String location = '';
  String imagePath = ''; // Assuming you want to handle images

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save(); // Corrected method name
      // Creating a new complaint report without an ID, which will be assigned by the server
      ApiService().createComplaintReport(ComplaintReport(
        id: 0, // Placeholder, server will assign a proper ID
        title: title,
        description: description,
        location: location,
        imagePath: imagePath, // Make sure to handle image paths appropriately
      )).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Complaint Report")),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView( // Added for better form handling
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) => title = value ?? '',
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a title' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value ?? '',
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a description' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'), // Corrected property name
                onSaved: (value) => location = value ?? '',
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a location' : null,
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
