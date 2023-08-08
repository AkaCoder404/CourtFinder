import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/models/message_model.dart';
import 'package:courtfinder/theme/pallete.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageBubble extends ConsumerWidget {
  final Message message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value!;
    return Row(
      mainAxisAlignment: message.sentByUid == currentUser.uid ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: message.sentByUid == currentUser.uid ? Colors.green[200] : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: message.sentByUid == currentUser.uid ? const Radius.circular(16) : const Radius.circular(0),
              bottomRight: message.sentByUid == currentUser.uid ? const Radius.circular(0) : const Radius.circular(16),
            ),
          ),
          child: Text(
            '${message.text} (${timeago.format(message.sentAt, locale: 'en_short')})',
            style: const TextStyle(color: Pallete.blackColor),
          ),
        ),
      ],
    );
  }
}
