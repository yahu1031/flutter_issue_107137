import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/dictionary/date/date.model.dart';
import '../buttons/curved.button.dart';
import '../filled.textfield.dart';
import '../globals.dart';

class DatePersona extends StatefulWidget {
  const DatePersona({required this.persona, Key? key}) : super(key: key);
  final Date persona;

  @override
  State<DatePersona> createState() => _DatePersonaState();
}

class _DatePersonaState extends State<DatePersona> {
  late bool isPublic, enableSubmit;
  late TextEditingController _valueController, _descriptionController;
  DateTime selectedDate = DateTime.now();
  void _showDatePicker(BuildContext ctx) {
    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => Container(
        height: 500,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime val) {
                  setState(() {
                    _valueController.text = DateFormat.yMd().format(val);
                    enableSubmit = _valueController.text.isNotEmpty;
                  });
                },
              ),
            ),
            CupertinoButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      ),
    );
  }

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
          FilledTextField(
            readOnly: true,
            hint: widget.persona.hint,
            width: 350,
            controller: _valueController,
            onTap: () {
              _showDatePicker(context);
            },
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
