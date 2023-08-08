import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:courtfinder/constants/constants.dart';
import 'package:courtfinder/core/enums/notification_type_enum.dart';
import 'package:courtfinder/models/notification_model.dart' as model;
import 'package:courtfinder/theme/pallete.dart';

class NotificationTile extends StatelessWidget {
  final model.Notification notification;
  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(0),
        ),
        child: ListTile(
          leading: notification.notificationType == NotificationType.follow
              ? const Icon(
                  Icons.person,
                  color: Pallete.blueColor,
                )
              : notification.notificationType == NotificationType.like
                  ? SvgPicture.asset(
                      AssetsConstants.likeFilledIcon,
                      color: Pallete.redColor,
                      height: 20,
                    )
                  : notification.notificationType == NotificationType.retweet
                      ? SvgPicture.asset(
                          AssetsConstants.retweetIcon,
                          color: Pallete.greyColor,
                          height: 20,
                        )
                      : notification.notificationType == NotificationType.reply
                          ? const Icon(Icons.comment, color: Colors.green)
                          : null,
          title: Text(
            '${notification.text} at ${notification.notifiedAt}',
            style: const TextStyle(color: Pallete.blackColor),
          ),
        ));
  }
}
