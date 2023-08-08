import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/common/common.dart';
import 'package:courtfinder/features/tweet/controller/tweet_controller.dart';
import 'package:courtfinder/features/tweet/widgets/tweet_card.dart';
import 'package:courtfinder/theme/pallete.dart';

class HashtagView extends ConsumerWidget {
  static route(String hashtag) => MaterialPageRoute(
        builder: (context) => HashtagView(
          hashtag: hashtag,
        ),
      );
  final String hashtag;
  const HashtagView({
    super.key,
    required this.hashtag,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        title: Text(
          'Hashtag $hashtag',
          style: const TextStyle(color: Pallete.blackColor),
        ),
      ),
      body: ref.watch(getTweetsByHashtagProvider(hashtag)).when(
            data: (tweets) {
              print('hashTags: $tweets');
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
    );
  }
}
