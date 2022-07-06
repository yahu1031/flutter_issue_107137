import 'package:at_base2e15/at_base2e15.dart';
import 'package:flutter/material.dart';
import 'package:tabler_icons/tabler_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/connection.model.dart';
import '../../buttons/circular_icon_button.dart';
import '../../globals.dart';
import '../modal_sheet.dart';

class ConnectionDetails extends StatefulWidget {
  const ConnectionDetails({
    Key? key,
    required this.connection,
    this.isDialog = false,
  }) : super(key: key);
  final Connection connection;
  final bool isDialog;
  @override
  State<ConnectionDetails> createState() => _ConnectionDetailsState();
}

class _ConnectionDetailsState extends State<ConnectionDetails> {
  @override
  Widget build(BuildContext context) {
    return ModalSheetBody(
      curvedBottom: widget.isDialog,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: widget.connection.profilePicture == null
                          ? const Icon(
                              TablerIcons.user,
                              size: 30,
                            )
                          : Image.memory(
                              Base2e15.decode(widget
                                  .connection.profilePicture!.value!.value),
                            ),
                    ),
                  ),
                ),
                const HSpacer(20),
                Container(
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.connection.tags!['nickName'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.connection.atSign!,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                const HSpacer(15),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(TablerIcons.share),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(TablerIcons.star),
                ),
              ],
            ),
            const VSpacer(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircularIconButton(
                  bgColor: widget.connection.phoneNumber == null
                      ? Colors.grey.shade200
                      : Colors.lightBlue.shade50,
                  iconColor: widget.connection.phoneNumber == null
                      ? Colors.grey
                      : Colors.lightBlue,
                  icon: TablerIcons.phone,
                  onPressed: widget.connection.phoneNumber == null
                      ? () {}
                      : () async {
                          await launchUrl(Uri(
                              scheme: 'tel',
                              path: widget.connection.phoneNumber!));
                        },
                ),
                CircularIconButton(
                  icon: TablerIcons.message_circle_2,
                  bgColor: widget.connection.phoneNumber == null
                      ? Colors.grey.shade200
                      : Colors.lightGreen.shade50,
                  iconColor: widget.connection.phoneNumber == null
                      ? Colors.grey
                      : Colors.lightGreen,
                  onPressed: widget.connection.phoneNumber == null
                      ? () {}
                      : () async {
                          await launchUrl(Uri(
                            scheme: 'sms',
                            path: widget.connection.phoneNumber!,
                          ));
                        },
                ),
                CircularIconButton(
                  icon: TablerIcons.mail,
                  bgColor: widget.connection.email == null
                      ? Colors.grey.shade200
                      : Colors.red.shade50,
                  iconColor: widget.connection.email == null
                      ? Colors.grey
                      : Colors.red,
                  onPressed: widget.connection.email == null
                      ? () {}
                      : () async {
                          await launchUrl(
                            Uri(
                              scheme: 'mailto',
                              path: widget.connection.email!,
                            ),
                          );
                        },
                ),
              ],
            ),
            const VSpacer(20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Personas shared',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const VSpacer(20),
            Center(
              child: widget.connection.personas!.isEmpty
                  ? const Text('No personas')
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: widget.connection.personas?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Container(
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.lightBlue.shade50,
                            ),
                            child: Center(
                              child: Text(
                                widget.connection.personas![index],
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
