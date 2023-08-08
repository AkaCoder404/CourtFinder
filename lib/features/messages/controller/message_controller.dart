import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/apis/message_api.dart';
import 'package:courtfinder/apis/storage_api.dart';
import 'package:courtfinder/apis/user_api.dart';
import 'package:courtfinder/core/core.dart';
import 'package:courtfinder/core/utils.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/models/chat_model.dart';
import 'package:courtfinder/models/message_model.dart';
import 'package:courtfinder/models/user_model.dart';

final messageControllerProvider = StateNotifierProvider<MessageController, bool>((ref) {
  return MessageController(
    ref: ref,
    userAPI: ref.watch(userAPIProvider),
    messageAPI: ref.watch(messageAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
  );
});

final getUserDetailsProvider = FutureProvider.family((ref, String uid) async {
  final messageController = ref.watch(messageControllerProvider.notifier);
  return messageController.searchUser(uid);
});

final getMessagesProvider = FutureProvider.family((ref, ChatRoom chatRoom) {
  final messagesController = ref.watch(messageControllerProvider.notifier);
  return messagesController.getMessages(chatRoom);
});

final getMostRecentMessageProvider = FutureProvider.family((ref, ChatRoom chatRoom) {
  final messagesController = ref.watch(messageControllerProvider.notifier);
  return messagesController.getMostRecentMessage(chatRoom);
});

final getLatestMessageProvider = StreamProvider((ref) {
  final messageAPI = ref.watch(messageAPIProvider);
  return messageAPI.getLatestMessages();
});

final getChatRoomsDetailsProvider = FutureProvider.family((ref, String chatRoomId) {
  final messagesController = ref.watch(messageControllerProvider.notifier);
  return messagesController.getChatRoomDetails(chatRoomId);
});

class MessageController extends StateNotifier<bool> {
  final UserAPI _userAPI;
  final MessageAPI _messageAPI;
  final StorageAPI _storageAPI;
  final Ref _ref;
  MessageController({
    required Ref ref,
    required UserAPI userAPI,
    required MessageAPI messageAPI,
    required StorageAPI storageAPI,
  })  : _messageAPI = messageAPI,
        _storageAPI = storageAPI,
        _userAPI = userAPI,
        _ref = ref,
        super(false);

  Future<UserModel> searchUser(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }

  void createChatRoom({
    required String userId,
    required BuildContext context,
    required String otherUserId, // TODO: Support group chat
    required String name,
    required bool isGroupChat,
    required String chatRoom,
  }) async {
    state = true;
    ChatRoom chatRoom = ChatRoom(
      id: '',
      createdBy: userId,
      name: name,
      users: [userId, otherUserId],
      isGroupChat: isGroupChat,
      createdAt: DateTime.now(),
    );

    // Before creating chat room, check if chat room
    // already exists with the same users, if not, create one
    // otherwise, show the existing chat room

    final checkChatRoomsRes = await _messageAPI.checkIfPrivateChatExists(userId, otherUserId);
    print(checkChatRoomsRes.map((document) => ChatRoom.fromMap(document.data)).toList());
    if (checkChatRoomsRes.isNotEmpty) return;

    // Create chat room
    final createChatRoomRes = await _messageAPI.createChatRoom(chatRoom);
    var chatRoomId = '';
    createChatRoomRes.fold((l) => showSnackBar(context, l.message), (r) {
      chatRoomId = r.$id;
      showSnackBar(context, "${r.$id} Chat room created successfully");
    });

    // Add chat room id to current user's chats list and target user's chats list
    var currentUser = _ref.read(currentUserDetailsProvider).value!;
    currentUser = currentUser.copyWith(
      chats: [...currentUser.chats, chatRoomId],
    );
    final updateCurrUserChatsRes = await _userAPI.updateUserData(currentUser);
    updateCurrUserChatsRes.fold((l) => showSnackBar(context, l.message), (r) {
      print("Chat room added to user's chats list");
    });

    // Add chat room id to target user's chats list
    // TODO: Support Groupchat?
    final targetUserChatsRes = await _userAPI.getUserData(otherUserId);
    var updatedUser = UserModel.fromMap(targetUserChatsRes.data);
    updatedUser = updatedUser.copyWith(
      chats: [...updatedUser.chats, chatRoomId],
    );
    final updateTargetUserChatsRes = await _userAPI.updateUserData(updatedUser);
    updateTargetUserChatsRes.fold((l) => showSnackBar(context, l.message), (r) {
      print("Chat room added to target user's chats list");
    });

    // Send a message to the chat room
    sendMessage(text: "Hey~~ Let's chat!", chatRoomId: chatRoomId, userId: userId);

    state = false;
  }

  // Controller for sending messages
  void sendMessage({
    required String text,
    required String chatRoomId,
    required String userId,
    // required BuildContext context,
  }) async {
    state = true; // Loading
    Message msg = Message(
      id: '',
      text: text,
      messageType: MessageType.text, // TODO: Support Image, Video, Audio
      sentByUid: userId,
      sentToUid: chatRoomId,
      chatRoomId: chatRoomId,
      sentAt: DateTime.now(),
      imageLink: '',
    );

    final sendMsgRes = await _messageAPI.sendMessage(msg);
    // sendMsgRes.fold((l) => print(l.message), (r) {
    //   showSnackBar(context, "Message sent successfully");
    // });

    state = false; // Finished loading
  }

  Future<List<Message>> getMessages(ChatRoom chatRoom) async {
    final messages = await _messageAPI.getMessages(chatRoom);
    return messages.map((msg) => Message.fromMap(msg.data)).toList();
  }

  Future<Message> getMostRecentMessage(ChatRoom chatRoom) async {
    final message = await _messageAPI.getMostRecentMessage(chatRoom);
    if (message.isEmpty) {
      return Message(
          id: '',
          text: '',
          messageType: MessageType.text,
          sentByUid: '',
          sentToUid: '',
          chatRoomId: '',
          sentAt: DateTime.now(),
          imageLink: '');
    }
    return message.map((msg) => Message.fromMap(msg.data)).toList()[0];
  }

  Future<ChatRoom> getChatRoomDetails(String chatRoomId) async {
    final chatRoom = await _messageAPI.getChatRoomDetails(chatRoomId);
    return ChatRoom.fromMap(chatRoom.data);
  }
}
