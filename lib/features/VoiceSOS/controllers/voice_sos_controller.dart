import 'package:get/get.dart';
import '../services/voice_sos_service.dart';

class VoiceSOSController extends GetxController {
  final VoiceSOSService _service = VoiceSOSService();
  
  final RxBool isVoiceSOSEnabled = false.obs;
  final RxBool isListening = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> trustedContacts = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> sosLogs = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeService();
  }

  Future<void> _initializeService() async {
    isLoading.value = true;
    try {
      await _service.initialize();
      await _loadTrustedContacts();
      await _loadSOSLogs();
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize Voice SOS service: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleVoiceSOS() async {
    isLoading.value = true;
    try {
      if (isVoiceSOSEnabled.value) {
        await _service.stopVoiceSOS();
        isVoiceSOSEnabled.value = false;
        isListening.value = false;
      } else {
        await _service.startVoiceSOS();
        isVoiceSOSEnabled.value = true;
        isListening.value = true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle Voice SOS: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> triggerManualSOS() async {
    isLoading.value = true;
    try {
      await _service.triggerManualSOS();
      await _loadSOSLogs(); // Refresh logs
    } catch (e) {
      Get.snackbar('Error', 'Failed to trigger manual SOS: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTrustedContact(String name, String phone) async {
    isLoading.value = true;
    try {
      await _service.addTrustedContact(name, phone);
      await _loadTrustedContacts();
      Get.snackbar('Success', 'Trusted contact added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add trusted contact: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeTrustedContact(int id) async {
    isLoading.value = true;
    try {
      await _service.removeTrustedContact(id);
      await _loadTrustedContacts();
      Get.snackbar('Success', 'Trusted contact removed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove trusted contact: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadTrustedContacts() async {
    try {
      final contacts = await _service.getTrustedContacts();
      trustedContacts.assignAll(contacts);
    } catch (e) {
      print('Failed to load trusted contacts: $e');
    }
  }

  Future<void> _loadSOSLogs() async {
    try {
      final logs = await _service.getSOSLogs();
      sosLogs.assignAll(logs);
    } catch (e) {
      print('Failed to load SOS logs: $e');
    }
  }

  @override
  void onClose() {
    _service.dispose();
    super.onClose();
  }
}
