import 'package:flutter/material.dart';

import '../../models/dictionary/file/file.model.dart';

class FilePersona extends StatelessWidget {
  const FilePersona({required this.persona, Key? key}) : super(key: key);
  final UserFile persona;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(persona.toString()),
    );
  }
}
