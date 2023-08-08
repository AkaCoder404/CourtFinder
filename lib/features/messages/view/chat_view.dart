// View for chat messages between two users
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/common/common.dart';
import 'package:courtfinder/constants/appwrite_constants.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/messages/controller/message_controller.dart';
import 'package:courtfinder/features/messages/widgets/message.dart';
import 'package:courtfinder/models/message_model.dart';
import 'package:courtfinder/theme/pallete.dart';

class ChatView extends ConsumerWidget {
  static route(String chat, String title) =>
      MaterialPageRoute(builder: (context) => ChatView(chat: chat, title: title));
  final String chat;
  final String title;
  const ChatView({super.key, required this.chat, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final chatRoom = ref.watch(getChatRoomsDetailsProvider(chat)).value;
    TextEditingController messageController = TextEditingController();

    void sendMessage() {
      if (currentUser == null) {
        return;
      }
      if (messageController.text.isNotEmpty) {
        ref.read(messageControllerProvider.notifier).sendMessage(
              text: messageController.text,
              // context: context,
              chatRoomId: chat,
              userId: currentUser.uid,
            );
        messageController.clear();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: Pallete.blackColor),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Pallete.blackColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Pallete.blackColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: chatRoom != null
                ? ref.watch(getMessagesProvider(chatRoom)).when(
                      data: (messages) {
                        return ref.watch(getLatestMessageProvider).when(
                              data: (data) {
                                print('chatViewData $data');
                                if (data.events.contains(
                                  'databases.*.collections.${AppwriteConstants.messagesCollection}.documents.*.create',
                                )) {
                                  if (Message.fromMap(data.payload).chatRoomId == chat) {
                                    messages.insert(0, Message.fromMap(data.payload));
                                  }

                                  data.events.clear();
                                } else if (data.events.contains(
                                  'databases.*.collections.${AppwriteConstants.messagesCollection}.documents.*.update',
                                )) {
                                  // TODO: get id of original message?
                                  print("get rid of original message");
                                  final startingPoint = data.events[0].lastIndexOf('documents.');
                                  final endPoint = data.events[0].lastIndexOf('.update');
                                  final tweetId = data.events[0].substring(startingPoint + 10, endPoint);

                                  var tweet = messages.where((element) => element.id == tweetId).first;

                                  final tweetIndex = messages.indexOf(tweet);
                                  messages.removeWhere((element) => element.id == tweetId);

                                  tweet = Message.fromMap(data.payload);
                                  messages.insert(tweetIndex, tweet);
                                }

                                return ListView.builder(
                                  // controller: _scrollController,
                                  reverse: true,
                                  itemCount: messages.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final message = messages[index];
                                    return MessageBubble(message: message);
                                  },
                                );
                              },
                              error: (error, stackTrace) => ErrorText(
                                error: error.toString(),
                              ),
                              loading: () {
                                return ListView.builder(
                                  // controller: _scrollController,
                                  reverse: true,
                                  itemCount: messages.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final message = messages[index];
                                    return MessageBubble(message: message);
                                  },
                                );
                              },
                            );
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                      ),
                      loading: () => const Loader(),
                    )
                : const Loader(),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: const TextStyle(color: Pallete.blackColor),
                    decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(color: Pallete.blackColor)),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Pallete.orangeColor,
                  ),
                  onPressed: () {
                    // showSnackBar(context, messageController.text);
                    // messageController.clear();
                    sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
