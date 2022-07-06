import 'package:flutter/material.dart';

import '../../../app/constants/constants.dart';
import '../../models/index_tuple.dart';
import '../dictionary_card.dart';

// class DictionarySheet extends StatefulWidget {
//   const DictionarySheet({Key? key}) : super(key: key);

//   @override
//   State<DictionarySheet> createState() => _DictionarySheetState();
// }

// class _DictionarySheetState extends State<DictionarySheet> {
//   @override
//   Widget build(BuildContext context) {
//     return ModalSheetBody(
//       child: Container(
//         height: MediaQuery.of(context).size.height * 0.5,
//         // width: MediaQuery.of(context).size.width,
//         // height: MediaQuery.of(context).size.height * 0.7,
//         // padding: EdgeInsets.only(
//         //   top: 20,
//         //   bottom: MediaQuery.of(context).viewInsets.bottom,
//         //   right: 7,
//         //   left: 7,
//         // ),
//         // decoration: BoxDecoration(
//         //   color: Colors.grey[200],
//         //   borderRadius: const BorderRadius.only(
//         //     topLeft: Radius.circular(15),
//         //     topRight: Radius.circular(15),
//         //   ),
//         // ),
//         child: Center(
//           child: Column(
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 18.0),
//                 child: Text(
//                   'Select a Persona',
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//               ),
//             ],
//           ),
//           // GridView.count(
//           //   crossAxisCount: 3,
//           //   physics: const BouncingScrollPhysics(),
//           //   padding: const EdgeInsets.all(7),
//           //   mainAxisSpacing: 7,
//           //   crossAxisSpacing: 7,
//           //   children: List<Widget>.generate(
//           //     Constants.allPersonas.length,
//           //     (int index) => CardWidget(
//           //       icon: Constants.allPersonas[index].icon,
//           //       text: Constants.allPersonas[index].name,
//           //     ),
//           //   ),
//           // ),
//           //   ],
//           // ),
//         ),
//       ),
//     );
//   }
// }
class DictionarySheet extends StatefulWidget {
  const DictionarySheet(
      {required this.onTap, this.selectedIndex = -1, Key? key})
      : super(key: key);
  final ValueChanged<IndexTuple>? onTap;
  final int selectedIndex;
  @override
  State<DictionarySheet> createState() => _DictionarySheetState();
}

class _DictionarySheetState extends State<DictionarySheet> {
  bool validAtSign = false;
  late int selectedIndex;
  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.only(
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      // child: const InitialPersonaScreen(),
      child: GridView.count(
        crossAxisCount: 3,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(7),
        mainAxisSpacing: 7,
        crossAxisSpacing: 7,
        children: List<Widget>.generate(
          Constants.allPersonas.length,
          (int index) => CardWidget(
            icon: Constants.allPersonas[index].icon,
            text: Constants.allPersonas[index].name,
            onTap: () {
              setState(() {
                if (selectedIndex == index) {
                  selectedIndex = -1;
                } else {
                  selectedIndex = index;
                }
              });
              widget.onTap?.call(
                IndexTuple(
                  index: index,
                  value: Constants.allPersonas[index],
                ),
              );
            },
            selected: selectedIndex == index,
          ),
        ),
      ),
    );
  }
}
