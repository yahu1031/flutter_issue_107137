import 'package:at_base2e15/at_base2e15.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../../models/buzz_key.model.dart';
import '../../../models/persona.model.dart';
import '../../adaptive/adaptive_loading.dart';
import '../../globals.dart';
import '../modal_sheet.dart';

class PersonaDetails extends StatefulWidget {
  const PersonaDetails({
    Key? key,
    required this.persona,
    this.isDialog = false,
  }) : super(key: key);
  final Persona persona;
  final bool isDialog;
  @override
  State<PersonaDetails> createState() => _PersonaDetailsState();
}

class _PersonaDetailsState extends State<PersonaDetails> {
  @override
  Widget build(BuildContext context) {
    return ModalSheetBody(
      curvedBottom: widget.isDialog,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const VSpacer(10),
            Center(
              child: Text(
                widget.persona.name ?? 'No Name',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const VSpacer(30),
            ...widget.persona.keysList!
                .map(
                  (BuzzKey key) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: key.value?.type!.toLowerCase() == 'image'
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedMemoryImage(
                                uniqueKey:
                                    'app://image/${key.value?.labelName}',
                                height: 70,
                                bytes: Base2e15.decode(key.value?.value),
                                placeholder: const AdaptiveLoading()),
                          )
                        : RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                  text:
                                      key.value?.labelName ?? 'No persona keys',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextSpan(
                                  text: ': ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                TextSpan(
                                  text: key.value?.value ?? 'No Value',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                          ),
                  ),
                )
                .toList(),
            const VSpacer(20),
            Center(
              child: Text(
                'Shared With',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
            const VSpacer(20),
            widget.persona.personasSharedWith!.isEmpty
                ? const Text('No personas')
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet(context) ? 5 : 3,
                      childAspectRatio: 2,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                    ),
                    itemCount: widget.persona.personasSharedWith?.length ?? 0,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: widget.persona.personasSharedWith!.values
                                            .toList()[index] ==
                                        null
                                    ? const SquareWidget(
                                        40,
                                        child: Icon(TablerIcons.user),
                                      )
                                    : CachedMemoryImage(
                                        uniqueKey: 'app://image/$index',
                                        height: 40,
                                        bytes: Base2e15.decode(
                                          widget.persona.personasSharedWith!
                                              .values
                                              .toList()[index]!,
                                        ),
                                        placeholder: const AdaptiveLoading(),
                                      ),
                              ),
                              SizedBox(
                                width: 90,
                                child: Text(
                                  widget.persona.personasSharedWith?.keys
                                          .toList()[index] ??
                                      '',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          // Positioned(
                          //   top: -20,
                          //   right: 10,
                          //   child: IconButton(
                          //     onPressed: () {
                          //       // TODO: Remove persona from shared with
                          //     },
                          //     icon: const Icon(
                          //       TablerIcons.minus,
                          //       size: 15,
                          //       color: Colors.red,
                          //     ),
                          //   ),
                          // )
                        ],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
