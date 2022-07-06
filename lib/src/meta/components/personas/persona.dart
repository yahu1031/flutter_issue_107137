import 'package:flutter/material.dart';

import '../../../app/constants/constants.dart';
import '../../models/dictionary/blood/blood.model.dart';
import '../../models/dictionary/date/date.model.dart';
import '../../models/dictionary/email/email.model.dart';
import '../../models/dictionary/fax/fax.model.dart';
import '../../models/dictionary/file/file.model.dart';
import '../../models/dictionary/links/links.model.dart';
import '../../models/dictionary/location/location.model.dart';
import '../../models/dictionary/password/password.model.dart';
import '../../models/dictionary/phone/phone.model.dart';
import 'blood.dart';
import 'date.dart';
import 'email.dart';
import 'fax.dart';
import 'file.dart';
import 'links.dart';
import 'location.dart';
import 'password.dart';
import 'phone.dart';

class PersonaWidget extends StatefulWidget {
  const PersonaWidget(
      {required this.pageController,
      required this.persona,
      required this.useMaps,
      this.onSizeChanged,
      Key? key})
      : super(key: key);
  final BasePersona? persona;
  final bool useMaps;
  final PageController pageController;
  final ValueChanged<Size>? onSizeChanged;

  @override
  State<PersonaWidget> createState() => _PersonaWidgetState();
}

class _PersonaWidgetState extends State<PersonaWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: persona(),
    );
  }

  Widget persona() {
    if (widget.persona == null) {
      return const Center(
        child: Text('No persona selected'),
      );
    } else if (widget.persona is BloodGroup) {
      return BloogGroupPersona(persona: widget.persona! as BloodGroup);
    } else if (widget.persona is Date) {
      return DatePersona(persona: widget.persona! as Date);
    } else if (widget.persona is Email) {
      return EmailPersona(persona: widget.persona! as Email);
    } else if (widget.persona is Fax) {
      return FaxPersona(persona: widget.persona! as Fax);
    } else if (widget.persona is UserFile) {
      return FilePersona(persona: widget.persona! as UserFile);
    } else if (widget.persona is Url) {
      return LinksPersona(persona: widget.persona! as Url);
    } else if (widget.persona is Location) {
      return LocationPersona(
        persona: widget.persona! as Location,
        useMaps: widget.useMaps,
      );
    } else if (widget.persona is Password) {
      return PasswordPersona(persona: widget.persona! as Password);
    } else if (widget.persona is Phone) {
      return PhonePersona(persona: widget.persona! as Phone);
    } else {
      return Center(
        child: Text(widget.persona.toString()),
      );
    }
  }
}
