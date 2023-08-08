import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:courtfinder/common/error_page.dart';
import 'package:courtfinder/common/loading_page.dart';
import 'package:courtfinder/constants/constants.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/home/widgets/side_drawer.dart';
import 'package:courtfinder/features/tweet/widgets/tweet_card.dart';
import 'package:courtfinder/features/user_profile/controller/user_profile_controller.dart';
import 'package:courtfinder/features/user_profile/view/edit_profile_view.dart';
import 'package:courtfinder/features/user_profile/widget/follow_count.dart';
import 'package:courtfinder/models/user_model.dart';
import 'package:courtfinder/theme/pallete.dart';

class UserProfileOld extends ConsumerWidget {
  final UserModel user;
  const UserProfileOld({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    // TODO: Incorporate live updates to user profile tweet list

    return currentUser == null
        ? const Loader()
        : Scaffold(
            endDrawer: const SideDrawer(),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    actions: [
                      Ink(
                        decoration: ShapeDecoration(
                          color: Colors.black.withOpacity(0.45),
                          shape: const CircleBorder(),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          icon: const Icon(Icons.menu),
                        ),
                      ),
                    ],
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: user.bannerPic.isEmpty
                              ? Container(color: Pallete.orangeColor)
                              : Image.network(user.bannerPic, fit: BoxFit.fitWidth),
                        ),
                        Align(
                          alignment: const Alignment(-1, 1),
                          // bottom: 0,
                          // left: 0,
                          // right: 0,
                          // child: Container(
                          //   margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          //   height: 100,
                          //   width: 100,
                          //   decoration: BoxDecoration(
                          //     color: Colors.grey[300],
                          //     borderRadius: BorderRadius.circular(20),
                          //   ),
                          //   child: Image(
                          //     image: NetworkImage(user.profilePic),
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePic),
                            radius: 45,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          margin: const EdgeInsets.all(20),
                          child: OutlinedButton(
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
                              backgroundColor: Pallete.orangeColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: Pallete.whiteColor,
                                ),
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
                        ),
                        // Container(
                        //   // alignment: Alignment.center,
                        //   child: const Text(
                        //     "Posts",
                        //     style: TextStyle(color: Pallete.blackColor),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  // User Information
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Row(
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold, color: Pallete.blackColor),
                              ),
                              if (user.isTwitterBlue)
                                Padding(
                                  padding: const EdgeInsets.only(left: 3.0),
                                  child: SvgPicture.asset(
                                    AssetsConstants.verifiedIcon,
                                  ),
                                ),
                            ],
                          ),
                          Text(
                            '@${user.name}',
                            style: const TextStyle(
                              fontSize: 17,
                              color: Pallete.greyColor,
                            ),
                          ),
                          Text(
                            user.bio,
                            style: const TextStyle(fontSize: 17, color: Pallete.blackColor),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              FollowCount(
                                count: user.following.length,
                                text: 'Following',
                              ),
                              const SizedBox(width: 15),
                              FollowCount(
                                count: user.followers.length,
                                text: 'Followers',
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Container(
                            alignment: Alignment.center,
                            child: const Text(
                              "Posts",
                              style: TextStyle(color: Pallete.blackColor, fontSize: 20),
                            ),
                          ),
                          const Divider(color: Pallete.blackColor),
                        ],
                      ),
                    ),
                  ),
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
                            showActions: true,
                          );
                        },
                      );
                    },
                    error: (error, st) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
            ),
          );
  }
}
