// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../globals.dart';

class AdaptiveLoading extends StatelessWidget {
  const AdaptiveLoading({
    Key? key,
    this.strokeWidth,
    this.size,
    this.color,
  }) : super(key: key);
  final double? strokeWidth, size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SquareWidget(
        size ?? 20,
        child: CircularProgressIndicator.adaptive(
          strokeWidth: strokeWidth ?? 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
