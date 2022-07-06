import 'package:flutter/material.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../meta/components/globals.dart';
import '../../meta/components/sync_indicator.dart';
import '../provider/user_data.listener.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            TablerIcons.chevron_left,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          UserDataListener(
            builder: (_, __) => SquareWidget(
              50,
              child: Center(
                child: SyncIndicator(size: 15),
              ),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Notifications'),
      ),
    );
  }
}
