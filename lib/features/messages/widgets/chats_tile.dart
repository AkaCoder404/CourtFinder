import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/common/common.dart';
import 'package:courtfinder/constants/appwrite_constants.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/messages/controller/message_controller.dart';
import 'package:courtfinder/features/messages/view/chat_view.dart';
import 'package:courtfinder/models/message_model.dart';
import 'package:courtfinder/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatInfoTile extends ConsumerWidget {
  final String chatRoomId;
  const ChatInfoTile({
    super.key,
    required this.chatRoomId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRoom = ref.watch(getChatRoomsDetailsProvider(chatRoomId)).value;

    // Get id of the other user when there is only one other user
    // TODO: Handle group chat naming, if groupchat, just use groupchat name
    final otherUser = chatRoom != null
        ? chatRoom.users
            .firstWhere((element) => element != ref.watch(currentUserDetailsProvider).value?.uid, orElse: () => 'Error')
        : 'Error';

    final otherUserDetails = ref.watch(getUserDetailsProvider(otherUser)).value;

    return chatRoom != null && otherUserDetails != null
        ? ref.watch(getMostRecentMessageProvider(chatRoom)).when(
            data: (messages) {
              return ref.watch(getLatestMessageProvider).when(
                    data: (data) {
                      print(data);
                      // if (data.events.contains(
                      //   'databases.*.collections.${AppwriteConstants.messagesCollection}.documents.*.create',
                      // )) {
                      //   print("Wow ${data.payload}");
                      //   if (Message.fromMap(data.payload).chatRoomId == chat) {
                      //     messages = Message.fromMap(data.payload);
                      //     print("chats_tile ${messages}");
                      //   }
                      //   data.events.clear();
                      // }
                      if (Message.fromMap(data.payload).chatRoomId == chatRoomId) {
                        messages = Message.fromMap(data.payload);
                        // print("chats_tile $messages");
                      }

                      return Column(
                        children: [
                          ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Image(
                                image: NetworkImage(otherUserDetails.profilePic),
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(otherUserDetails.name, style: const TextStyle(color: Pallete.blackColor)),
                            subtitle: Text(
                              messages.text,
                              style: const TextStyle(color: Pallete.blackColor),
                            ),
                            trailing: Text(
                              timeago.format(messages.sentAt, locale: 'en_short'),
                              style: const TextStyle(color: Pallete.blackColor),
                            ), // Example timestamp
                            onTap: () {
                              // Navigate to chat screen with corresponding user
                              Navigator.push(context, ChatView.route(chatRoomId, otherUserDetails.name));
                            },
                          ),
                          const Divider(color: Pallete.blackColor)
                        ],
                      );
                    },
                    error: (error, stackTrace) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () {
                      return Column(
                        children: [
                          ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Image(
                                image: NetworkImage(otherUserDetails.profilePic),
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(otherUserDetails.name, style: const TextStyle(color: Pallete.blackColor)),
                            subtitle: Text(
                              messages.text,
                              style: const TextStyle(color: Pallete.blackColor),
                            ),
                            trailing: Text(
                              timeago.format(messages.sentAt, locale: 'en_short'),
                              style: const TextStyle(color: Pallete.blackColor),
                            ), // Example timestamp
                            onTap: () {
                              // Navigate to chat screen with corresponding user
                              Navigator.push(context, ChatView.route(chatRoomId, otherUserDetails.name));
                            },
                          ),
                          const Divider(color: Pallete.blackColor)
                        ],
                      );
                    },
                  );
            },
            error: (error, stackTrace) => ErrorText(error: 'ChatRoomRecentMessage ${error.toString()}'),
            loading: () => const Loader())
        : const Loader();
  }
}
