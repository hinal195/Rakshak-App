import 'dart:async';
import 'package:geolocator/geolocator.dart'; // Import Geolocator
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Rakshak/common/widgets.Login_Signup/loaders/snackbar_loader.dart';
import '../../../../Constants/contactsm.dart';
import '../../../../DB/db_services.dart';

class SOSController extends GetxController {
  final _contactList = <TContact>[].obs;
  RxBool isSOSActive = false.obs; // Make isSOSActive observable
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _loadContacts();
  }

  Future<void> refreshContacts() async {
    _contactList.assignAll(await DatabaseHelper().getContactList());
  }

  void _loadContacts() async {
    await refreshContacts();
  }

  // Update the method to accept Position instead of LocationData
  Future<void> sendSOS(Position position) async {
    await refreshContacts();
    if (!isSOSActive.value) {
      if (_contactList.isEmpty) {
        TLoaders.warningSnackBar(
          title: "No trusted contacts available? Please Add Trusted Contact!",
        );
        return;
      }

      bool permissionsGranted = await _arePermissionsGranted();
      if (permissionsGranted) {
        isSOSActive.value = true;
        TLoaders.successSnackBar(title: "SOS Help Activated");
        // await _sendSOSMessage(position);
        _startSOSMessageTimer(position);
      }
    }
  }

  Future<void> stopSOS() async {
    if (isSOSActive.value) {
      _timer?.cancel();
      isSOSActive.value = false;
      TLoaders.successSnackBar(title: "SOS Help Deactivated");
    }
  }

  void _startSOSMessageTimer(Position position) {
    _sendSOSMessage(position);
    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      await _sendSOSMessage(position);
    });
  }

  Future<void> _sendSOSMessage(Position position) async {
    String message =
        "I am in trouble! Please reach me at my current live location: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

    for (TContact contact in _contactList) {
      await sendMessage(contact.number, message);
      TLoaders.customToast(message: "Sent SOS message successfully");
    }
  }

  Future<void> sendShakeSOS(Position position) async {
    await refreshContacts(); // Ensure we have the latest contacts
    if (_contactList.isEmpty) {
      TLoaders.warningSnackBar(
        title: "No trusted contacts available? Please Add Trusted Contact!",
      );
      return;
    }

    bool permissionsGranted = await _arePermissionsGranted();
    if (permissionsGranted) {
      String message =
          "I am in trouble! Please reach me at my current live location: https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

      for (TContact contact in _contactList) {
        await sendMessage(contact.number, message);
      }
    }
  }

  Future<bool> _arePermissionsGranted() async {
    return await Permission.sms.isGranted &&
        await Permission.contacts.isGranted;
  }

  Future<void> sendMessage(String phoneNumber, String message) async {
    try {
      // Clean phone number (remove spaces, dashes, etc.)
      String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      
      // Use url_launcher to open SMS app
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: cleanNumber,
        queryParameters: {'body': message},
      );
      
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
        print('SMS app opened for $phoneNumber: $message');
        TLoaders.successSnackBar(title: "SMS app opened for $phoneNumber");
      } else {
        print('Could not launch SMS app');
        TLoaders.errorSnackBar(title: "Could not open SMS app");
      }
    } catch (e) {
      print('Error sending SMS to $phoneNumber: $e');
      TLoaders.errorSnackBar(title: "Error sending SMS: $e");
    }
  }
}
