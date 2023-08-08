import 'package:flutter/foundation.dart';
import 'package:courtfinder/core/core.dart';

@immutable
class Message {
  final String sentByUid;
  final String sentToUid;
  final String chatRoomId;
  final String id; // message id set by app write
  final MessageType messageType;
  final String text;
  final String imageLink;
  final DateTime sentAt;
  const Message({
    required this.sentByUid,
    required this.sentToUid,
    required this.chatRoomId,
    required this.messageType,
    required this.text,
    required this.imageLink,
    required this.sentAt,
    required this.id,
  });

  Message copyWith({
    String? sentByUid,
    String? sentToUid,
    String? chatRoomId,
    String? uid,
    String? id,
    MessageType? messageType,
    String? text,
    String? imageLink,
    DateTime? sentAt,
  }) {
    return Message(
      sentByUid: sentByUid ?? this.sentByUid,
      sentToUid: sentToUid ?? this.sentToUid,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      id: id ?? this.id,
      messageType: messageType ?? this.messageType,
      text: text ?? this.text,
      imageLink: imageLink ?? this.imageLink,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'sentByUid': sentByUid});
    result.addAll({'sentToUid': sentToUid});
    result.addAll({'chatRoomId': chatRoomId});
    result.addAll({'messageType': messageType.type});
    result.addAll({'text': text});
    result.addAll({'imageLink': imageLink});
    result.addAll({'sentAt': sentAt.millisecondsSinceEpoch});

    return result;
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      sentByUid: map['sentByUid'] ?? '',
      sentToUid: map['sentToUid'] ?? '',
      chatRoomId: map['chatRoomId'] ?? '',
      id: map['\$id'] ?? '',
      messageType: (map['messageType'] as String).toMessageTypeEnum(),
      text: map['text'] ?? '',
      imageLink: map['imageLink'] ?? '',
      sentAt: DateTime.fromMillisecondsSinceEpoch(map['sentAt']),
    );
  }

  @override
  String toString() {
    return 'Message(sentByUid: $sentByUid, sentToUid: $sentToUid, id: $id, messageType: $messageType, chatRoomId: $chatRoomId, $text, imageLink: $imageLink, sentAt: $sentAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.sentByUid == sentByUid &&
        other.sentToUid == sentToUid &&
        other.chatRoomId == chatRoomId &&
        other.id == id &&
        other.messageType == messageType &&
        other.text == text &&
        other.imageLink == imageLink &&
        other.sentAt == sentAt;
  }

  @override
  int get hashCode {
    return sentByUid.hashCode ^
        sentToUid.hashCode ^
        chatRoomId.hashCode ^
        id.hashCode ^
        messageType.hashCode ^
        text.hashCode ^
        imageLink.hashCode ^
        sentAt.hashCode;
  }
}
