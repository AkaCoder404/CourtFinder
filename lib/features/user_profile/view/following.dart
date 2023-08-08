// View to display the list of people a user is following

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/core/utils.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/messages/controller/message_controller.dart';
import 'package:courtfinder/theme/pallete.dart';

class FollowingView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const FollowingView());
  const FollowingView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FollowingViewState();
}

class _FollowingViewState extends ConsumerState<FollowingView> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Pallete.blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "关注",
          style: TextStyle(color: Pallete.blackColor),
        ),
        centerTitle: true,
      ),
      body: currentUser != null
          ? ListView.builder(
              itemCount: currentUser.following.length,
              itemBuilder: (BuildContext context, int index) {
                final following = currentUser.following[index];
                return FollowersTile(userId: following);
              },
            )
          : const SizedBox(
              height: double.infinity, width: double.infinity, child: Center(child: CircularProgressIndicator())),
    );
  }
}

class FollowersTile extends ConsumerWidget {
  final String userId;
  const FollowersTile({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(getUserDetailsProvider(userId)).value;
    // TODO - Add onTap to navigate to user profile
    // TODO - Update list of followers when another user follows/unfollows
    return user != null
        ? ListTile(
            onTap: () {
              showSnackBar(context, "功能暂未开放");
            },
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image(
                image: NetworkImage(user.profilePic),
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              user.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Pallete.blackColor),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${user.name}', style: const TextStyle(fontSize: 16, color: Pallete.blackColor)),
                // Text(
                //   user.bio,
                //   style: const TextStyle(
                //     color: Pallete.blackColor,
                //   ),
                // ),
              ],
            ),
          )
        : const Center(
            child: CircularProgressIndicator(
            strokeWidth: 2,
          ));
  }
}
