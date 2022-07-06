// 🐦 Flutter imports:
import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:provider/provider.dart';

import 'notifiers/user_data.dart';

// 🌎 Project imports:

class UserDataListener extends StatelessWidget {
  const UserDataListener({
    required this.builder,
    Key? key,
  }) : super(key: key);
  final Widget Function(BuildContext context, UserData value) builder;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserData>.value(
      value: context.watch<UserData>(),
      builder: (BuildContext context, _) => Consumer<UserData>(
        builder: (BuildContext context, UserData value, Widget? _) => builder(
          context,
          value,
        ),
      ),
    );
  }
}
