// import 'package:at_location_flutter/at_location_flutter.dart';
import 'package:flutter/material.dart';

import '../../models/dictionary/location/location.model.dart';
import '../buttons/curved.button.dart';
import '../filled.textfield.dart';
import '../globals.dart';

class LocationPersona extends StatefulWidget {
  const LocationPersona(
      {required this.persona, required this.useMaps, Key? key})
      : super(key: key);
  final Location persona;
  final bool useMaps;

  @override
  State<LocationPersona> createState() => _LocationPersonaState();
}

class _LocationPersonaState extends State<LocationPersona> {
  late bool isPublic, enableSubmit;
  late TextEditingController _valueController, _descriptionController;
  // late MapController _mapController;
  @override
  void initState() {
    enableSubmit = false;
    isPublic = widget.persona.isPublic;
    // _mapController = MapController();
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
      child: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Center(
              child: Text(
                widget.useMaps ? '🗺️' : widget.persona.icon!,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 40,
                    ),
              ),
            ),
            const VSpacer(10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: !widget.useMaps
                  ? FilledTextField(
                      hint: widget.persona.hint,
                      width: 350,
                      controller: _valueController,
                      onChanged: (String value) {
                        setState(() =>
                            enableSubmit = _valueController.text.isNotEmpty);
                      },
                      textInputType: TextInputType.phone,
                      autofillHints: <String>[
                        AutofillHints.telephoneNumber,
                      ],
                    )
                  : AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 280,
                      width: 350,
                      // child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(10),
                      //     child: showLocation(UniqueKey(), _mapController)),
                    ),
            ),
            // : showLocation(UniqueKey(), _mapController)),
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
      ),
    );
  }
}
