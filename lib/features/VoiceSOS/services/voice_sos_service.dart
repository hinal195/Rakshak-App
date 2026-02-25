import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceSOSService {
  static final VoiceSOSService _instance = VoiceSOSService._internal();
  factory VoiceSOSService() => _instance;
  VoiceSOSService._internal();

  // Using awesome_notifications instead of flutter_local_notifications
  static const MethodChannel _platform = MethodChannel('voice_sos');

  Database? _database;
  StreamSubscription<Position>? _positionStream;
  Position? _currentPosition;
  bool _isVoiceSOSEnabled = false;
  bool _isListening = false;
  List<Map<String, dynamic>> _trustedContacts = [];

  Future<void> initialize() async {
    await _initDatabase();
    await _initializeNotifications();
    await _loadTrustedContacts();
    await _ensureCurrentLocation();
    _platform.setMethodCallHandler(_handleNativeCallbacks);
  }

  Future<Database> _initDatabase() async {
    if (_database != null) return _database!;
    
    String path = join(await getDatabasesPath(), 'voice_sos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE trusted_contacts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            phone TEXT NOT NULL,
            isActive INTEGER NOT NULL DEFAULT 1,
            createdAt TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE sos_logs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            triggerType TEXT NOT NULL,
            location TEXT,
            timestamp TEXT NOT NULL,
            contactsNotified TEXT,
            status TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> _initializeNotifications() async {
    // Initialize awesome notifications
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'sos_channel',
          channelName: 'SOS Alerts',
          channelDescription: 'Emergency SOS notifications',
          defaultColor: Colors.red,
          ledColor: Colors.white,
          playSound: true,
          enableVibration: true,
        ),
      ],
    );
  }

  Future<void> _loadTrustedContacts() async {
    final db = await _initDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'trusted_contacts',
      where: 'isActive = ?',
      whereArgs: [1],
    );
    _trustedContacts = maps;
  }

  Future<void> startVoiceSOS() async {
    if (_isVoiceSOSEnabled) return;
    
    // Request SMS permission before starting
    final smsStatus = await Permission.sms.request();
    if (!smsStatus.isGranted) {
      Get.snackbar(
        'Permission Required',
        'SMS permission is required for emergency alerts. Please grant it in settings.',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    // Request microphone permission
    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      Get.snackbar(
        'Permission Required',
        'Microphone permission is required for voice detection. Please grant it in settings.',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    // Request phone state permission (needed on some devices/SIMs for SMS manager)
    final phoneStatus = await Permission.phone.request();
    if (!phoneStatus.isGranted) {
      Get.snackbar(
        'Permission Required',
        'Phone permission is required to send SMS on this device. Please grant it in settings.',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    await _ensureCurrentLocation();
    await _startLocationTracking();

    // Pass trusted contacts to the native foreground service
    final contacts = _trustedContacts.map((c) => c['phone'] as String).toList();
    if (contacts.isEmpty) {
      Get.snackbar(
        'No Contacts',
        'Please add trusted contacts before enabling Voice SOS',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    await _platform.invokeMethod('startVoiceService', {'contacts': contacts});

    _isVoiceSOSEnabled = true;
    _isListening = true;

    Get.snackbar(
      'Voice SOS Activated',
      'Listening in background for wake words',
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }

  Future<void> stopVoiceSOS() async {
    _isVoiceSOSEnabled = false;
    await _stopLocationTracking();
    await _platform.invokeMethod('stopVoiceService');
    _isListening = false;
    
    Get.snackbar(
      'Voice SOS Deactivated',
      'Voice-activated emergency alerts are now disabled',
      backgroundColor: Get.theme.colorScheme.surface,
      colorText: Get.theme.colorScheme.onSurface,
    );
  }

  Future<void> _startLocationTracking() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions permanently denied');
      }

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        _currentPosition = position;
      });
    } catch (e) {
      print('Failed to start location tracking: $e');
    }
  }

  Future<void> _stopLocationTracking() async {
    await _positionStream?.cancel();
    _positionStream = null;
  }

  Future<void> _ensureCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied');
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Unable to fetch current location: $e');
    }
  }

  Future<void> _showSOSNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'sos_channel',
        title: 'SOS Alert Triggered',
        body: 'Emergency alert has been sent to your trusted contacts',
        notificationLayout: NotificationLayout.Default,
        color: Colors.red,
      ),
    );
  }

  Future<void> _logSOSEvent(String triggerType, {String status = 'sent'}) async {
    final db = await _initDatabase();
    await db.insert('sos_logs', {
      'triggerType': triggerType,
      'location': _currentPosition != null
          ? '${_currentPosition!.latitude}, ${_currentPosition!.longitude}'
          : null,
      'timestamp': DateTime.now().toIso8601String(),
      'contactsNotified': _trustedContacts.map((c) => c['name']).join(', '),
      'status': status,
    });
  }

  // Trusted Contacts Management
  Future<void> addTrustedContact(String name, String phone) async {
    final db = await _initDatabase();
    await db.insert('trusted_contacts', {
      'name': name,
      'phone': phone,
      'isActive': 1,
      'createdAt': DateTime.now().toIso8601String(),
    });
    await _loadTrustedContacts();
  }

  Future<void> removeTrustedContact(int id) async {
    final db = await _initDatabase();
    await db.update(
      'trusted_contacts',
      {'isActive': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    await _loadTrustedContacts();
  }

  Future<List<Map<String, dynamic>>> getTrustedContacts() async {
    return _trustedContacts;
  }

  Future<List<Map<String, dynamic>>> getSOSLogs() async {
    final db = await _initDatabase();
    return await db.query(
      'sos_logs',
      orderBy: 'timestamp DESC',
      limit: 50,
    );
  }

  // Manual SOS trigger
  Future<void> triggerManualSOS() async {
    if (_currentPosition == null) {
      await _ensureCurrentLocation();
    }

    try {
      await _showSOSNotification();
      await _sendSMSToTrustedContacts();
      await _logSOSEvent('manual', status: 'sent');
      Get.snackbar(
        'SOS Alert Sent',
        'Emergency alert has been sent to your trusted contacts',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to send SOS alert: $e');
    }
  }

  // Getters
  bool get isVoiceSOSEnabled => _isVoiceSOSEnabled;
  bool get isListening => _isListening;
  Position? get currentPosition => _currentPosition;

  void dispose() {
    _positionStream?.cancel();
  }

  Future<void> _sendSMSToTrustedContacts() async {
    // Manual SOS uses existing SMS via URL launcher fallback
    if (_trustedContacts.isEmpty) {
      Get.snackbar('Warning', 'No trusted contacts configured');
      return;
    }

    final String locationText = _currentPosition != null
        ? 'Location: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}'
        : 'Location: Not available';

    final String message = '''
SHEILD EMERGENCY ALERT!

I need immediate help! This is an automated emergency message.

$locationText

Time: ${DateTime.now().toString()}

Please check on me immediately!
''';

    for (Map<String, dynamic> contact in _trustedContacts) {
      try {
        final Uri smsUri = Uri(
          scheme: 'sms',
          path: contact['phone'] as String,
          queryParameters: {'body': message},
        );

        if (await canLaunchUrl(smsUri)) {
          await launchUrl(smsUri);
        } else {
          print('Could not launch SMS for ${contact['name']}');
        }
      } catch (e) {
        print('Failed to send SMS to ${contact['name']}: $e');
      }
    }
  }

  Future<void> _handleNativeCallbacks(MethodCall call) async {
    if (call.method == "sos_triggered") {
      final data = Map<String, dynamic>.from(call.arguments as Map);
      final triggerWord = data['triggerWord'] as String? ?? 'unknown';
      final double? lat = data['latitude'] == null ? null : (data['latitude'] as num).toDouble();
      final double? lng = data['longitude'] == null ? null : (data['longitude'] as num).toDouble();
      final timestamp = data['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch;

      if (lat != null && lng != null) {
        _currentPosition = Position(
          latitude: lat,
          longitude: lng,
          timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      }

      final status = data['status'] as String? ?? 'sent';
      await _logSOSEvent(triggerWord, status: status);
      await _loadSOSLogs();
    } else if (call.method == "status") {
      final data = Map<String, dynamic>.from(call.arguments as Map);
      _isVoiceSOSEnabled = data['active'] == true;
      _isListening = _isVoiceSOSEnabled;
    }
  }

  Future<void> _loadSOSLogs() async {
    await getSOSLogs();
  }
}
