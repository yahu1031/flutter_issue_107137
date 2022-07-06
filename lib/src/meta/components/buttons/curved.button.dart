// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class CurvedButton extends StatefulWidget {
  final String text;
  final bool disabled;
  final VoidCallback? onPressed;
  final double? radius;
  final Color? color, splashColor;
  final TextStyle? textStyle;
  final ShapeBorder? shape;
  const CurvedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.radius = 10,
    this.splashColor,
    this.color,
    this.textStyle,
    this.shape,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<CurvedButton> createState() => _CurvedButtonState();
}

class _CurvedButtonState extends State<CurvedButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 40,
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: widget.disabled || widget.onPressed == null
            ? Colors.transparent
            : widget.color,
        borderRadius: BorderRadius.circular(widget.radius!),
      ),
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: MaterialButton(
        disabledTextColor: Colors.grey,
        disabledColor: Colors.transparent,
        color: widget.disabled || widget.onPressed == null
            ? Colors.transparent
            : widget.color,
        textColor: widget.disabled || widget.onPressed == null
            ? Colors.grey
            : Colors.white,
        elevation: 0,
        highlightElevation: 0,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        hoverElevation: 0,
        focusElevation: 0,
        highlightColor: widget.splashColor ?? Colors.transparent,
        splashColor: widget.splashColor ?? Colors.transparent,
        shape: widget.shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius!),
            ),
        onPressed: widget.disabled ? null : widget.onPressed,
        child: Text(
          widget.text,
          style: widget.textStyle,
        ),
      ),
    );
  }
}
