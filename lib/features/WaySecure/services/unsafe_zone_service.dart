import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/unsafe_zone_model.dart';

class UnsafeZoneService {
  static final UnsafeZoneService _instance = UnsafeZoneService._internal();
  factory UnsafeZoneService() => _instance;
  UnsafeZoneService._internal();

  Database? _database;
  // Using awesome_notifications instead of flutter_local_notifications
  StreamSubscription<Position>? _positionStream;
  List<UnsafeZone> _unsafeZones = [];
  List<String> _trustedContacts = [];

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'unsafe_zones.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE unsafe_zones(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            radius REAL NOT NULL,
            crimeReports TEXT,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL,
            reportedBy TEXT NOT NULL,
            severity INTEGER NOT NULL
          )
        ''');
        
        await db.execute('''
          CREATE TABLE crime_reports(
            id TEXT PRIMARY KEY,
            zoneId TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            reportedAt TEXT NOT NULL,
            source TEXT NOT NULL,
            url TEXT,
            FOREIGN KEY (zoneId) REFERENCES unsafe_zones (id)
          )
        ''');

        await db.execute('''
          CREATE TABLE trusted_contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT NOT NULL,
            isActive INTEGER NOT NULL DEFAULT 1
          )
        ''');
      },
    );
  }

  Future<void> initializeNotifications() async {
    // Initialize awesome notifications
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'unsafe_zone_channel',
          channelName: 'Unsafe Zone Alerts',
          channelDescription: 'Notifications for unsafe zone alerts',
          defaultColor: Colors.purple,
          ledColor: Colors.white,
          playSound: true,
          enableVibration: true,
        ),
      ],
    );
  }

  Future<void> startLocationMonitoring() async {
    await _loadUnsafeZones();
    await _loadTrustedContacts();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      _checkUnsafeZoneProximity(position);
    });
  }

  Future<void> stopLocationMonitoring() async {
    await _positionStream?.cancel();
    _positionStream = null;
  }

  Future<void> _checkUnsafeZoneProximity(Position position) async {
    for (UnsafeZone zone in _unsafeZones) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        zone.latitude,
        zone.longitude,
      );

      if (distance <= zone.radius) {
        await _triggerUnsafeZoneAlert(zone, position);
      }
    }
  }

  Future<void> _triggerUnsafeZoneAlert(UnsafeZone zone, Position position) async {
    // Show local notification
    await _showNotification(
      'Unsafe Zone Alert',
      'You have entered an unsafe zone: ${zone.name}. Stay alert and consider alternative routes.',
    );

    // Send SMS to trusted contacts
    await _sendSMSToTrustedContacts(
      'SHEILD ALERT: I have entered an unsafe zone (${zone.name}) at ${position.latitude}, ${position.longitude}. Please check on me.',
    );
  }

  Future<void> _showNotification(String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'unsafe_zone_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        color: Colors.purple,
      ),
    );
  }

  Future<void> _sendSMSToTrustedContacts(String message) async {
    for (String contact in _trustedContacts) {
      try {
        final Uri smsUri = Uri(
          scheme: 'sms',
          path: contact,
          queryParameters: {'body': message},
        );
        
        if (await canLaunchUrl(smsUri)) {
          await launchUrl(smsUri);
        } else {
          print('Could not launch SMS for $contact');
        }
      } catch (e) {
        print('Failed to send SMS to $contact: $e');
      }
    }
  }

  Future<void> _loadUnsafeZones() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('unsafe_zones');
    _unsafeZones = maps.map((map) => UnsafeZone.fromMap(map)).toList();
  }

  Future<void> _loadTrustedContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'trusted_contacts',
      where: 'isActive = ?',
      whereArgs: [1],
    );
    _trustedContacts = maps.map((map) => map['phone'] as String).toList();
  }

  // CRUD operations for unsafe zones
  Future<String> addUnsafeZone(UnsafeZone zone) async {
    final db = await database;
    await db.insert('unsafe_zones', zone.toMap());
    _unsafeZones.add(zone);
    return zone.id;
  }

  Future<List<UnsafeZone>> getAllUnsafeZones() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('unsafe_zones');
    return maps.map((map) => UnsafeZone.fromMap(map)).toList();
  }

  Future<void> updateUnsafeZone(UnsafeZone zone) async {
    final db = await database;
    await db.update(
      'unsafe_zones',
      zone.toMap(),
      where: 'id = ?',
      whereArgs: [zone.id],
    );
    
    int index = _unsafeZones.indexWhere((z) => z.id == zone.id);
    if (index != -1) {
      _unsafeZones[index] = zone;
    }
  }

  Future<void> deleteUnsafeZone(String zoneId) async {
    final db = await database;
    await db.delete(
      'unsafe_zones',
      where: 'id = ?',
      whereArgs: [zoneId],
    );
    _unsafeZones.removeWhere((zone) => zone.id == zoneId);
  }

  // Crime reports operations
  Future<String> addCrimeReport(CrimeReport report) async {
    final db = await database;
    await db.insert('crime_reports', report.toMap());
    return report.id;
  }

  Future<List<CrimeReport>> getCrimeReportsForZone(String zoneId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'crime_reports',
      where: 'zoneId = ?',
      whereArgs: [zoneId],
      orderBy: 'reportedAt DESC',
    );
    return maps.map((map) => CrimeReport.fromMap(map)).toList();
  }

  // Trusted contacts operations
  Future<void> addTrustedContact(String name, String phone) async {
    final db = await database;
    await db.insert('trusted_contacts', {
      'name': name,
      'phone': phone,
      'isActive': 1,
    });
    _trustedContacts.add(phone);
  }

  Future<List<Map<String, dynamic>>> getTrustedContacts() async {
    final db = await database;
    return await db.query(
      'trusted_contacts',
      where: 'isActive = ?',
      whereArgs: [1],
    );
  }

  Future<void> removeTrustedContact(String phone) async {
    final db = await database;
    await db.update(
      'trusted_contacts',
      {'isActive': 0},
      where: 'phone = ?',
      whereArgs: [phone],
    );
    _trustedContacts.remove(phone);
  }

  void dispose() {
    _positionStream?.cancel();
  }
}
