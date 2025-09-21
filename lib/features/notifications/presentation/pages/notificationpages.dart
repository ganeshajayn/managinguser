import 'package:flutter/material.dart';
import 'package:machinetest/features/notifications/presentation/widgets/notification_debug_widget.dart';

class Notificationpages extends StatelessWidget {
  const Notificationpages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text("Notifications"),
      ),
      body: NotificationDebugWidget(),
    );
  }
}
