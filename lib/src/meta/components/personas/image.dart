import 'package:flutter/material.dart';

import '../../models/dictionary/image/image.model.dart';

class ImagePersona extends StatelessWidget {
  const ImagePersona({required this.imagePersona, Key? key}) : super(key: key);
  final UserImage imagePersona;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(imagePersona.toString()),
    );
  }
}
