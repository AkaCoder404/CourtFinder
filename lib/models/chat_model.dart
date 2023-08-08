import 'package:flutter/foundation.dart';

@immutable
class ChatRoom {
  final String id; // chat room unique id
  final String createdBy; // user id of the user who created the chat room
  final String name; // chat room name
  final List<String> users; // list of user ids of the users in the chat room
  final bool isGroupChat; // is the chat room a group chat or not
  final DateTime createdAt; // when the chat room was created
  const ChatRoom({
    required this.id,
    required this.createdBy,
    required this.name,
    required this.users,
    required this.isGroupChat,
    required this.createdAt,
  });

  ChatRoom copyWith({
    String? id,
    String? createdBy,
    String? name,
    List<String>? users,
    bool? isGroupChat,
    DateTime? createdAt,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      name: name ?? this.name,
      users: users ?? this.users,
      isGroupChat: isGroupChat ?? this.isGroupChat,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'createdBy': createdBy});
    result.addAll({'name': name});
    result.addAll({'users': users});
    result.addAll({'isGroupChat': isGroupChat});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});

    return result;
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['\$id'] ?? '',
      createdBy: map['createdBy'] ?? '',
      name: map['name'] ?? '',
      users: List<String>.from(map['users']),
      isGroupChat: map['isGroupChat'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
