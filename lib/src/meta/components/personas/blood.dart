import 'package:flutter/material.dart';

import '../../models/dictionary/blood/blood.model.dart';
import '../buttons/curved.button.dart';
import '../filled.textfield.dart';
import '../globals.dart';

class BloogGroupPersona extends StatefulWidget {
  const BloogGroupPersona({required this.persona, Key? key}) : super(key: key);
  final BloodGroup persona;

  @override
  State<BloogGroupPersona> createState() => _BloogGroupPersonaState();
}

class _BloogGroupPersonaState extends State<BloogGroupPersona> {
  late bool isPublic, enableSubmit;
  String? _bloodGroup;
  late TextEditingController _valueController, _descriptionController;
  final List<String> _bloodGroups = <String>[
    'A Positive (A+)',
    'A Negative (A-)',
    'Positive (B+)',
    'Negative (B-)',
    'AB Positive (AB+)',
    'AB Negative (AB-)',
    'O Positive (O+)',
    'O Negative (O-)',
  ];
  @override
  void initState() {
    enableSubmit = false;
    isPublic = widget.persona.isPublic;
    _valueController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
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
          Container(
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<String>(
                items: _bloodGroups.map((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
                underline: const SizedBox.shrink(),
                hint: Text(widget.persona.hint!),
                value: _bloodGroup,
                iconEnabledColor: Colors.transparent,
                iconDisabledColor: Colors.transparent,
                onChanged: (String? newVal) {
                  setState(() {
                    _valueController.text = _bloodGroup = newVal!;
                    enableSubmit = _valueController.text.isNotEmpty;
                  });
                }),
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
