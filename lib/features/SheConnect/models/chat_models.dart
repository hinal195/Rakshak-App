import 'package:uuid/uuid.dart';

class ChatGroup {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final double radius; // in meters
  final int memberCount;
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final bool isActive;

  ChatGroup({
    String? id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.memberCount = 0,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    this.isActive = true,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now(),
       lastMessageAt = lastMessageAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'memberCount': memberCount,
      'createdAt': createdAt.toIso8601String(),
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
  }

  factory ChatGroup.fromMap(Map<String, dynamic> map) {
    return ChatGroup(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      radius: map['radius'],
      memberCount: map['memberCount'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      lastMessageAt: DateTime.parse(map['lastMessageAt']),
      isActive: (map['isActive'] ?? 1) == 1,
    );
  }

  ChatGroup copyWith({
    String? name,
    String? description,
    double? latitude,
    double? longitude,
    double? radius,
    int? memberCount,
    DateTime? lastMessageAt,
    bool? isActive,
  }) {
    return ChatGroup(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      memberCount: memberCount ?? this.memberCount,
      createdAt: createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class ChatMessage {
  final String id;
  final String groupId;
  final String senderNickname;
  final String message;
  final DateTime timestamp;
  final MessageType type;
  final double? latitude;
  final double? longitude;
  final String? locationName;

  ChatMessage({
    String? id,
    required this.groupId,
    required this.senderNickname,
    required this.message,
    DateTime? timestamp,
    this.type = MessageType.text,
    this.latitude,
    this.longitude,
    this.locationName,
  }) : id = id ?? const Uuid().v4(),
       timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'senderNickname': senderNickname,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      groupId: map['groupId'],
      senderNickname: map['senderNickname'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
      type: MessageType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => MessageType.text,
      ),
      latitude: map['latitude'],
      longitude: map['longitude'],
      locationName: map['locationName'],
    );
  }

  ChatMessage copyWith({
    String? groupId,
    String? senderNickname,
    String? message,
    DateTime? timestamp,
    MessageType? type,
    double? latitude,
    double? longitude,
    String? locationName,
  }) {
    return ChatMessage(
      id: id,
      groupId: groupId ?? this.groupId,
      senderNickname: senderNickname ?? this.senderNickname,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
    );
  }
}

enum MessageType {
  text,
  location,
  system,
}

class ChatMember {
  final String id;
  final String groupId;
  final String nickname;
  final DateTime joinedAt;
  final bool isActive;
  final DateTime lastSeen;

  ChatMember({
    String? id,
    required this.groupId,
    required this.nickname,
    DateTime? joinedAt,
    this.isActive = true,
    DateTime? lastSeen,
  }) : id = id ?? const Uuid().v4(),
       joinedAt = joinedAt ?? DateTime.now(),
       lastSeen = lastSeen ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'nickname': nickname,
      'joinedAt': joinedAt.toIso8601String(),
      'isActive': isActive ? 1 : 0,
      'lastSeen': lastSeen.toIso8601String(),
    };
  }

  factory ChatMember.fromMap(Map<String, dynamic> map) {
    return ChatMember(
      id: map['id'],
      groupId: map['groupId'],
      nickname: map['nickname'],
      joinedAt: DateTime.parse(map['joinedAt']),
      isActive: (map['isActive'] ?? 1) == 1,
      lastSeen: DateTime.parse(map['lastSeen']),
    );
  }
}
