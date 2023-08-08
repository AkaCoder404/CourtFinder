import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/common/error_page.dart';
import 'package:courtfinder/common/loading_page.dart';
import 'package:courtfinder/constants/appwrite_constants.dart';
import 'package:courtfinder/features/notifications/views/notification_view.dart';
import 'package:courtfinder/features/tweet/controller/tweet_controller.dart';
import 'package:courtfinder/features/tweet/widgets/tweet_card.dart';
import 'package:courtfinder/models/tweet_model.dart';
import 'package:courtfinder/constants/constants.dart';
import 'package:courtfinder/theme/pallete.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getTweetsProvider).when(
            data: (tweets) {
              return ref.watch(getLatestTweetProvider).when(
                    data: (data) {
                      // print(data);
                      // TODO Don't show tweets that are replies to other tweets?
                      if (data.events.contains(
                        'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
                      )) {
                        tweets.insert(0, Tweet.fromMap(data.payload));
                      } else if (data.events.contains(
                        'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
                      )) {
                        // get id of original tweet
                        final startingPoint = data.events[0].lastIndexOf('documents.');
                        final endPoint = data.events[0].lastIndexOf('.update');
                        final tweetId = data.events[0].substring(startingPoint + 10, endPoint);

                        var tweet = tweets.where((element) => element.id == tweetId).first;

                        final tweetIndex = tweets.indexOf(tweet);
                        tweets.removeWhere((element) => element.id == tweetId);

                        tweet = Tweet.fromMap(data.payload);
                        tweets.insert(tweetIndex, tweet);
                      }

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
                    loading: () {
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
                  );
            },
            error: (error, stackTrace) => ErrorText(
              error: error.toString(),
            ),
            loading: () => const Loader(),
          ),
    );
  }
}
