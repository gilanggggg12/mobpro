class ComplaintReport {
  final int id;
  final String title;
  final String description;
  final String location;
  final String imagePath;

  ComplaintReport({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.imagePath,
  });

  factory ComplaintReport.fromJson(Map<String, dynamic> json) {
    return ComplaintReport(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'imagePath': imagePath,
    };
  }
}
