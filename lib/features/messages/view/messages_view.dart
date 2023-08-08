import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/messages/view/create_chat_view.dart';
import 'package:courtfinder/features/messages/widgets/chats_tile.dart';
import 'package:courtfinder/models/user_model.dart';
import 'package:courtfinder/theme/pallete.dart';

// View for list of chats
class MessagesView extends ConsumerWidget {
  const MessagesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    UserModel copyOfUser;
    if (currentUser != null) {
      copyOfUser = currentUser;
    } else {
      // copyOfUser = currentUser ?? UserModel();
    }

    // Refreshes the list of chats
    Future<void> onRefresh() async {
      var copy = ref.refresh(currentUserDetailsProvider).value;
      // print(copy);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('消息', style: TextStyle(color: Pallete.blackColor)),
        leading: null,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Pallete.blackColor,
            ),
            onPressed: () {
              Navigator.push(context, CreateChatView.route(currentUser as UserModel));
            },
          ),
        ],
      ),
      body: currentUser != null
          ? RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.builder(
                itemCount: currentUser.chats.length,
                itemBuilder: (context, index) {
                  return ChatInfoTile(
                    chatRoomId: currentUser.chats[index],
                  );
                },
              ))
          : const Center(child: CircularProgressIndicator(color: Pallete.redColor)),
    );
  }
}
