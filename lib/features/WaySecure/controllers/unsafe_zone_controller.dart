import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../models/unsafe_zone_model.dart';
import '../services/unsafe_zone_service.dart';

class UnsafeZoneController extends GetxController {
  final UnsafeZoneService _service = UnsafeZoneService();
  
  final RxList<UnsafeZone> unsafeZones = <UnsafeZone>[].obs;
  final RxList<CrimeReport> crimeReports = <CrimeReport>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLocationMonitoring = false.obs;
  final Rx<Position?> currentPosition = Rx<Position?>(null);

  @override
  void onInit() {
    super.onInit();
    _initializeService();
    _loadUnsafeZones();
    _getCurrentLocation();
  }

  Future<void> _initializeService() async {
    await _service.initializeNotifications();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar('Error', 'Location permissions are permanently denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = position;
    } catch (e) {
      Get.snackbar('Error', 'Failed to get current location: $e');
    }
  }

  Future<void> _loadUnsafeZones() async {
    isLoading.value = true;
    try {
      final zones = await _service.getAllUnsafeZones();
      unsafeZones.assignAll(zones);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load unsafe zones: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUnsafeZone({
    required String name,
    required String description,
    required double latitude,
    required double longitude,
    required double radius,
    required String reportedBy,
    int severity = 3,
  }) async {
    isLoading.value = true;
    try {
      final zone = UnsafeZone(
        name: name,
        description: description,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        reportedBy: reportedBy,
        severity: severity,
      );

      await _service.addUnsafeZone(zone);
      unsafeZones.add(zone);
      Get.snackbar('Success', 'Unsafe zone added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add unsafe zone: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCrimeReportsForZone(String zoneId) async {
    isLoading.value = true;
    try {
      final reports = await _service.getCrimeReportsForZone(zoneId);
      crimeReports.assignAll(reports);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load crime reports: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCrimeReport({
    required String zoneId,
    required String title,
    required String description,
    required String source,
    String? url,
  }) async {
    try {
      final report = CrimeReport(
        zoneId: zoneId,
        title: title,
        description: description,
        source: source,
        url: url,
      );

      await _service.addCrimeReport(report);
      crimeReports.add(report);
      Get.snackbar('Success', 'Crime report added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add crime report: $e');
    }
  }

  Future<void> startLocationMonitoring() async {
    try {
      await _service.startLocationMonitoring();
      isLocationMonitoring.value = true;
      Get.snackbar('Success', 'Location monitoring started');
    } catch (e) {
      Get.snackbar('Error', 'Failed to start location monitoring: $e');
    }
  }

  Future<void> stopLocationMonitoring() async {
    try {
      await _service.stopLocationMonitoring();
      isLocationMonitoring.value = false;
      Get.snackbar('Success', 'Location monitoring stopped');
    } catch (e) {
      Get.snackbar('Error', 'Failed to stop location monitoring: $e');
    }
  }

  Future<void> addTrustedContact(String name, String phone) async {
    try {
      await _service.addTrustedContact(name, phone);
      Get.snackbar('Success', 'Trusted contact added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add trusted contact: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getTrustedContacts() async {
    return await _service.getTrustedContacts();
  }

  Future<void> removeTrustedContact(String phone) async {
    try {
      await _service.removeTrustedContact(phone);
      Get.snackbar('Success', 'Trusted contact removed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove trusted contact: $e');
    }
  }

  @override
  void onClose() {
    _service.dispose();
    super.onClose();
  }
}
