// 推文热榜列表

import 'package:courtfinder/common/error_page.dart';
import 'package:courtfinder/common/loading_page.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/tweet/controller/tweet_controller.dart';
import 'package:courtfinder/features/tweet/widgets/tweet_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopTweetList extends ConsumerWidget {
  const TopTweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    Future<void> onRefresh() async {
      if (currentUser != null) {
        ref.refresh(getTopTweetsProvider).value;
      }
    }

    return Scaffold(
      body: currentUser == null
          ? const Loader()
          : RefreshIndicator(
              onRefresh: onRefresh,
              child: ref.watch(getTopTweetsProvider).when(
                    data: (tweets) {
                      return ListView.builder(
                        itemCount: tweets.length,
                        itemBuilder: (BuildContext context, int index) {
                          final tweet = tweets[index];

                          // TODO Temporary fix to not show tweets from blocked users
                          if (currentUser.blocked.contains(tweet.uid)) {
                            return const SizedBox.shrink();
                          }

                          return TweetCard(tweet: tweet, showActions: true);
                        },
                      );
                    },
                    error: (error, stackTrace) => ErrorText(error: error.toString()),
                    loading: () => const Loader(),
                  ),
            ),
    );
  }
}
