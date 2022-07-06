// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'curved.button.dart';

class CurvedOutlineButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final TextStyle? textStyle;
  const CurvedOutlineButton(
      {required this.text,
      required this.onPressed,
      this.textStyle,
      this.color,
      Key? key})
      : super(key: key);

  @override
  State<CurvedOutlineButton> createState() => _CurvedOutlineButtonState();
}

class _CurvedOutlineButtonState extends State<CurvedOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return CurvedButton(
      text: widget.text,
      textStyle: widget.textStyle ?? TextStyle(color: widget.color),
      onPressed: widget.onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: widget.color ?? Colors.transparent,
          width: 2,
        ),
      ),
    );
  }
}
