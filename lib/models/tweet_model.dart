import 'package:flutter/foundation.dart';

import 'package:courtfinder/core/enums/tweet_type_enum.dart';

@immutable
class Tweet {
  final String text;
  final List<String> hashtags;
  final String link;
  final List<String> imageLinks;
  final String uid;
  final TweetType tweetType;
  final String tweetTag;
  final DateTime tweetedAt;
  final List<String> likes;
  final List<String> favorites;
  final List<String> commentIds;
  final String location;
  final String id;
  final int views;
  final int reshareCount;
  final String retweetedBy;
  final String repliedTo;
  const Tweet({
    required this.text,
    required this.hashtags,
    required this.link,
    required this.imageLinks,
    required this.uid,
    required this.tweetType,
    required this.tweetTag,
    required this.tweetedAt,
    required this.favorites,
    required this.likes,
    required this.commentIds,
    required this.location,
    required this.id,
    required this.views,
    required this.reshareCount,
    required this.retweetedBy,
    required this.repliedTo,
  });

  Tweet copyWith({
    String? text,
    List<String>? hashtags,
    String? link,
    List<String>? imageLinks,
    String? uid,
    TweetType? tweetType,
    String? tweetTag,
    DateTime? tweetedAt,
    List<String>? likes,
    List<String>? favorites,
    List<String>? commentIds,
    String? location,
    String? id,
    int? views,
    int? reshareCount,
    String? retweetedBy,
    String? repliedTo,
  }) {
    return Tweet(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      tweetType: tweetType ?? this.tweetType,
      tweetTag: tweetTag ?? this.tweetTag,
      tweetedAt: tweetedAt ?? this.tweetedAt,
      favorites: favorites ?? this.favorites,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      location: location ?? this.location,
      id: id ?? this.id,
      views: views ?? this.views,
      reshareCount: reshareCount ?? this.reshareCount,
      retweetedBy: retweetedBy ?? this.retweetedBy,
      repliedTo: repliedTo ?? this.repliedTo,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'text': text});
    result.addAll({'hashtags': hashtags});
    result.addAll({'link': link});
    result.addAll({'imageLinks': imageLinks});
    result.addAll({'uid': uid});
    result.addAll({'tweetType': tweetType.type});
    result.addAll({'tweetTag': tweetTag});
    result.addAll({'tweetedAt': tweetedAt.millisecondsSinceEpoch});
    result.addAll({'favorites': favorites});
    result.addAll({'likes': likes});
    result.addAll({'commentIds': commentIds});
    result.addAll({'location': location});
    result.addAll({'views': views});
    result.addAll({'reshareCount': reshareCount});
    result.addAll({'retweetedBy': retweetedBy});
    result.addAll({'repliedTo': repliedTo});

    return result;
  }

  factory Tweet.fromMap(Map<String, dynamic> map) {
    return Tweet(
      text: map['text'] ?? '',
      hashtags: List<String>.from(map['hashtags']),
      link: map['link'] ?? '',
      imageLinks: List<String>.from(map['imageLinks']),
      uid: map['uid'] ?? '',
      tweetType: (map['tweetType'] as String).toTweetTypeEnum(),
      tweetTag: map['tweetTag'] ?? '',
      tweetedAt: DateTime.fromMillisecondsSinceEpoch(map['tweetedAt']),
      favorites: List<String>.from(map['favorites']),
      likes: List<String>.from(map['likes']),
      commentIds: List<String>.from(map['commentIds']),
      location: map['location'] ?? '',
      id: map['\$id'] ?? '',
      views: map['views']?.toInt() ?? 0,
      reshareCount: map['reshareCount']?.toInt() ?? 0,
      retweetedBy: map['retweetedBy'] ?? '',
      repliedTo: map['repliedTo'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Tweet(text: $text, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, uid: $uid, tweetType: $tweetType, tweetedAt: $tweetedAt, favorites: $favorites, likes: $likes, commentIds: $commentIds, id: $id, reshareCount: $reshareCount, retweetedBy: $retweetedBy, repliedTo: $repliedTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Tweet &&
        other.text == text &&
        listEquals(other.hashtags, hashtags) &&
        other.link == link &&
        listEquals(other.imageLinks, imageLinks) &&
        other.uid == uid &&
        other.tweetType == tweetType &&
        other.tweetTag == tweetTag &&
        other.tweetedAt == tweetedAt &&
        listEquals(other.favorites, favorites) &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.location == location &&
        other.id == id &&
        other.views == views &&
        other.reshareCount == reshareCount &&
        other.retweetedBy == retweetedBy &&
        other.repliedTo == repliedTo;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hashtags.hashCode ^
        link.hashCode ^
        imageLinks.hashCode ^
        uid.hashCode ^
        tweetType.hashCode ^
        tweetTag.hashCode ^
        tweetedAt.hashCode ^
        favorites.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        location.hashCode ^
        id.hashCode ^
        views.hashCode ^
        reshareCount.hashCode ^
        retweetedBy.hashCode ^
        repliedTo.hashCode;
  }
}
