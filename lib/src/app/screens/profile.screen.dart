import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../meta/components/globals.dart';
import '../../meta/components/sync_indicator.dart';
import '../provider/notifiers/user_data.dart';
import '../provider/user_data.listener.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
      body: Column(
        children: <Widget>[
          UserDataListener(builder: (BuildContext context, UserData userData) {
            return Center(
              child: Stack(
                children: <Widget>[
                  ClipOval(
                    child: Image(
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      image: Image.memory(userData.currentProfilePic).image,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          TablerIcons.edit,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const VSpacer(20),
          const Text(
            'Minnu💚',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const VSpacer(5),
          Text(
            context.read<UserData>().currentAtSign,
            style: Theme.of(context).textTheme.caption,
          ),
          const VSpacer(20),
        ],
      ),
    );
  }
}
