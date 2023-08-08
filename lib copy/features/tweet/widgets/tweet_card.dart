import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:like_button/like_button.dart';
import 'package:courtfinder/common/common.dart';
import 'package:courtfinder/constants/assets_constants.dart';
import 'package:courtfinder/core/enums/tweet_type_enum.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/tweet/controller/tweet_controller.dart';
import 'package:courtfinder/features/tweet/views/twitter_reply_view.dart';
import 'package:courtfinder/features/tweet/widgets/carousel_image.dart';
import 'package:courtfinder/features/tweet/widgets/hashtag_text.dart';
import 'package:courtfinder/features/user_profile/controller/user_profile_controller.dart';
import 'package:courtfinder/features/user_profile/view/user_profile_view.dart';
import 'package:courtfinder/models/tweet_model.dart';
import 'package:courtfinder/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:share/share.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  final bool showActions;
  // final bool canTap; // Prevent tapping on tweet card when already on tweet view
  const TweetCard({
    super.key,
    required this.showActions,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    void onShareSocialMedia() {
      // Also share links to images if any
      String share_text = tweet.text;
      for (var imageLink in tweet.imageLinks) {
        share_text += '\n + $imageLink';
      }
      Share.share(share_text);
    }

    final styleSheet = MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        h1: const TextStyle(color: Colors.red),
        h2: const TextStyle(color: Colors.green),
        h3: const TextStyle(color: Colors.blue),
        a: const TextStyle(color: Colors.purple, decorationColor: Colors.purple),
        code: const TextStyle(color: Colors.orange),
        p: const TextStyle(color: Colors.black),
        em: const TextStyle(color: Colors.blue),
        strong: const TextStyle(color: Colors.black),
        listBullet: const TextStyle(color: Colors.black));

    // Widget getIfRetweet() { }
    // Widget getIfRepliedTo() { }

    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(tweet.uid)).when(
              data: (user) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      TwitterReplyScreen.route(tweet),
                    );
                  },
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  UserProfileView.route(user),
                                );
                              },
                              child: Container(
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
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (tweet.retweetedBy.isNotEmpty)
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AssetsConstants.retweetIcon,
                                        color: Pallete.blackColor,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${tweet.retweetedBy} retweeted',
                                        style: const TextStyle(
                                          color: Pallete.blackColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        right: user.isTwitterBlue ? 1 : 5,
                                      ),
                                      child: Text(
                                        user.name,
                                        style: const TextStyle(
                                          color: Pallete.blackColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ),
                                    if (user.isTwitterBlue)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 5.0),
                                        child: SvgPicture.asset(
                                          AssetsConstants.verifiedIcon,
                                        ),
                                      ),
                                    Text(
                                      '@${user.name} · ${timeago.format(
                                        tweet.tweetedAt,
                                        locale: 'en_short',
                                      )}',
                                      style: const TextStyle(
                                        color: Pallete.blackColor,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                                if (tweet.repliedTo.isNotEmpty)
                                  ref.watch(getTweetByIdProvider(tweet.repliedTo)).when(
                                        data: (repliedToTweet) {
                                          final replyingToUser =
                                              ref.watch(userDetailsProvider(repliedToTweet.uid)).value;
                                          return RichText(
                                            text: TextSpan(
                                              text: 'Replying to',
                                              style: const TextStyle(color: Pallete.blackColor, fontSize: 16),
                                              children: [
                                                TextSpan(
                                                  text: ' @${replyingToUser?.name}',
                                                  style: const TextStyle(
                                                    color: Pallete.blueColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        error: (error, st) => ErrorText(
                                          error: error.toString(),
                                        ),
                                        loading: () => const SizedBox(),
                                      ),
                                // Container(
                                //   height: 100,
                                //   child: Markdown(
                                //     data: tweet.text,
                                //     styleSheet: styleSheet,
                                //   ),
                                // ),
                                HashtagText(text: tweet.text),
                                if (tweet.tweetType == TweetType.image) CarouselImage(imageLinks: tweet.imageLinks),
                                if (tweet.link.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  AnyLinkPreview(
                                    displayDirection: UIDirection.uiDirectionHorizontal,
                                    link: 'https://${tweet.link}',
                                  ),
                                ],
                                showActions
                                    ? Container(
                                        margin: const EdgeInsets.only(top: 10, right: 20),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Views
                                            TweetIconButton(
                                              icon: const Icon(Icons.stacked_bar_chart, color: Pallete.greyColor),
                                              label: (tweet.commentIds.length +
                                                      tweet.reshareCount +
                                                      tweet.likes.length +
                                                      tweet.favorites.length)
                                                  .toString(),
                                              onTap: () {},
                                            ),
                                            // Comments
                                            TweetIconButton(
                                              icon: const Icon(Icons.comment, color: Pallete.greyColor),
                                              label: tweet.commentIds.length.toString(),
                                              onTap: () {},
                                            ),
                                            // Retweets
                                            TweetIconButton(
                                              icon: const Icon(Icons.repeat, color: Pallete.greyColor),
                                              label: tweet.reshareCount.toString(),
                                              onTap: () {
                                                ref.read(tweetControllerProvider.notifier).reshareTweet(
                                                      tweet,
                                                      currentUser,
                                                      context,
                                                    );
                                              },
                                            ),
                                            // Favorite tweet button
                                            TweetIconButton(
                                              icon: const Icon(Icons.star, color: Pallete.greyColor),
                                              label: tweet.favorites.length.toString(),
                                              onTap: () {
                                                // Update the tweet favorite list
                                                ref
                                                    .read(tweetControllerProvider.notifier)
                                                    .favoriteTweet(tweet, currentUser, context);
                                                // Update the user favorite list
                                                ref
                                                    .read(userProfileControllerProvider.notifier)
                                                    .favoriteTweet(tweet, currentUser, context);
                                              },
                                            ),
                                            // Like tweet button
                                            LikeButton(
                                              size: 25,
                                              onTap: (isLiked) async {
                                                ref
                                                    .read(tweetControllerProvider.notifier)
                                                    .likeTweet(tweet, currentUser);
                                                return !isLiked;
                                              },
                                              isLiked: tweet.likes.contains(currentUser.uid),
                                              likeBuilder: (isLiked) {
                                                return isLiked
                                                    ? SvgPicture.asset(
                                                        AssetsConstants.likeFilledIcon,
                                                        color: Pallete.redColor,
                                                      )
                                                    : SvgPicture.asset(
                                                        AssetsConstants.likeOutlinedIcon,
                                                        color: Pallete.greyColor,
                                                      );
                                              },
                                              likeCount: tweet.likes.length,
                                              countBuilder: (likeCount, isLiked, text) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(left: 2.0),
                                                  child: Text(
                                                    text,
                                                    style: TextStyle(
                                                      color: isLiked ? Pallete.redColor : Pallete.blackColor,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            // Share button
                                            IconButton(
                                              onPressed: onShareSocialMedia,
                                              icon: const Icon(
                                                Icons.share_outlined,
                                                size: 25,
                                                color: Pallete.greyColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(height: 10),
                                const SizedBox(height: 1),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Pallete.blackColor, height: 0.5),
                      const SizedBox(height: 10)
                    ],
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            );
  }
}

class TweetIconButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final VoidCallback onTap;
  const TweetIconButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon.icon, color: Pallete.greyColor, size: 25),
          Container(
            margin: const EdgeInsets.all(6),
            child: Text(label, style: const TextStyle(color: Pallete.greyColor, fontSize: 16)),
          )
        ],
      ),
    );
  }
}
