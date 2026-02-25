import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../models/chat_models.dart';
import '../services/chat_service.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  
  final RxList<ChatGroup> nearbyGroups = <ChatGroup>[].obs;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isConnected = false.obs;
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxString currentGroupId = ''.obs;
  final RxString currentNickname = ''.obs;
  final RxDouble searchRadius = 5.0.obs; // 5km default

  @override
  void onInit() {
    super.onInit();
    _initializeService();
    _getCurrentLocation();
  }

  Future<void> _initializeService() async {
    try {
      _chatService.initialize();
      await _chatService.signInAnonymously();
      isConnected.value = true;
    } catch (e) {
      // Silently handle auth errors - user can still view groups
      // but will need to retry when attempting to join/create
      isConnected.value = false;
      print('Chat service initialization error: $e');
    }
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
      await loadNearbyGroups();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get current location: $e');
    }
  }

  Future<void> loadNearbyGroups() async {
    if (currentPosition.value == null) return;

    isLoading.value = true;
    try {
      _chatService.getNearbyGroups(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
        searchRadius.value,
      ).listen((groups) {
        nearbyGroups.assignAll(groups);
        isLoading.value = false;
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to load nearby groups: $e');
      isLoading.value = false;
    }
  }

  Future<void> createGroup({
    required String name,
    required String description,
    required double radius,
  }) async {
    if (currentPosition.value == null) {
      Get.snackbar('Error', 'Location not available');
      return;
    }

    // Ensure user is authenticated before creating group
    if (!isConnected.value) {
      try {
        await _chatService.signInAnonymously();
        isConnected.value = true;
      } catch (e) {
        Get.snackbar('Error', 'Failed to authenticate. Please try again.');
        return;
      }
    }

    isLoading.value = true;
    try {
      await _chatService.createChatGroup(
        name: name,
        description: description,
        latitude: currentPosition.value!.latitude,
        longitude: currentPosition.value!.longitude,
        radius: radius,
      );

      Get.snackbar('Success', 'Group created successfully');
      await loadNearbyGroups();
    } catch (e) {
      Get.snackbar('Error', 'Failed to create group: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> joinGroup(String groupId, String nickname) async {
    // Ensure user is authenticated before joining group
    if (!isConnected.value) {
      try {
        await _chatService.signInAnonymously();
        isConnected.value = true;
      } catch (e) {
        Get.snackbar('Error', 'Failed to authenticate. Please try again.');
        return;
      }
    }

    isLoading.value = true;
    try {
      await _chatService.joinGroup(groupId, nickname);
      currentGroupId.value = groupId;
      currentNickname.value = nickname;
      
      // Load messages for this group
      await loadMessages(groupId);
      
      Get.snackbar('Success', 'Joined group successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to join group: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> leaveGroup() async {
    if (currentGroupId.value.isEmpty) return;

    isLoading.value = true;
    try {
      await _chatService.leaveGroup(currentGroupId.value);
      currentGroupId.value = '';
      currentNickname.value = '';
      messages.clear();
      
      Get.snackbar('Success', 'Left group successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to leave group: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMessages(String groupId) async {
    try {
      _chatService.getMessages(groupId).listen((chatMessages) {
        messages.assignAll(chatMessages);
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to load messages: $e');
    }
  }

  Future<void> sendMessage(String message) async {
    if (currentGroupId.value.isEmpty || currentNickname.value.isEmpty) {
      Get.snackbar('Error', 'Not in a group');
      return;
    }

    try {
      await _chatService.sendMessage(
        groupId: currentGroupId.value,
        message: message,
        nickname: currentNickname.value,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
    }
  }

  Future<void> shareLocation() async {
    if (currentGroupId.value.isEmpty || currentNickname.value.isEmpty) {
      Get.snackbar('Error', 'Not in a group');
      return;
    }

    if (currentPosition.value == null) {
      Get.snackbar('Error', 'Location not available');
      return;
    }

    try {
      await _chatService.sendLocationMessage(
        groupId: currentGroupId.value,
        nickname: currentNickname.value,
        latitude: currentPosition.value!.latitude,
        longitude: currentPosition.value!.longitude,
      );
      
      Get.snackbar('Success', 'Location shared successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to share location: $e');
    }
  }

  Future<void> updateSearchRadius(double radius) async {
    searchRadius.value = radius;
    await loadNearbyGroups();
  }

  Future<bool> isUserInGroup(String groupId) async {
    return await _chatService.isUserInGroup(groupId);
  }

  Future<String?> getUserNickname(String groupId) async {
    return await _chatService.getCurrentUserNickname(groupId);
  }

  Future<void> updateLastSeen() async {
    if (currentGroupId.value.isNotEmpty) {
      await _chatService.updateLastSeen(currentGroupId.value);
    }
  }

  @override
  void onClose() {
    _chatService.dispose();
    super.onClose();
  }
}
