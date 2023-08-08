import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/common/common.dart';
import 'package:courtfinder/common/error_page.dart';
import 'package:courtfinder/constants/constants.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/user_profile/controller/user_profile_controller.dart';
import 'package:courtfinder/features/user_profile/widget/user_profile.dart';
import 'package:courtfinder/models/user_model.dart';

class UserProfileView extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
        builder: (context) => UserProfileView(
          userModel: userModel,
        ),
      );
  final UserModel userModel;
  const UserProfileView({
    super.key,
    this.userModel = const UserModel(
      email: '',
      name: '',
      followers: [],
      following: [],
      blocked: [],
      profilePic: '',
      bannerPic: '',
      uid: '',
      bio: '',
      favorites: [],
      chats: [],
      isTwitterBlue: false,
    ),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    UserModel copyOfUser;
    if (userModel.email.isEmpty && currentUser != null) {
      copyOfUser = currentUser;
    } else {
      copyOfUser = userModel;
    }
    print(copyOfUser);

    return Scaffold(
      body: ref.watch(getLatestUserProfileDataProvider).when(
            data: (data) {
              if (data.events.contains(
                'databases.*.collections.${AppwriteConstants.usersCollection}.documents.${copyOfUser.uid}.update',
              )) {
                copyOfUser = UserModel.fromMap(data.payload);
              }
              return UserProfile(user: copyOfUser);
            },
            error: (error, st) => ErrorText(
              error: error.toString(),
            ),
            loading: () {
              return UserProfile(user: copyOfUser);
            },
          ),
    );
  }
}
