import 'package:uuid/uuid.dart';

class UnsafeZone {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final double radius; // in meters
  final List<String> crimeReports;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String reportedBy;
  final int severity; // 1-5 scale

  UnsafeZone({
    String? id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.crimeReports = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.reportedBy,
    this.severity = 3,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'crimeReports': crimeReports.join(','),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'reportedBy': reportedBy,
      'severity': severity,
    };
  }

  factory UnsafeZone.fromMap(Map<String, dynamic> map) {
    return UnsafeZone(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      radius: map['radius'],
      crimeReports: map['crimeReports']?.split(',') ?? [],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      reportedBy: map['reportedBy'],
      severity: map['severity'] ?? 3,
    );
  }

  UnsafeZone copyWith({
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    double? radius,
    List<String>? crimeReports,
    DateTime? updatedAt,
    String? reportedBy,
    int? severity,
  }) {
    return UnsafeZone(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      crimeReports: crimeReports ?? this.crimeReports,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      reportedBy: reportedBy ?? this.reportedBy,
      severity: severity ?? this.severity,
    );
  }
}

class CrimeReport {
  final String id;
  final String zoneId;
  final String title;
  final String description;
  final DateTime reportedAt;
  final String source; // "user", "news", "police"
  final String? url;

  CrimeReport({
    String? id,
    required this.zoneId,
    required this.title,
    required this.description,
    DateTime? reportedAt,
    required this.source,
    this.url,
  }) : id = id ?? const Uuid().v4(),
       reportedAt = reportedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'zoneId': zoneId,
      'title': title,
      'description': description,
      'reportedAt': reportedAt.toIso8601String(),
      'source': source,
      'url': url,
    };
  }

  factory CrimeReport.fromMap(Map<String, dynamic> map) {
    return CrimeReport(
      id: map['id'],
      zoneId: map['zoneId'],
      title: map['title'],
      description: map['description'],
      reportedAt: DateTime.parse(map['reportedAt']),
      source: map['source'],
      url: map['url'],
    );
  }
}
