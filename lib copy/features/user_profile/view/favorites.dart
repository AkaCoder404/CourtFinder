// View a list of favorited tweets

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/common/error_page.dart';
import 'package:courtfinder/core/utils.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/tweet/controller/tweet_controller.dart';
import 'package:courtfinder/features/tweet/views/twitter_reply_view.dart';
import 'package:courtfinder/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;

class FavoritesView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const FavoritesView());
  const FavoritesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends ConsumerState<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("收藏", style: TextStyle(color: Pallete.blackColor)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Pallete.blackColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
      ),
      body: currentUser == null
          ? const SizedBox(
              height: double.infinity, width: double.infinity, child: Center(child: CircularProgressIndicator()))
          : ListView.builder(
              itemCount: currentUser.favorites.length,
              itemBuilder: (BuildContext context, int index) {
                final tweetId = currentUser.favorites[index];
                return FavoritesTile(tweetId: tweetId);
              },
            ),
    );
  }
}

class FavoritesTile extends ConsumerWidget {
  final String tweetId;
  const FavoritesTile({super.key, required this.tweetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweet = ref.watch(getTweetByIdProvider(tweetId)).value!;
    return tweet == null
        ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
        : ref.watch(userDetailsProvider(tweet.uid)).when(
              data: (user_info) {
                return ListTile(
                  onTap: () {
                    TwitterReplyScreen.route(tweet);
                  },
                  subtitle: Text(tweet.text, style: const TextStyle(color: Pallete.blackColor)),
                  title: Row(
                    children: [
                      Text(user_info.name,
                          style: const TextStyle(color: Pallete.blackColor, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 5),
                      Text("@${timeago.format(tweet.tweetedAt, locale: 'en_short')}",
                          style: const TextStyle(color: Pallete.greyColor)),
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
  }
}
