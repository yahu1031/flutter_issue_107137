import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../models/dictionary/password/password.model.dart';
import '../buttons/curved.button.dart';
import '../filled.textfield.dart';
import '../globals.dart';

class PasswordPersona extends StatefulWidget {
  const PasswordPersona({required this.persona, Key? key}) : super(key: key);
  final Password persona;

  @override
  State<PasswordPersona> createState() => _PasswordPersonaState();
}

class _PasswordPersonaState extends State<PasswordPersona> {
  late bool isPublic, enableSubmit, _obsecured;
  late TextEditingController _usernameController,
      _passwordController,
      _descriptionController;
  @override
  void initState() {
    enableSubmit = false;
    _obsecured = true;
    isPublic = widget.persona.isPublic;
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              widget.persona.icon!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 40,
                  ),
            ),
          ),
          const VSpacer(10),
          FilledTextField(
            hint: 'Username',
            width: 350,
            controller: _usernameController,
            onChanged: (String value) {
              setState(
                  () => enableSubmit = _usernameController.text.isNotEmpty);
            },
            autofillHints: <String>[
              AutofillHints.username,
            ],
          ),
          const VSpacer(10),
          SizedBox(
            width: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FilledTextField(
                  hint: widget.persona.hint,
                  width: 300,
                  obsecured: _obsecured,
                  controller: _passwordController,
                  onChanged: (String value) {
                    setState(() =>
                        enableSubmit = _passwordController.text.isNotEmpty);
                  },
                  autofillHints: <String>[
                    AutofillHints.password,
                  ],
                ),
                const VSpacer(10),
                MaterialButton(
                  onPressed: () async {
                    await HapticFeedback.mediumImpact();
                    setState(() => _obsecured = !_obsecured);
                  },
                  padding: EdgeInsets.zero,
                  color: Colors.grey[200],
                  elevation: 0,
                  focusElevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  height: 40,
                  minWidth: 40,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _obsecured ? TablerIcons.lock : TablerIcons.lock_open,
                    color: Colors.grey[700],
                  ),
                )
              ],
            ),
          ),
          const VSpacer(10),
          FilledTextField(
            hint: widget.persona.description,
            maxLines: 3,
            width: 350,
            height: 100,
            controller: _descriptionController,
          ),
          const VSpacer(10),
          CheckboxListTile(
            title: const Text('This is public data'),
            value: isPublic,
            onChanged: (_) {
              setState(() {
                isPublic = !isPublic;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            checkboxShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const VSpacer(10),
          Center(
            child: CurvedButton(
              text: 'Submit',
              color: Theme.of(context).primaryColor,
              onPressed: () {},
              disabled: !enableSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
