import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/dictionary/fax/fax.model.dart';
import '../buttons/curved.button.dart';
import '../filled.textfield.dart';
import '../globals.dart';

class FaxPersona extends StatefulWidget {
  const FaxPersona({required this.persona, Key? key}) : super(key: key);
  final Fax persona;

  @override
  State<FaxPersona> createState() => _FaxPersonaState();
}

class _FaxPersonaState extends State<FaxPersona> {
  late bool isPublic, enableSubmit;
  late TextEditingController _valueController,
      _descriptionController,
      _personaNameController;
  @override
  void initState() {
    enableSubmit = false;
    isPublic = widget.persona.isPublic;
    _personaNameController = TextEditingController();
    _valueController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _personaNameController.dispose();
    _valueController.dispose();
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
            hint: 'Name of the persona',
            width: 350,
            controller: _personaNameController,
            onChanged: (String value) {
              setState(() => enableSubmit = _valueController.text.isNotEmpty);
            },
            textInputType: TextInputType.phone,
            autofillHints: <String>[
              AutofillHints.telephoneNumber,
            ],
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          const VSpacer(10),
          FilledTextField(
            hint: widget.persona.hint,
            width: 350,
            controller: _valueController,
            onChanged: (String value) {
              setState(() => enableSubmit = _valueController.text.isNotEmpty);
            },
            textInputType: TextInputType.phone,
            autofillHints: <String>[
              AutofillHints.telephoneNumber,
            ],
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
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
