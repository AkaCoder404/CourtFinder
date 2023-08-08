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
    print('Chats ${currentUser?.chats.length}');

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
          ? ListView.builder(
              itemCount: currentUser.chats.length, // Example number of chats
              itemBuilder: (BuildContext context, int index) {
                final chat = currentUser.chats[index];
                return ChatInfoTile(chatRoomId: chat);
              },
            )
          : const Center(child: CircularProgressIndicator(color: Pallete.redColor)),
    );
  }
}
