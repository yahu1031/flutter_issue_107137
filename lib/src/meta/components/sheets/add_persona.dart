import 'package:flutter/material.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../../app/constants/constants.dart';
import '../../models/index_tuple.dart';
import '../buttons/curved.button.dart';
import '../filled.textfield.dart';
import '../globals.dart';
import '../personas/persona.dart';
import 'dictionary_sheet.dart';
import 'modal_sheet.dart';

class AddPersonaSheet extends StatefulWidget {
  const AddPersonaSheet({Key? key}) : super(key: key);

  @override
  State<AddPersonaSheet> createState() => _AddPersonaSheetState();
}

class _AddPersonaSheetState extends State<AddPersonaSheet> {
  bool validAtSign = false,
      enableBack = false,
      useMaps = false,
      showPersonas = false;
  late TextEditingController _atSignController, _personaNameController;
  late PageController _pageController;
  BasePersona? persona;
  int _selectedIndex = -1;
  String? title;
  final GlobalKey _key = GlobalKey();
  @override
  void initState() {
    super.initState();
    _atSignController = TextEditingController();
    _personaNameController = TextEditingController();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _personaNameController.dispose();
    _atSignController.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalSheetBody(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: !showPersonas
            ? 200
            : _selectedIndex == 9 && useMaps
                ? MediaQuery.of(context).size.height * 0.85
                : _selectedIndex != -1
                    ? 500
                    : MediaQuery.of(context).size.height * 0.75,
        child: Center(
          child: !showPersonas
              ? Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Persona name',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const VSpacer(10),
                    FilledTextField(
                      controller: _personaNameController,
                      hint: 'Persona name',
                      width: 350,
                      onChanged: (_) => setState(() {}),
                    ),
                    const VSpacer(10),
                    CurvedButton(
                      color: Colors.transparent,
                      textStyle: Theme.of(context).textTheme.button!.copyWith(
                            color: _personaNameController.text.isEmpty
                                ? Theme.of(context).disabledColor
                                : Theme.of(context).primaryColor,
                          ),
                      text: 'Next',
                      onPressed: () => setState(() {
                        showPersonas = true;
                        title = _personaNameController.text.trim();
                      }),
                    ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          enableBack
                              ? IconButton(
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      _selectedIndex = -1;
                                    });
                                    await _pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeIn);
                                  },
                                  icon: const Icon(TablerIcons.arrow_left))
                              : const SquareWidget(48),
                          Text(
                            title ?? _personaNameController.text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _selectedIndex == 9
                              ? Transform.scale(
                                  scale: .6,
                                  child: Switch.adaptive(
                                    value: useMaps,
                                    onChanged: (_) {
                                      setState(() => useMaps = !useMaps);
                                    },
                                  ),
                                )
                              : const SquareWidget(48),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        onPageChanged: (_) {
                          setState(() {
                            if (_ == 0) {
                              title = _personaNameController.text;
                              enableBack = false;
                            } else {
                              title = persona?.name ?? 'Persona';
                              enableBack = true;
                            }
                          });
                        },
                        reverse: false,
                        physics: const NeverScrollableScrollPhysics(),
                        allowImplicitScrolling: false,
                        children: <Widget>[
                          DictionarySheet(
                            onTap: (IndexTuple _persona) async {
                              setState(() {
                                persona = _persona.value as BasePersona?;
                                _selectedIndex = _persona.index;
                              });
                              await _pageController.nextPage(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                              );
                            },
                            selectedIndex: _selectedIndex,
                          ),
                          PersonaWidget(
                            pageController: _pageController,
                            persona: persona,
                            key: _key,
                            useMaps: useMaps,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
