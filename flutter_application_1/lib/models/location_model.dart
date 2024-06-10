class Location {
  final int? id;
  final String name;
  final double latitude;
  final double longitude;

  Location({
    this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      latitude: (json['geometry']?['location']?['lat'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['geometry']?['location']?['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
