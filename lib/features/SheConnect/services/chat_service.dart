import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_models.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  late DatabaseReference _groupsRef;
  late DatabaseReference _messagesRef;
  late DatabaseReference _membersRef;

  StreamSubscription<DatabaseEvent>? _groupsSubscription;
  StreamSubscription<DatabaseEvent>? _messagesSubscription;

  void initialize() {
    _groupsRef = _database.ref('chat_groups');
    _messagesRef = _database.ref('chat_messages');
    _membersRef = _database.ref('chat_members');
  }

  // Anonymous authentication
  Future<void> signInAnonymously() async {
    try {
      // Check if user is already signed in
      if (_auth.currentUser != null) {
        return;
      }
      await _auth.signInAnonymously();
    } catch (e) {
      // Re-throw with more context for better error handling
      throw Exception('Failed to sign in anonymously: $e');
    }
  }

  // Chat Groups
  Stream<List<ChatGroup>> getNearbyGroups(double latitude, double longitude, double radiusKm) {
    return _groupsRef.onValue.map((event) {
      if (event.snapshot.value == null) return <ChatGroup>[];

      final Map<dynamic, dynamic> groupsData = event.snapshot.value as Map<dynamic, dynamic>;
      final List<ChatGroup> groups = [];

      groupsData.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          final group = ChatGroup.fromMap(Map<String, dynamic>.from(value));
          
          // Check if group is within radius
          double distance = Geolocator.distanceBetween(
            latitude,
            longitude,
            group.latitude,
            group.longitude,
          ) / 1000; // Convert to kilometers

          if (distance <= radiusKm && group.isActive) {
            groups.add(group);
          }
        }
      });

      // Sort by member count and last message time
      groups.sort((a, b) {
        if (a.memberCount != b.memberCount) {
          return b.memberCount.compareTo(a.memberCount);
        }
        return b.lastMessageAt.compareTo(a.lastMessageAt);
      });

      return groups;
    });
  }

  Future<String> createChatGroup({
    required String name,
    required String description,
    required double latitude,
    required double longitude,
    required double radius,
  }) async {
    try {
      final group = ChatGroup(
        name: name,
        description: description,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );

      await _groupsRef.child(group.id).set(group.toMap());
      return group.id;
    } catch (e) {
      throw Exception('Failed to create chat group: $e');
    }
  }

  Future<void> joinGroup(String groupId, String nickname) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final member = ChatMember(
        groupId: groupId,
        nickname: nickname,
      );

      await _membersRef.child(groupId).child(user.uid).set(member.toMap());
      
      // Update member count
      await _updateMemberCount(groupId);
    } catch (e) {
      throw Exception('Failed to join group: $e');
    }
  }

  Future<void> leaveGroup(String groupId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _membersRef.child(groupId).child(user.uid).remove();
      
      // Update member count
      await _updateMemberCount(groupId);
    } catch (e) {
      throw Exception('Failed to leave group: $e');
    }
  }

  Future<void> _updateMemberCount(String groupId) async {
    try {
      final membersSnapshot = await _membersRef.child(groupId).get();
      int count = 0;
      
      if (membersSnapshot.exists) {
        final membersData = membersSnapshot.value as Map<dynamic, dynamic>;
        count = membersData.length;
      }

      await _groupsRef.child(groupId).update({
        'memberCount': count,
        'lastMessageAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Failed to update member count: $e');
    }
  }

  // Messages
  Stream<List<ChatMessage>> getMessages(String groupId) {
    return _messagesRef
        .child(groupId)
        .orderByChild('timestamp')
        .onValue
        .map((event) {
      if (event.snapshot.value == null) return <ChatMessage>[];

      final Map<dynamic, dynamic> messagesData = event.snapshot.value as Map<dynamic, dynamic>;
      final List<ChatMessage> messages = [];

      messagesData.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          messages.add(ChatMessage.fromMap(Map<String, dynamic>.from(value)));
        }
      });

      // Sort by timestamp
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return messages;
    });
  }

  Future<void> sendMessage({
    required String groupId,
    required String message,
    required String nickname,
    MessageType type = MessageType.text,
    double? latitude,
    double? longitude,
    String? locationName,
  }) async {
    try {
      final chatMessage = ChatMessage(
        groupId: groupId,
        senderNickname: nickname,
        message: message,
        type: type,
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
      );

      await _messagesRef.child(groupId).child(chatMessage.id).set(chatMessage.toMap());
      
      // Update group's last message time
      await _groupsRef.child(groupId).update({
        'lastMessageAt': chatMessage.timestamp.toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<void> sendLocationMessage({
    required String groupId,
    required String nickname,
    required double latitude,
    required double longitude,
    String? locationName,
  }) async {
    try {
      final message = 'Shared location: ${locationName ?? 'Current location'}';
      
      await sendMessage(
        groupId: groupId,
        message: message,
        nickname: nickname,
        type: MessageType.location,
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
      );
    } catch (e) {
      throw Exception('Failed to send location message: $e');
    }
  }

  // User management
  Future<String?> getCurrentUserNickname(String groupId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final memberSnapshot = await _membersRef.child(groupId).child(user.uid).get();
      if (memberSnapshot.exists) {
        final memberData = memberSnapshot.value as Map<dynamic, dynamic>;
        return memberData['nickname'] as String?;
      }
      return null;
    } catch (e) {
      print('Failed to get user nickname: $e');
      return null;
    }
  }

  Future<bool> isUserInGroup(String groupId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final memberSnapshot = await _membersRef.child(groupId).child(user.uid).get();
      return memberSnapshot.exists;
    } catch (e) {
      print('Failed to check if user is in group: $e');
      return false;
    }
  }

  Future<void> updateLastSeen(String groupId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _membersRef.child(groupId).child(user.uid).update({
        'lastSeen': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Failed to update last seen: $e');
    }
  }

  // Cleanup
  void dispose() {
    _groupsSubscription?.cancel();
    _messagesSubscription?.cancel();
  }
}
