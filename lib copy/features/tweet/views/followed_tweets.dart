// Tweets from users that the current user follows
import 'package:courtfinder/common/error_page.dart';
import 'package:courtfinder/common/loading_page.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/tweet/controller/tweet_controller.dart';
import 'package:courtfinder/features/tweet/widgets/tweet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowedTweetList extends ConsumerWidget {
  const FollowedTweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    Future<void> onRefresh() async {
      if (currentUser != null) {
        ref.refresh(getFollowedUsersTweetsProvider(currentUser.following));
      }
    }

    return Scaffold(
      body: currentUser == null
          ? const Loader()
          : RefreshIndicator(
              onRefresh: onRefresh,
              child: ref.watch(getFollowedUsersTweetsProvider(currentUser.following)).when(
                    data: (tweets) {
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
                    error: (error, stackTrace) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
            ),
    );
  }
}
