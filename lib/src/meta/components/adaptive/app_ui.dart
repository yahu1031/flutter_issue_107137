import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../globals.dart';

class AdaptiveAppUI extends StatefulWidget {
  const AdaptiveAppUI({Key? key}) : super(key: key);

  @override
  State<AdaptiveAppUI> createState() => _AdaptiveAppUIState();
}

class _AdaptiveAppUIState extends State<AdaptiveAppUI> {
  @override
  Widget build(BuildContext context) {
    return isIOS || isMacOS
        ? const CupertinoApp(
          )
        : const MaterialApp(
          );
  }
}
