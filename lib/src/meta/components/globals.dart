// 🎯 Dart imports:
import 'dart:io';
import 'dart:math';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

PageTransition<Widget> pageTransision(RouteSettings settings, Widget page,
        [PageTransitionType? animationType]) =>
    PageTransition<Widget>(
      child: page,
      type: animationType ?? PageTransitionType.fade,
      settings: settings,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 150),
    );

/// Toast widget.
///
/// [context] - Pass the build context if the toast is for desktop.
///
/// [msg] - message to show.
///
/// [width] - Pass the width of the toast.
///
/// [isError] - Pass true if the toast is for error.
Future<void> showToast(BuildContext? context, String msg,
    {double? width, bool isError = false}) async {
  ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: isMobile
            ? TextStyle(
                fontSize: 12,
                color: isError ? Colors.white : Colors.black,
              )
            : null,
      ),
      duration: const Duration(milliseconds: 2300),
      elevation: 0.5,
      margin: width != null
          ? null
          : EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.2),
      backgroundColor: isError ? Colors.red[700] : Colors.white70,
      padding: const EdgeInsets.all(10),
      width: width,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: Platform.isAndroid
            ? BorderRadius.circular(50)
            : BorderRadius.circular(10),
      ),
    ),
  );
}

final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

/// Returns true if the current platform is macOS/Windows/Linux.
bool get isDesktop =>
    Platform.isMacOS || Platform.isWindows || Platform.isLinux;

/// Returns true if the current platform is iOS/Android.
bool get isMobile => Platform.isAndroid || Platform.isIOS;

bool isTablet(BuildContext context) => MediaQuery.of(context).size.width > 650;

/// Returns true if the current platform is Android.
bool get isAndroid => Platform.isAndroid;

/// Returns true if the current platform is iOS.
bool get isIOS => Platform.isIOS;

/// Returns true if the current platform is macOS.
bool get isMacOS => Platform.isMacOS;

/// Vertical spacer with presised height.
class VSpacer extends StatelessWidget {
  const VSpacer(this.size, {Key? key}) : super(key: key);
  final double size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 0, height: size);
  }
}

/// Horizontal spacer with presised width.
class HSpacer extends StatelessWidget {
  const HSpacer(this.size, {Key? key}) : super(key: key);
  final double size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: 0);
  }
}

/// Square spacer with presised size.
class SquareWidget extends StatelessWidget {
  const SquareWidget(
    this.size, {
    Key? key,
    this.child,
  }) : super(key: key);
  final double size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(dimension: size, child: child);
  }
}

// generate a random color
Color get randomColor => Color(0xFF000000 | (Random().nextInt(0xFFFFFF) + 1));
