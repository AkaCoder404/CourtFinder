import 'package:courtfinder/features/tweet/views/followed_tweets.dart';
import 'package:courtfinder/features/tweet/views/top_tweets.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:courtfinder/constants/constants.dart';
import 'package:courtfinder/features/notifications/views/notification_view.dart';
import 'package:courtfinder/features/tweet/widgets/tweet_list.dart';
import 'package:courtfinder/theme/pallete.dart';

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  @override
  _DiscoverViewState createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3); // Set the number of tabs here
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          AssetsConstants.courtFinderLogo,
          height: 50,
        ),
        leading: IconButton(
          icon: const Icon(Icons.sort, color: Pallete.blackColor),
          color: Pallete.blackColor,
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Pallete.blackColor,
            onPressed: () {
              Navigator.push(context, NotificationView.route());
            },
          ),
        ],
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Pallete.orangeColor,
          tabs: const [
            Tab(child: Text("发现", style: TextStyle(color: Pallete.blackColor))),
            Tab(child: Text("关注", style: TextStyle(color: Pallete.blackColor))),
            Tab(child: Text("热榜", style: TextStyle(color: Pallete.blackColor))),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [TweetList(), FollowedTweetList(), TopTweetList()],
      ),
    );
  }
}
