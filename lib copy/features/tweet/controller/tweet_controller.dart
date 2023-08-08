import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/apis/storage_api.dart';
import 'package:courtfinder/apis/tweet_api.dart';
import 'package:courtfinder/core/enums/notification_type_enum.dart';
import 'package:courtfinder/core/enums/tweet_type_enum.dart';
import 'package:courtfinder/core/utils.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/notifications/controller/notification_controller.dart';
import 'package:courtfinder/models/tweet_model.dart';
import 'package:courtfinder/models/user_model.dart';
import 'package:const_date_time/const_date_time.dart';

final tweetControllerProvider = StateNotifierProvider<TweetController, bool>(
  (ref) {
    return TweetController(
      ref: ref,
      tweetAPI: ref.watch(tweetAPIProvider),
      storageAPI: ref.watch(storageAPIProvider),
      notificationController: ref.watch(notificationControllerProvider.notifier),
    );
  },
);

final getTweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

// 获取推文的评论
final getRepliesToTweetsProvider = FutureProvider.family((ref, Tweet tweet) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getRepliesToTweet(tweet);
});

// 实时的获取推文
final getLatestTweetProvider = StreamProvider((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});

// 安推文的ID获取推文
final getTweetByIdProvider = FutureProvider.family((ref, String id) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetById(id);
});

// 安推文的标题/Hashtag获取推文
final getTweetsByHashtagProvider = FutureProvider.family((ref, String hashtag) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweetsByHashtag(hashtag);
});

// 获取关注发布者的推文
final getFollowedUsersTweetsProvider = FutureProvider.family((ref, List<String> followedUsers) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getFollowedUsersTweets(followedUsers);
});

// 获取最火的推文，安Tweet的views
final getTopTweetsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTopTweets();
});

