// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:simple_animations/simple_animations.dart';

/// This is the stateless widget that the main application instantiates.
class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation({ required this.delay, required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MultiTween<DefaultAnimationProperties> tween =
        MultiTween<DefaultAnimationProperties>()
          ..add(
              DefaultAnimationProperties.color,
              Tween<double>(begin: 0.0, end: 1.0),
              const Duration(milliseconds: 500))
          ..add(
              DefaultAnimationProperties.y,
              Tween<double>(begin: 5.0, end: 0.0),
              const Duration(milliseconds: 500),
              Curves.easeOut);

    return CustomAnimation<MultiTweenValues<DefaultAnimationProperties>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (BuildContext context, Widget? child,
              MultiTweenValues<DefaultAnimationProperties> animation) =>
          Opacity(
        opacity: animation.get(DefaultAnimationProperties.color),
        child: Transform.translate(
            offset: Offset(
              0,
              animation.get(DefaultAnimationProperties.y),
            ),
            child: child),
      ),
    );
  }
}
