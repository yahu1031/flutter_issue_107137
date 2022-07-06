// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// 🌎 Project imports:
import 'notifiers/new_user.dart';
import 'notifiers/theme.dart';
import 'notifiers/user_data.dart';

class MultiProviders extends StatelessWidget {
  final Widget? child;
  const MultiProviders({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<UserData>(create: (_) => UserData()),
        ChangeNotifierProvider<NewUser>(create: (_) => NewUser()),
      ],
      child: child,
    );
  }
}
