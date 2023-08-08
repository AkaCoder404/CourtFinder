import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:courtfinder/constants/constants.dart';
import 'package:courtfinder/features/courts/views/new_court_view.dart';
import 'package:courtfinder/features/tweet/views/create_tweet_view.dart';
import 'package:courtfinder/features/courts/views/add_game_view.dart';
import 'package:courtfinder/theme/pallete.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomeView());
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;
  final appBar = UIConstants.appBar();

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  onCreateTweet() {
    Navigator.push(context, CreateTweetScreen.route());
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 28.0),
      backgroundColor: Pallete.orangeColor,
      visible: true,
      curve: Curves.bounceInOut,
      // buttonSize: const Size(50, 50),
      children: [
        SpeedDialChild(
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          ),
          backgroundColor: Colors.orange,
          onTap: () => Navigator.push(context, AddCourtView.route()),
          label: '新球场',
          labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
        SpeedDialChild(
          child: const Icon(Icons.sports_basketball, color: Colors.white),
          backgroundColor: Colors.orange,
          onTap: () => Navigator.push(context, AddGameView.route()),
          label: '新赛事',
          labelStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          labelBackgroundColor: Colors.black,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _page == 1 ? appBar : null,
      floatingActionButton: _page == 1 // Discover page
          ? FloatingActionButton(
              onPressed: onCreateTweet,
              child: const Icon(Icons.add, size: 28),
            )
          : _page == 2 // Map page
              ? buildSpeedDial()
              : null,
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),

      // drawer: const SideDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChange,
        backgroundColor: Pallete.backgroundColor,
        activeColor: Colors.orange,
        // inactiveColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            label: "首页",
            icon: SvgPicture.asset(AssetsConstants.homeBottomNavIcon, color: Pallete.blackColor),
          ),
          BottomNavigationBarItem(
            label: "发现",
            icon: SvgPicture.asset(AssetsConstants.discoverBottomNavIcon, color: Pallete.blackColor),
          ),
          BottomNavigationBarItem(
            label: "地图",
            icon: SvgPicture.asset(AssetsConstants.mapBottomNavIcon, color: Pallete.blackColor),
          ),
          BottomNavigationBarItem(
            label: "聊天",
            icon: SvgPicture.asset(AssetsConstants.chatBottomNavIcon, color: Pallete.blackColor),
          ),
          BottomNavigationBarItem(
            label: "我的",
            icon: SvgPicture.asset(AssetsConstants.profileBottomNavIcon, color: Pallete.blackColor),
          ),
        ],
      ),
    );
  }
}
