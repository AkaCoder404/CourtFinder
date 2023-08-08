import 'package:courtfinder/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/common/loading_page.dart';
import 'package:courtfinder/core/utils.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/user_profile/controller/user_profile_controller.dart';
import 'package:courtfinder/features/user_profile/view/favorites.dart';
import 'package:courtfinder/features/user_profile/view/user_profile_view.dart';
import 'package:courtfinder/theme/pallete.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    if (currentUser == null) {
      return const Loader();
    }

    return SafeArea(
      child: Drawer(
        backgroundColor: Pallete.backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Expanded(
                child: ListView(
              children: [
                // ListTile(
                //   leading: const Icon(Icons.person, size: 30, color: Pallete.blackColor),
                //   title: const Text(
                //     'My Profile',
                //     style: TextStyle(color: Pallete.blackColor, fontSize: 22),
                //   ),
                //   onTap: () {
                //     Navigator.push(context, UserProfileView.route(currentUser));
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.payment, size: 30, color: Pallete.blackColor),
                //   title: const Text(
                //     'Twitter Blue',
                //     style: TextStyle(fontSize: 22, color: Pallete.blackColor),
                //   ),
                //   onTap: () {
                //     ref.read(userProfileControllerProvider.notifier).updateUserProfile(
                //           userModel: currentUser.copyWith(isTwitterBlue: !currentUser.isTwitterBlue),
                //           context: context,
                //           bannerFile: null,
                //           profileFile: null,
                //         );
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.star, size: 30, color: Pallete.blackColor),
                  title: const Text('收藏', style: TextStyle(fontSize: 22, color: Pallete.blackColor)),
                  onTap: () {
                    Navigator.push(context, FavoritesView.route());
                  },
                )
              ],
            )),
            const ThemeToggleButton(),
            MySideBarButton(
                label: '登出',
                onTap: () {
                  ref.read(authControllerProvider.notifier).logout(context);
                }),
            MySideBarButton(
                label: '注销',
                onTap: () {
                  showSnackBar(context, "功能暂未开发");
                }),
          ],
        ),
      ),
    );
  }
}

class MySideBarButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const MySideBarButton({Key? key, required this.label, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.orangeColor, // Set background color
        ),
        child: Text(label, style: const TextStyle(color: Pallete.blackColor)),
      ),
    );
  }
}
