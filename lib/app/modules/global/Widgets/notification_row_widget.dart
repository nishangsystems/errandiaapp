import 'package:errandia/app/modules/global/constants/color.dart';
import 'package:errandia/modal/Notification.dart';
import 'package:errandia/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationRowWidget extends StatelessWidget {
  final NotificationItem item;

  const NotificationRowWidget({
    Key? key,
    required this.item
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      style: ListTileStyle.list,
      leading: const CircleAvatar(
        backgroundColor: Colors.teal, // Color for the icon background
        radius: 22,
        backgroundImage: AssetImage('assets/images/notifications_icon.png'),
      ),
      title: Row(
        children: [
          Text(
            item.title,
            style: TextStyle(
              color: appcolor().mediumGreyColor,
              fontWeight: FontWeight.w400,
              fontSize: 12
            ),
          ),
          const Spacer(),
          Text(
            formatDateString(item.date),
            style: TextStyle(
              color: appcolor().mediumGreyColor,
              fontSize: 12,
            ),
          ),
        ],
      ).paddingOnly(top: 3),
      subtitle: Text(
        item.message,
        style: TextStyle(color: Colors.black.withOpacity(0.6),
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
