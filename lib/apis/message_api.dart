// API for private messages

import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/constants/appwrite_constants.dart';
import 'package:courtfinder/core/core.dart';
import 'package:courtfinder/core/providers.dart';
import 'package:appwrite/appwrite.dart';
import 'package:courtfinder/models/chat_model.dart';
import 'package:courtfinder/models/message_model.dart';
import 'package:fpdart/fpdart.dart';

final messageAPIProvider = Provider((ref) {
  return MessageAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class IMessageAPI {
  FutureEither<Document> createChatRoom(ChatRoom chatRoom);
  Future<Document> getChatRoomDetails(String chatRoomId);
  Future<List<Document>> checkIfPrivateChatExists(String uid, String targetUid);
  FutureEither<Document> sendMessage(Message message);
  Future<List<Document>> getMessages(ChatRoom chatRoom);
  Future<List<Document>> getMostRecentMessage(ChatRoom chatRoom);
  Stream<RealtimeMessage> getLatestMessages();
}

class MessageAPI implements IMessageAPI {
  final Databases _db;
  final Realtime _realtime;
  MessageAPI({required Databases db, required Realtime realtime})
      : _realtime = realtime,
        _db = db;

  @override
  FutureEither<Document> createChatRoom(ChatRoom chatRoom) async {
    try {
      final document = await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.chatRoomsCollection,
          documentId: ID.unique(),
          data: chatRoom.toMap());
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return left(Failure('createChatRoom ${e.toString()}', stackTrace));
    }
  }

  @override
  Future<Document> getChatRoomDetails(String chatRoomId) {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.chatRoomsCollection,
      documentId: chatRoomId,
    );
  }

  @override
  Future<List<Document>> checkIfPrivateChatExists(String uid, String targetUid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.chatRoomsCollection,
      queries: [
        Query.equal('createdBy', uid),
        Query.search('users', targetUid),
      ],
    );
    return documents.documents;
  }

  @override
  FutureEither<Document> sendMessage(Message message) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.messagesCollection,
        documentId: ID.unique(),
        data: message.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure('$Message API + ${e.toString()}', st));
    }
  }

  @override
  Future<List<Document>> getMessages(ChatRoom chatRoom) async {
    // print("getMessages");
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.messagesCollection,
      queries: [Query.limit(30), Query.offset(0), Query.equal('chatRoomId', chatRoom.id), Query.orderDesc('sentAt')],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getMostRecentMessage(ChatRoom chatRoom) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.messagesCollection,
      queries: [Query.limit(1), Query.offset(0), Query.equal('chatRoomId', chatRoom.id), Query.orderDesc('sentAt')],
    );
    return documents.documents.isEmpty ? [] : documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestMessages() {
    // print("getLatestMessages");
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.messagesCollection}.documents'
    ]).stream;
  }
}
