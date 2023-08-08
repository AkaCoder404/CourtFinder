import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:courtfinder/constants/constants.dart';
import 'package:courtfinder/features/main/view/main_view.dart';
import 'package:courtfinder/features/map/view/map_view.dart';
import 'package:courtfinder/features/messages/view/messages_view.dart';
import 'package:courtfinder/features/tweet/views/discover_view.dart';
import 'package:courtfinder/features/user_profile/view/user_profile_view.dart';

class UIConstants {
  // Reusable app bar
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.courtFinderLogo,
        // color: Pallete.blueColor,
        height: 50,
      ),
      // leading: Builder(
      //   builder: (context) => IconButton(
      //     icon: const Icon(Icons.menu),
      //     color: Pallete.blackColor,
      //     onPressed: () => Scaffold.of(context).openDrawer(),
      //   ),
      // ),
      actions: const [],
      centerTitle: true,
    );
  }

  static const List<Widget> bottomTabBarPages = [
    MainView(),
    DiscoverView(),
    MapView(),
    MessagesView(),
    UserProfileView(),
  ];
}
