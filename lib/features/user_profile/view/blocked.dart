// View to display the list of blocked users

import 'package:courtfinder/features/user_profile/view/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/messages/controller/message_controller.dart';
import 'package:courtfinder/theme/pallete.dart';

class BlockedUsersView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlockedUsersView());
  const BlockedUsersView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlockedUsersViewState();
}

class _BlockedUsersViewState extends ConsumerState<BlockedUsersView> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Pallete.blackColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("屏蔽用户", style: TextStyle(color: Pallete.blackColor)),
        centerTitle: true,
      ),
      body: currentUser != null
          ? ListView.builder(
              itemCount: currentUser.blocked.length,
              itemBuilder: (BuildContext context, int index) {
                final follower = currentUser.blocked[index];
                return BlockedUsersTile(userId: follower);
              },
            )
          : const SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }
}

class BlockedUsersTile extends ConsumerWidget {
  final String userId;
  const BlockedUsersTile({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(getUserDetailsProvider(userId)).value;
    // TODO - Update list of BlockedUsers when another user follows/unfollows
    return user != null
        ? ListTile(
            onTap: () {
              Navigator.push(context, UserProfileView.route(user));
            },
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image(image: NetworkImage(user.profilePic), fit: BoxFit.cover),
            ),
            title: Text(
              user.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Pallete.blackColor),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${user.name}', style: const TextStyle(fontSize: 16, color: Pallete.blackColor)),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator(strokeWidth: 2));
  }
}
