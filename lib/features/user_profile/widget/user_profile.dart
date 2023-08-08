import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:courtfinder/common/error_page.dart';
import 'package:courtfinder/common/loading_page.dart';

import 'package:courtfinder/core/utils.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/home/widgets/side_drawer.dart';
import 'package:courtfinder/features/tweet/widgets/tweet_card.dart';
import 'package:courtfinder/features/user_profile/controller/user_profile_controller.dart';
import 'package:courtfinder/features/user_profile/view/edit_profile_view.dart';
import 'package:courtfinder/features/user_profile/view/followers.dart';
import 'package:courtfinder/features/user_profile/view/following.dart';

import 'package:courtfinder/models/user_model.dart';
import 'package:courtfinder/theme/pallete.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    void unfinishedParts() {
      showSnackBar(context, "功能暂未开放");
    }

    void navigateToFollowersList() {
      Navigator.push(context, FollowersView.route());
    }

    void navigateToFollowingList() {
      Navigator.push(context, FollowingView.route());
    }

    return currentUser == null
        ? const Loader()
        : Scaffold(
            endDrawer: const SideDrawer(),
            appBar: MyAppBar(
              title: user.name,
              backButton: currentUser.uid == user.uid ? true : false,
              settingsButton: currentUser.uid == user.uid ? true : false,
              context: context,
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Column(
                            children: [
                              SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: user.bannerPic.isEmpty
                                          ? Container(color: Pallete.orangeColor)
                                          : Image.network(
                                              user.bannerPic,
                                              fit: BoxFit.fitWidth,
                                            ),
                                    ),
                                    Container(
                                      height: 225,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        gradient: LinearGradient(
                                          begin: FractionalOffset.topCenter,
                                          end: FractionalOffset.bottomCenter,
                                          colors: [
                                            Colors.grey.withOpacity(0.0),
                                            Colors.black,
                                          ],
                                          stops: const [0.0, 1.0],
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Center(
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(user.profilePic),
                                          radius: 60,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                // width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        if (currentUser.uid == user.uid) {
                                          // edit profile
                                          Navigator.push(context, EditProfileView.route(user));
                                        } else {
                                          ref
                                              .read(userProfileControllerProvider.notifier)
                                              .followUser(user: user, context: context, currentUser: currentUser);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(100, 35),
                                        backgroundColor: Pallete.orangeColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                          side: const BorderSide(color: Pallete.whiteColor),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 25),
                                      ),
                                      child: Text(
                                        currentUser.uid == user.uid
                                            ? '修改信息'
                                            : currentUser.following.contains(user.uid)
                                                ? '取消关注'
                                                : '关注',
                                        style: const TextStyle(
                                          color: Pallete.blackColor,
                                        ),
                                      ),
                                    ),
                                    currentUser.uid != user.uid
                                        ? OutlinedButton(
                                            onPressed: () {
                                              print("Block User");
                                              ref
                                                  .read(userProfileControllerProvider.notifier)
                                                  .blockUser(user: user, context: context, currentUser: currentUser);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(100, 35),
                                              backgroundColor: Colors.red[200],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                                side: const BorderSide(
                                                  color: Pallete.whiteColor,
                                                ),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 25),
                                            ),
                                            child: Text(
                                              currentUser.blocked.contains(user.uid) ? '取消屏蔽' : '屏蔽用户',
                                              style: const TextStyle(color: Pallete.blackColor),
                                            ),
                                          )
                                        : null,
                                  ].where((widget) => widget != null).map((widget) {
                                    return Expanded(
                                        child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 5),
                                      child: widget!,
                                    ));
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    UserMediaStatsText(
                                        count: user.followers.length, label: '粉丝', onTap: navigateToFollowersList),
                                    UserMediaStatsText(
                                        count: user.following.length, label: '关注', onTap: navigateToFollowingList),
                                    UserMediaStatsText(count: 0, label: '点赞', onTap: unfinishedParts),
                                    UserMediaStatsText(count: 0, label: '发布', onTap: unfinishedParts),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                width: double.infinity,
                                color: Pallete.lightGreyColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                          fontSize: 25, fontWeight: FontWeight.bold, color: Pallete.blackColor),
                                    ),
                                    Text(
                                      '@${user.name}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Pallete.greyColor,
                                      ),
                                    ),
                                    Text(
                                      user.bio,
                                      style: const TextStyle(fontSize: 17, color: Pallete.blackColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ];
              },
              body: ref.watch(getUserTweetsProvider(user.uid)).when(
                    data: (tweets) {
                      // can make it realtime by copying code
                      // from twitter_reply_view

                      return ListView.builder(
                        itemCount: tweets.length,
                        itemBuilder: (BuildContext context, int index) {
                          final tweet = tweets[index];
                          return TweetCard(
                            tweet: tweet,
                            showActions: false,
                          );
                        },
                      );
                    },
                    error: (error, st) => ErrorText(error: error.toString()),
                    loading: () => const Loader(),
                  ),
            ),
          );
  }
}

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool backButton;
  final bool settingsButton;
  final BuildContext context;
  const MyAppBar(
      {super.key, required this.title, required this.backButton, required this.settingsButton, required this.context});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: !backButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Pallete.blackColor,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(color: Pallete.blackColor),
      ),
      actions: settingsButton
          ? [
              IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(Icons.settings, color: Pallete.blackColor),
              )
            ]
          : [],
      centerTitle: true,
    );
  }
}

class UserMediaStatsText extends StatelessWidget {
  final int count;
  final String label;
  final VoidCallback onTap;
  const UserMediaStatsText({
    Key? key,
    required this.count,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = 18;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(
            '$count',
            style: TextStyle(
              color: Pallete.blackColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: Pallete.greyColor,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
