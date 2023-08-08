import 'package:flutter/material.dart';
import 'package:courtfinder/features/user_profile/view/user_profile_view.dart';
import 'package:courtfinder/models/user_model.dart';
import 'package:courtfinder/theme/pallete.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;
  const SearchTile({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          UserProfileView.route(userModel),
        );
      },
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image(
          image: NetworkImage(userModel.profilePic),
          fit: BoxFit.cover,
        ),
      ),

      // CircleAvatar(
      //   backgroundImage: NetworkImage(userModel.profilePic),
      //   radius: 30,
      // ),
      title: Text(
        userModel.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Pallete.blackColor),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${userModel.name}',
            style: const TextStyle(fontSize: 16, color: Pallete.blackColor),
          ),
          Text(
            userModel.bio,
            style: const TextStyle(
              color: Pallete.blackColor,
            ),
          ),
        ],
      ),
    );
  }
}
