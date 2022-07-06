import 'package:flutter/material.dart';

import '../../models/dictionary/phone/phone.model.dart';

class PhonePersona extends StatelessWidget {
  const PhonePersona({required this.persona, Key? key}) : super(key: key);
  final Phone persona;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(persona.toString()),
    );
  }
}
