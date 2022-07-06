import 'package:flutter/material.dart';

import '../../../../meta/components/globals.dart';
import '../../../../meta/components/sheets/details/persona_details.dart';
import '../../../../meta/components/stacked_avatars.dart';
import '../../../provider/notifiers/user_data.dart';
import '../../../provider/user_data.listener.dart';

class PersonasScreen extends StatefulWidget {
  const PersonasScreen({Key? key}) : super(key: key);

  @override
  State<PersonasScreen> createState() => _PersonasScreenState();
}

class _PersonasScreenState extends State<PersonasScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UserDataListener(builder: (BuildContext context, UserData value) {
      return value.personas.isEmpty
          ? const Center(
              child: Text('No personas yet'),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet(context) ? 2 : 1,
                childAspectRatio: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              physics: const BouncingScrollPhysics(),
              itemCount: value.personas.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (_) {
                      return PersonaDetails(
                        persona: value.personas[index],
                      );
                    },
                  );
                },
                child: AnimatedContainer(
                  height: 100,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    title: Text(
                      value.personas[index].name!,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: value.personas[index].keysList!.isEmpty
                        ? const Text('No personas yet')
                        : Text(
                            '${value.personas[index].keysList!.length} personas',
                            style: Theme.of(context).textTheme.caption,
                          ),
                    trailing: StackedAvatars(
                      imageRadius: 30,
                      totalCount:
                          value.personas[index].personasSharedWith?.length ?? 0,
                      imageList: List<String?>.generate(
                          value.personas[index].personasSharedWith?.length ?? 0,
                          (int _i) => value
                              .personas[index].personasSharedWith!.values
                              .toList()[_i]),
                    ),
                  ),
                ),
              ),
            );
    });
  }
}
