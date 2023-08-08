import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/common/common.dart';
import 'package:courtfinder/constants/appwrite_constants.dart';
import 'package:courtfinder/features/tweet/controller/tweet_controller.dart';
import 'package:courtfinder/features/tweet/widgets/tweet_card.dart';
import 'package:courtfinder/models/tweet_model.dart';
import 'package:courtfinder/theme/pallete.dart';

class TwitterReplyScreen extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(
        builder: (context) => TwitterReplyScreen(tweet: tweet),
      );
  final Tweet tweet;
  const TwitterReplyScreen({
    super.key,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Tweet',
            style: TextStyle(color: Pallete.blackColor),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Pallete.blackColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          )),
      body: Column(
        children: [
          TweetCard(
            tweet: tweet,
            showActions: true,
          ),
          ref.watch(getRepliesToTweetsProvider(tweet)).when(
                data: (tweets) {
                  return ref.watch(getLatestTweetProvider).when(
                        data: (data) {
                          final latestTweet = Tweet.fromMap(data.payload);

                          bool isTweetAlreadyPresent = false;
                          for (final tweetModel in tweets) {
                            if (tweetModel.id == latestTweet.id) {
                              isTweetAlreadyPresent = true;
                              break;
                            }
                          }

                          if (!isTweetAlreadyPresent && latestTweet.repliedTo == tweet.id) {
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
                          }

                          return Expanded(
                            child: ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: (BuildContext context, int index) {
                                final tweet = tweets[index];
                                return TweetCard(tweet: tweet, showActions: true);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: (BuildContext context, int index) {
                                final tweet = tweets[index];
                                return TweetCard(tweet: tweet, showActions: true);
                              },
                            ),
                          );
                        },
                      );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
        child: TextField(
          onSubmitted: (value) {
            // share tweet that is replying to another tweet
            ref.read(tweetControllerProvider.notifier).shareTweet(
              images: [],
              text: value,
              context: context,
              repliedTo: tweet.id,
              repliedToUserId: tweet.uid,
              originalTweet: tweet,
            );
          },
          decoration: InputDecoration(
              hintText: 'Tweet your reply',
              fillColor: Pallete.lightGreyColor,
              filled: true,
              hintStyle: const TextStyle(color: Pallete.blackColor),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Pallete.orangeColor)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Pallete.orangeColor, width: 2),
              )),
          style: const TextStyle(color: Colors.black), // Set text color
        ),
      ),
    );
  }
}
