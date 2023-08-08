import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:courtfinder/constants/appwrite_constants.dart';
import 'package:courtfinder/core/core.dart';
import 'package:courtfinder/core/providers.dart';
import 'package:courtfinder/models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class ITweetAPI {
  // 发布推文
  FutureEither<Document> shareTweet(Tweet tweet);
  // 获取推文
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet(); // appwrite uses websockets to send realtime messages
  Future<List<Document>> getRepliesToTweet(Tweet tweet);
  Future<List<Document>> getUserTweets(String uid);
  Future<Document> getTweetById(String id);
  Future<List<Document>> getTweetsByHashtag(String hashtag);
  Future<List<Document>> getTopTweets();
  Future<List<Document>> getFollowedUsersTweets(List<String> uids);
  Future<List<Document>> searchTweetByKeyword(String keyword);
  // 更新推文
  FutureEither<Document> likeTweet(Tweet tweet);
  FutureEither<Document> favoriteTweet(Tweet tweet);
  FutureEither<Document> updateReshareCount(Tweet tweet);
  FutureEither<Document> updateCommentCount(Tweet tweet);
  // 删除推文
}

class TweetAPI implements ITweetAPI {
  final Databases _db;
  final Realtime _realtime;
  TweetAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  // 发布推文
  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: ID.unique(),
        data: tweet.toMap(),
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
      return left(Failure(e.toString(), st));
    }
  }

  // 获取最火的推文
  @override
  Future<List<Document>> getTweets() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.equal('repliedTo', ''), // Only get tweets that are not replies
        Query.offset(0),
        Query.orderDesc('tweetedAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getTopTweets() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.offset(0),
        Query.orderDesc('views'),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    // print("getLatestTweet");
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> likeTweet(Tweet tweet) async {
    try {
      // Update the tweet's likes count
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {'likes': tweet.likes, 'views': tweet.views},
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', st),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<Document> favoriteTweet(Tweet tweet) async {
    // update the tweet's favorites count
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetsCollection,
          documentId: tweet.id,
          data: {'favorites': tweet.favorites, 'views': tweet.views});
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Some unexpected error occurred', st));
    }
  }

  @override
  FutureEither<Document> updateReshareCount(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {
          'reshareCount': tweet.reshareCount,
          'views': tweet.views,
        },
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
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getRepliesToTweet(Tweet tweet) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.orderDesc('tweetedAt'),
        Query.equal('repliedTo', tweet.id),
      ],
    );
    return document.documents;
  }

  @override
  Future<Document> getTweetById(String id) async {
    return _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      documentId: id,
    );
  }

  @override
  Future<List<Document>> getUserTweets(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetsCollection,
      queries: [
        Query.equal('uid', uid),
        Query.orderDesc('tweetedAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getTweetsByHashtag(String hashtag) async {
    try {
      final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        queries: [Query.search('hashtags', hashtag), Query.orderDesc('tweetedAt')],
      );
      return documents.documents;
    } catch (e, st) {
      print("Error: $e $st");
      return [];
    }
  }

  @override
  Future<List<Document>> getFollowedUsersTweets(List<String> uids) async {
    try {
      final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        queries: [
          Query.equal('uid', uids), // 获取关注的用户的推文
          Query.equal('retweetedBy', ''), // 不要获取转发的推文
          Query.orderDesc('tweetedAt'), // 按照推文时间排序
        ],
      );
      return documents.documents;
    } catch (e, st) {
      print("Error: $e $st");
      return [];
    }
  }

  @override
  FutureEither<Document> updateCommentCount(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {
          'commentIds': tweet.commentIds,
        },
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Some unepected error occured', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> searchTweetByKeyword(String keyword) async {
    print(keyword);
    try {
      final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetsCollection,
        queries: [
          Query.search('text', keyword),
          Query.orderDesc('tweetedAt'),
        ],
      );
      return documents.documents;
    } catch (e, st) {
      print("Error: $e $st");
      return [];
    }
  }
}
