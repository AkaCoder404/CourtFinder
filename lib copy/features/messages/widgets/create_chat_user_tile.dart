import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/core/utils.dart';
import 'package:courtfinder/features/messages/controller/message_controller.dart';
import 'package:courtfinder/theme/pallete.dart';

class CreateChatSearchTile extends ConsumerWidget {
  final String user;
  final bool isSelected;
  final Function(String, bool) onSelected;
  const CreateChatSearchTile({
    super.key,
    required this.user,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(getUserDetailsProvider(user)).value;
    return userInfo != null
        ? ListTile(
            onTap: () {
              showSnackBar(context, user.toString());
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userInfo.profilePic),
            ),
            title: Text(userInfo.name, style: const TextStyle(color: Pallete.blackColor)),
            trailing: Checkbox(
              value: isSelected,
              onChanged: (value) => onSelected(user, value ?? false),
              fillColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Pallete.orangeColor; // color when checkbox is selected
                  }
                  return Colors.black; // color when checkbox is not selected
                },
              ),
            ),
          )
        : const SizedBox();
  }
}
