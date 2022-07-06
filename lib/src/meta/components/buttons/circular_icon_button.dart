import 'package:flutter/material.dart';


class CircularIconButton extends StatelessWidget {
  const CircularIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  }) : super(key: key);

  final VoidCallback onPressed;
  final IconData icon;
  final Color bgColor, iconColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: bgColor,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 20,
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
