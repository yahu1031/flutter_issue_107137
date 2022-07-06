import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final String icon;
  final String text;
  final bool selected;
  final GestureTapCallback? onTap;
  const CardWidget({
    required this.icon,
    required this.text,
    required this.onTap,
    required this.selected,
    Key? key,
  }) : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 55,
        width: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                widget.selected ? Colors.lightBlueAccent : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.grey[300]!.withOpacity(0.5),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  widget.icon,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text(
              widget.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
