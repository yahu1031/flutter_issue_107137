import 'package:flutter/material.dart';

import '../../models/dictionary/links/links.model.dart';

class LinksPersona extends StatelessWidget {
  const LinksPersona({required this.persona, Key? key}) : super(key: key);
  final Url persona;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(persona.toString()),
    );
  }
}
