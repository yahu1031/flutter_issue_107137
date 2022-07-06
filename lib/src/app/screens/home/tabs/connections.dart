import 'package:flutter/material.dart';

import '../../../../meta/components/connection_tile.dart';
import '../../../../meta/components/globals.dart';
import '../../../../meta/components/sheets/details/connection_details.dart';
import '../../../provider/notifiers/user_data.dart';
import '../../../provider/user_data.listener.dart';

class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return UserDataListener(
      builder: (BuildContext context, UserData value) {
        return value.connections.isEmpty
            ? const Center(
                child: Text('No connections yet'),
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
                itemCount: value.connections.length,
                itemBuilder: (BuildContext context, int index) =>
                    AnimatedConnectionTile(
                  connection: value.connections[index],
                  index: index,
                  onTap: () async {
                    !isTablet(context)
                        ? await showModalBottomSheet(
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
                              return ConnectionDetails(
                                connection: value.connections[index],
                              );
                            },
                          )
                        : await showDialog(
                            context: context,
                            builder: (_) {
                              return Dialog(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                elevation: 0,
                                // backgroundColor: Colors.transparent,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Center(
                                    child: ConnectionDetails(
                                      isDialog: true,
                                      connection: value.connections[index],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              );
      },
    );
  }
}
