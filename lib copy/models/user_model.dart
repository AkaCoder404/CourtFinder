import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String email;
  final String name;
  final List<String> followers;
  final List<String> following;
  final String profilePic;
  final String bannerPic;
  final String uid;
  final String bio;
  final List<String> favorites;
  final List<String> chats;
  final bool isTwitterBlue;
  const UserModel({
    required this.email,
    required this.name,
    required this.followers,
    required this.following,
    required this.profilePic,
    required this.bannerPic,
    required this.uid,
    required this.bio,
    required this.favorites,
    required this.chats,
    required this.isTwitterBlue,
  });

  // Allows us to modify the (immutable) user model without changing the reference
  UserModel copyWith({
    String? email,
    String? name,
    List<String>? followers,
    List<String>? following,
    String? profilePic,
    String? bannerPic,
    String? uid,
    String? bio,
    List<String>? favorites,
    List<String>? chats,
    bool? isTwitterBlue,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      uid: uid ?? this.uid,
      bio: bio ?? this.bio,
      favorites: favorites ?? this.favorites,
      chats: chats ?? this.chats,
      isTwitterBlue: isTwitterBlue ?? this.isTwitterBlue,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'name': name});
    result.addAll({'followers': followers});
    result.addAll({'following': following});
    result.addAll({'profilePic': profilePic});
    result.addAll({'bannerPic': bannerPic});
    result.addAll({'bio': bio});
    result.addAll({'favorites': favorites});
    result.addAll({'chats': chats});
    result.addAll({'isTwitterBlue': isTwitterBlue});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      followers: List<String>.from(map['followers']),
      following: List<String>.from(map['following']),
      profilePic: map['profilePic'] ?? '',
      bannerPic: map['bannerPic'] ?? '',
      uid: map['\$id'] ?? '',
      bio: map['bio'] ?? '',
      favorites: List<String>.from(map['favorites']),
      chats: List<String>.from(map['chats']),
      isTwitterBlue: map['isTwitterBlue'] ?? false,
    );
  }

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, followers: $followers, following: $following, profilePic: $profilePic, bannerPic: $bannerPic, uid: $uid, bio: $bio, favorites: $favorites, chats: $chats, isTwitterBlue: $isTwitterBlue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.email == email &&
        other.name == name &&
        listEquals(other.followers, followers) &&
        listEquals(other.following, following) &&
        other.profilePic == profilePic &&
        other.bannerPic == bannerPic &&
        other.uid == uid &&
        other.bio == bio &&
        listEquals(other.favorites, favorites) &&
        listEquals(other.chats, chats) &&
        other.isTwitterBlue == isTwitterBlue;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        profilePic.hashCode ^
        bannerPic.hashCode ^
        uid.hashCode ^
        bio.hashCode ^
        favorites.hashCode ^
        chats.hashCode ^
        isTwitterBlue.hashCode;
  }
}
