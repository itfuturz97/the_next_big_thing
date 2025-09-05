import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_next_big_thing/views/notifications/notifications_ctrl.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsCtrl>(
      init: NotificationsCtrl(),
      builder: (context) {
        return Scaffold();
      }
    );
  }
}
