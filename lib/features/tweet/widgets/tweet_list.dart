import 'package:courtfinder/core/other_providers.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/common/error_page.dart';
import 'package:courtfinder/common/loading_page.dart';
import 'package:courtfinder/constants/appwrite_constants.dart';
import 'package:courtfinder/features/tweet/controller/tweet_controller.dart';
import 'package:courtfinder/features/tweet/widgets/tweet_card.dart';
import 'package:courtfinder/models/tweet_model.dart';
import 'package:courtfinder/constants/constants.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final showSelectedTweetTags = ref.watch(selectedValuesProvider);
    final sortTweetTime = ref.watch(sortTweetsTimeProvider);
    final sortTweetsLikes = ref.watch(sortTweetsLikesProvider);
    final sortTweetsComments = ref.watch(sortTweetsCommentsProvider);

    return currentUser != null
        ? Scaffold(
            body: ref.watch(getTweetsProvider).when(
                  data: (tweets) {
                    return ref.watch(getLatestTweetProvider).when(
                          data: (data) {
                            print("Updating tweets...");
                            // TODO Don't show tweets that are replies to other tweets?
                            if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
                            )) {
                              // don't add repeated tweets
                              if (!tweets.any((element) => element.id == Tweet.fromMap(data.payload).id)) {
                                tweets.insert(0, Tweet.fromMap(data.payload));
                              }
                            } else if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
                            )) {
                              print("Updating tweet...");
                              // get id of original tweet
                              final startingPoint = data.events[0].lastIndexOf('documents.');
                              final endPoint = data.events[0].lastIndexOf('.update');
                              final tweetId = data.events[0].substring(startingPoint + 10, endPoint);

                              var tweet = tweets.where((element) => element.id == tweetId).first;

                              final tweetIndex = tweets.indexOf(tweet);
                              tweets.removeWhere((element) => element.id == tweetId);

                              tweet = Tweet.fromMap(data.payload);

                              // don't insert repeated tweets
                              // if (tweetIndex == 0) {
                              //   tweets.insert(tweetIndex, tweet);
                              // } else {
                              //   tweets.insert(tweetIndex, tweet);
                              // }

                              tweets.insert(tweetIndex, tweet);
                            }

                            if (sortTweetTime) {
                              tweets = tweets.reversed.toList();
                            }

                            final newSelectedOptions = Set.of(showSelectedTweetTags);

                            return ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: (BuildContext context, int index) {
                                final tweet = tweets[index];

                                // TODO: Temporary fix for only showing tweets with selected tags
                                if (!newSelectedOptions.contains(tweet.tweetTag)) {
                                  return const SizedBox.shrink();
                                }
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
                          loading: () {
                            final newSelectedOptions = Set.of(showSelectedTweetTags);

                            // TODO: Sort tweets by time
                            if (sortTweetTime) {
                              tweets = tweets.reversed.toList();
                            }

                            // // Sort based on likes
                            // if (sortTweetsLikes) {
                            //   tweets.sort((a, b) => b.likes.length.compareTo(a.likes.length));
                            // } else {
                            //   // tweets.sort((a, b) => a.likes.length.compareTo(b.likes.length));
                            // }

                            // // Sort based on comments
                            // if (sortTweetsComments) {
                            //   tweets.sort((a, b) => b.commentIds.length.compareTo(a.commentIds.length));
                            // } else {
                            //   // tweets.sort((a, b) => a.commentIds.length.compareTo(b.commentIds.length));
                            // }

                            return ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: (BuildContext context, int index) {
                                final tweet = tweets[index];

                                // TODO: Temporary fix for not showing blocked users tweets
                                if (currentUser.blocked.contains(tweet.uid)) {
                                  return const SizedBox.shrink();
                                }

                                // TODO: Temporary fix for only showing tweets with selected tags
                                if (!newSelectedOptions.contains(tweet.tweetTag)) {
                                  return const SizedBox.shrink();
                                }

                                return TweetCard(
                                  tweet: tweet,
                                  showActions: true,
                                );
                              },
                            );
                          },
                        );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          )
        : const Loader();
  }
}
