import 'package:flutter/material.dart';

import '../../models/dictionary/email/email.model.dart';

class EmailPersona extends StatelessWidget {
  const EmailPersona({required this.persona, Key? key}) : super(key: key);
  final Email persona;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(persona.toString()),
    );
  }
}
