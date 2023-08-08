import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:courtfinder/common/common.dart';
import 'package:courtfinder/constants/constants.dart';
import 'package:courtfinder/features/auth/controller/auth_controller.dart';
import 'package:courtfinder/features/notifications/controller/notification_controller.dart';
import 'package:courtfinder/features/notifications/widget/notification_tile.dart';
import 'package:courtfinder/models/notification_model.dart' as model;
import 'package:courtfinder/theme/pallete.dart';

class NotificationView extends ConsumerWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const NotificationView(),
      );
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            '通知',
            style: TextStyle(color: Pallete.blackColor),
          ),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Pallete.blackColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getNotificationsProvider(currentUser.uid)).when(
                data: (notifications) {
                  return ref.watch(getLatestNotificationProvider).when(
                        data: (data) {
                          if (data.events.contains(
                            'databases.*.collections.${AppwriteConstants.notificationsCollection}.documents.*.create',
                          )) {
                            final latestNotif = model.Notification.fromMap(data.payload);
                            if (latestNotif.uid == currentUser.uid) {
                              notifications.insert(0, latestNotif);
                            }
                            data.events.clear();
                          }

                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = notifications[index];
                              return NotificationTile(
                                notification: notification,
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () {
                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = notifications[index];
                              return NotificationTile(
                                notification: notification,
                              );
                            },
                          );
                        },
                      );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
    );
  }
}
