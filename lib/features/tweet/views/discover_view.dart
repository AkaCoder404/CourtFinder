import 'package:courtfinder/features/tweet/views/followed_tweets.dart';
import 'package:courtfinder/features/tweet/views/search_tweet_view.dart';
import 'package:courtfinder/features/tweet/views/top_tweets.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:courtfinder/constants/constants.dart';
import 'package:courtfinder/features/notifications/views/notification_view.dart';
import 'package:courtfinder/features/tweet/widgets/tweet_list.dart';
import 'package:courtfinder/theme/pallete.dart';
import 'package:courtfinder/core/other_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  @override
  _DiscoverViewState createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

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
      key: _key, // assign key to Scaffold
      appBar: AppBar(
        title: SvgPicture.asset(AssetsConstants.courtFinderLogo, height: 50),
        leading: IconButton(
            icon: const Icon(Icons.sort, color: Colors.black),
            color: Colors.black,
            onPressed: () => _key.currentState!.openDrawer()),
        actions: [
          IconButton(
              icon: const Icon(Icons.search, color: Pallete.blackColor),
              onPressed: () => Navigator.push(context, SearchTweetView.route())),
          IconButton(
              icon: const Icon(Icons.notifications),
              color: Pallete.blackColor,
              onPressed: () => Navigator.push(context, NotificationView.route())),
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
      drawer: const DiscoverSideBar(),
      body: TabBarView(
        controller: _tabController,
        children: const [TweetList(), FollowedTweetList(), TopTweetList()],
      ),
    );
  }
}

class DiscoverSideBar extends ConsumerWidget {
  const DiscoverSideBar({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _DiscoverSideBarState();
// }

// class _DiscoverSideBarState extends ConsumerState<DiscoverSideBar> {
  final sortDescending = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedValues = ref.watch(selectedValuesProvider);
    final sortTweetsTime = ref.watch(sortTweetsTimeProvider);
    final sortTweetsLikes = ref.watch(sortTweetsLikesProvider);
    final sortTweetsComments = ref.watch(sortTweetsCommentsProvider);
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // const DrawerHeader(
            //   decoration: BoxDecoration(color: Colors.orange),
            //   child: Text('Drawer Header'),
            // ),
            const ListTile(
              title: Text(
                '发布排序',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SwitchListTile(
              activeColor: Colors.orange,
              title: const Text('时间排序', style: TextStyle(color: Colors.black, fontSize: 20)),
              subtitle: sortTweetsTime
                  ? const Text('降序', style: TextStyle(fontSize: 18))
                  : const Text('升序', style: TextStyle(fontSize: 18)),
              value: ref.read(sortTweetsTimeProvider.notifier).state, // replace with your own value
              onChanged: (value) {
                ref.read(sortTweetsTimeProvider.notifier).state = value;
              },
              secondary: const Icon(Icons.calendar_today),
            ),
            SwitchListTile(
              activeColor: Colors.orange,
              title: const Text('点赞排序', style: TextStyle(color: Colors.black, fontSize: 20)),
              subtitle: sortTweetsLikes
                  ? const Text('降序', style: TextStyle(fontSize: 18))
                  : const Text('升序', style: TextStyle(fontSize: 18)),
              value: sortTweetsLikes, // replace with your own value
              onChanged: (value) {
                ref.read(sortTweetsLikesProvider.notifier).state = value;
              },
              secondary: const Icon(Icons.favorite),
            ),
            SwitchListTile(
              activeColor: Colors.orange,
              title: const Text('评论排序', style: TextStyle(color: Colors.black, fontSize: 20)),
              subtitle: sortTweetsComments
                  ? const Text('降序', style: TextStyle(fontSize: 18))
                  : const Text('升序', style: TextStyle(fontSize: 18)),
              value: sortTweetsComments, // replace with your own value
              onChanged: (value) {
                ref.read(sortTweetsCommentsProvider.notifier).state = value;
              },
              secondary: const Icon(Icons.comment),
            ),
            const ListTile(
              title: Text(
                '发布类型',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListTile(
              title: const Text('普通发布', style: TextStyle(color: Colors.black, fontSize: 20)),
              leading: Checkbox(
                activeColor: Colors.orange,
                value: selectedValues.contains('普通发布'),
                onChanged: (value) {
                  final newSelectedOptions = Set.of(selectedValues);
                  if (value!) {
                    newSelectedOptions.add('普通发布');
                  } else {
                    newSelectedOptions.remove('普通发布');
                  }
                  print(newSelectedOptions);
                  ref.read(selectedValuesProvider.notifier).state = newSelectedOptions;
                },
              ),
            ),
            ListTile(
              title: const Text('装备推荐', style: TextStyle(color: Colors.black, fontSize: 20)),
              leading: Checkbox(
                activeColor: Colors.orange,
                value: selectedValues.contains('装备推荐'),
                onChanged: (value) {
                  print("Handle $value");
                  final newSelectedOptions = Set.of(selectedValues);
                  if (value!) {
                    newSelectedOptions.add('装备推荐');
                  } else {
                    newSelectedOptions.remove('装备推荐');
                  }
                  ref.read(selectedValuesProvider.notifier).state = newSelectedOptions;
                },
              ),
            ),
            ListTile(
              title: const Text('赛事推广', style: TextStyle(color: Colors.black, fontSize: 20)),
              leading: Checkbox(
                activeColor: Colors.orange,
                value: selectedValues.contains('赛事推广'),
                onChanged: (value) {
                  final newSelectedOptions = Set.of(selectedValues);
                  if (value!) {
                    newSelectedOptions.add('赛事推广');
                  } else {
                    newSelectedOptions.remove('赛事推广');
                  }
                  ref.read(selectedValuesProvider.notifier).state = newSelectedOptions;
                },
              ),
            ),
            ListTile(
              title: const Text('赛事结论', style: TextStyle(color: Colors.black, fontSize: 20)),
              leading: Checkbox(
                activeColor: Colors.orange,
                value: selectedValues.contains('赛事结论'),
                onChanged: (value) {
                  final newSelectedOptions = Set.of(selectedValues);
                  if (value!) {
                    newSelectedOptions.add('赛事结论');
                  } else {
                    newSelectedOptions.remove('赛事结论');
                  }
                  ref.read(selectedValuesProvider.notifier).state = newSelectedOptions;
                },
              ),
            ),
            ListTile(
              title: const Text('场地评论', style: TextStyle(color: Colors.black, fontSize: 20)),
              leading: Checkbox(
                activeColor: Colors.orange,
                value: selectedValues.contains('场地评论'),
                onChanged: (value) {
                  final newSelectedOptions = Set.of(selectedValues);
                  if (value!) {
                    newSelectedOptions.add('场地评论');
                  } else {
                    newSelectedOptions.remove('场地评论');
                  }
                  ref.read(selectedValuesProvider.notifier).state = newSelectedOptions;
                },
              ),
            ),
            ListTile(
              title: const Text('找人找队', style: TextStyle(color: Colors.black, fontSize: 20)),
              leading: Checkbox(
                activeColor: Colors.orange,
                value: selectedValues.contains('找人找队'),
                onChanged: (value) {
                  final newSelectedOptions = Set.of(selectedValues);
                  if (value!) {
                    newSelectedOptions.add('找人找队');
                  } else {
                    newSelectedOptions.remove('找人找队');
                  }
                  ref.read(selectedValuesProvider.notifier).state = newSelectedOptions;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
