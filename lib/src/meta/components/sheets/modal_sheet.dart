import 'package:flutter/material.dart';

class ModalSheetBody extends StatefulWidget {
  const ModalSheetBody(
      {required this.child, this.curvedBottom = false, Key? key})
      : super(key: key);
  final Widget child;
  final bool curvedBottom;
  @override
  State<ModalSheetBody> createState() => _ModalSheetBodyState();
}

class _ModalSheetBodyState extends State<ModalSheetBody> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).bottomSheetTheme.modalBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft:
              widget.curvedBottom ? const Radius.circular(20) : Radius.zero,
          bottomRight:
              widget.curvedBottom ? const Radius.circular(20) : Radius.zero,
        ),
      ),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: widget.child,
        ),
      ),
    );
  }
}