class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final NotificationController _notificationController;
  final Ref _ref;
  TweetController({
    required Ref ref,
    required TweetAPI tweetAPI,
    required StorageAPI storageAPI,
    required NotificationController notificationController,
  })  : _ref = ref,
        _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _notificationController = notificationController,
        super(false);

  // 获取所有推文
  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  // 获取最近最火的推文
  Future<List<Tweet>> getTopTweets() async {
    final tweetList = await _tweetAPI.getTopTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<Tweet> getTweetById(String id) async {
    final tweet = await _tweetAPI.getTweetById(id);
    return Tweet.fromMap(tweet.data);
  }

  void likeTweet(Tweet tweet, UserModel user) async {
    List<String> likes = tweet.likes;

    bool isUnlike = false;
    if (tweet.likes.contains(user.uid)) {
      // If user already liked the tweet, unlike it
      likes.remove(user.uid);
      isUnlike = true;
    } else {
      likes.add(user.uid);
    }

    int views = likes.length + tweet.favorites.length + tweet.reshareCount + tweet.commentIds.length;
    tweet = tweet.copyWith(likes: likes, views: views);
    final res = await _tweetAPI.likeTweet(tweet);
    res.fold((l) => null, (r) {
      if (!isUnlike) {
        _notificationController.createNotification(
          text: '${user.name} 给你Tweet点赞了!',
          postId: tweet.id,
          notificationType: NotificationType.like,
          uid: tweet.uid,
        );
      }
    });
  }

  // 收藏推文
  void favoriteTweet(Tweet tweet, UserModel user, BuildContext context) async {
    List<String> favorites = tweet.favorites;

    bool isUnfavorite = false;
    if (tweet.favorites.contains(user.uid)) {
      favorites.remove(user.uid);
      isUnfavorite = true;
    } else {
      favorites.add(user.uid);
    }

    // Update tweet
    int views = favorites.length + tweet.likes.length + tweet.reshareCount + tweet.commentIds.length;
    tweet = tweet.copyWith(favorites: favorites, views: views);
    final res = await _tweetAPI.favoriteTweet(tweet);
    res.fold((l) => showSnackBar(context, l.message), (r) {});
  }

  //
  void reshareTweet(
    Tweet tweet,
    UserModel currentUser,
    BuildContext context,
  ) async {
    tweet = tweet.copyWith(
      retweetedBy: currentUser.name,
      likes: [],
      commentIds: [],
      reshareCount: tweet.reshareCount + 1,
      views: tweet.views + 1,
    );

    // Update reshare count of original tweet
    final res = await _tweetAPI.updateReshareCount(tweet);
    res.fold(
      (l) => showSnackBar(context, l.message), // handle error
      (r) async {
        // handle success
        tweet = tweet.copyWith(
          id: ID.unique(),
          reshareCount: 0,
          tweetedAt: DateTime.now(),
        );

        // Share tweet
        final res2 = await _tweetAPI.shareTweet(tweet);
        res2.fold(
          (l) => showSnackBar(context, l.message),
          (r) {
            _notificationController.createNotification(
              text: '${currentUser.name} 共享你的tweet!',
              postId: tweet.id,
              notificationType: NotificationType.retweet,
              uid: tweet.uid,
            );
            showSnackBar(context, 'Retweeted!');
          },
        );
      },
    );
  }

  // 分享推文
  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
    Tweet originalTweet = const Tweet(
      text: '',
      hashtags: [],
      link: '',
      imageLinks: [],
      uid: '',
      tweetType: TweetType.text,
      tweetedAt: ConstDateTime(0),
      favorites: [],
      likes: [],
      commentIds: [],
      id: '',
      views: 0,
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: '',
    ),
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter text');
      return;
    }

    if (images.isNotEmpty) {
      _shareImageTweet(
        images: images,
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
      );
    } else {
      _shareTextTweet(
        text: text,
        context: context,
        repliedTo: repliedTo,
        repliedToUserId: repliedToUserId,
        originalTweet: originalTweet,
      );
    }
  }

  Future<List<Tweet>> getRepliesToTweet(Tweet tweet) async {
    final documents = await _tweetAPI.getRepliesToTweet(tweet);
    return documents.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<List<Tweet>> getTweetsByHashtag(String hashtag) async {
    final documents = await _tweetAPI.getTweetsByHashtag(hashtag);
    return documents.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<List<Tweet>> getFollowedUsersTweets(List<String> following) async {
    final documents = await _tweetAPI.getFollowedUsersTweets(following);
    return documents.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  // 分享有照片推文
  void _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images);
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      favorites: const [],
      likes: const [],
      commentIds: const [],
      id: '',
      views: 0,
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );
    final res = await _tweetAPI.shareTweet(tweet);

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (repliedToUserId.isNotEmpty) {
        _notificationController.createNotification(
          text: '${user.name} 给你Tweet评论了!',
          postId: r.$id,
          notificationType: NotificationType.reply,
          uid: repliedToUserId,
        );
      }
    });
    state = false;
  }

  // 分享文本推文
  void _shareTextTweet({
    required String text,
    required BuildContext context,
    required String repliedTo,
    required String repliedToUserId,
    required Tweet originalTweet,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: const [],
      uid: user.uid,
      tweetType: TweetType.text,
      tweetedAt: DateTime.now(),
      favorites: const [],
      likes: const [],
      commentIds: const [],
      id: '',
      views: 0,
      reshareCount: 0,
      retweetedBy: '',
      repliedTo: repliedTo,
    );

    // Share new tweet
    final res = await _tweetAPI.shareTweet(tweet);
    var newId = '';
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        // Send notification if replied to tweet
        if (repliedToUserId.isNotEmpty) {
          newId = r.$id;
          _notificationController.createNotification(
            text: '${user.name} replied to your tweet!',
            postId: r.$id,
            notificationType: NotificationType.reply,
            uid: repliedToUserId,
          );
        }
      },
    );

    // TODO: update tweet commentIds Count of repliedTo tweet
    if (repliedTo != '') {
      List<String> commentIds = originalTweet.commentIds;
      commentIds.add(newId);
      originalTweet.copyWith(
        commentIds: commentIds,
      );
      final updatePreviousTweetCommentCountRes = await _tweetAPI.updateCommentCount(originalTweet);

      updatePreviousTweetCommentCountRes.fold((l) => showSnackBar(context, l.message), (r) {
        print('Comment count updated');
      });
    }
    state = false;
  }

  // Util 函数
  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }
}
