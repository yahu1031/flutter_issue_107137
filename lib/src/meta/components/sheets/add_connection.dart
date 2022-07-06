import 'package:at_server_status/at_server_status.dart';
import 'package:flutter/material.dart';

import '../../../core/services/instances.dart';
import '../../extensions/string.ext.dart';
import '../buttons/curved.button.dart';
import '../filled.textfield.dart';
import '../globals.dart';
import 'modal_sheet.dart';

class AddConnectionSheet extends StatefulWidget {
  const AddConnectionSheet({Key? key}) : super(key: key);

  @override
  State<AddConnectionSheet> createState() => _AddConnectionSheetState();
}

class _AddConnectionSheetState extends State<AddConnectionSheet> {
  bool validAtSign = false;
  late TextEditingController _atSignController;

  @override
  void initState() {
    super.initState();
    _atSignController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _atSignController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalSheetBody(
      child: Container(
        height: validAtSign
            ? MediaQuery.of(context).size.height * 0.5
            : MediaQuery.of(context).size.height * 0.25,
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Text(
                  'Add Connection',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const VSpacer(18),
              FilledTextField(
                controller: _atSignController,
                hint: '@sign',
                width: 350,
              ),
              if (validAtSign) const VSpacer(18),
              if (validAtSign)
                const FilledTextField(
                  hint: 'Nickname(Optional)',
                  width: 350,
                ),
              if (validAtSign) const VSpacer(18),
              if (validAtSign)
                const FilledTextField(
                  hint: 'Notes(Optional)',
                  width: 350,
                ),
              const VSpacer(18),
              CurvedButton(
                onPressed: () async {
                  if (_atSignController.text.isEmpty) {
                    Navigator.pop(context);
                    await showToast(context, 'Looks like @sign is empty',
                        isError: true);
                    return;
                  }
                  if (_atSignController.text.formatAtSign() ==
                      ServiceInstances.sdkServices.currentAtSign) {
                    Navigator.pop(context);
                    await showToast(
                        context, 'Can\'t add yourself as a connection',
                        isError: true);
                    return;
                  }
                  AtStatus status = await ServiceInstances.sdkServices
                      .getAtSignStatus(_atSignController.text);
                  setState(() {
                    validAtSign = status.rootStatus == RootStatus.found;
                  });
                },
                text: 'Check',
                color: Colors.transparent,
                textStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
