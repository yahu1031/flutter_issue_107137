// 🐦 Flutter imports:
// 📦 Package imports:

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tabler_icons/tabler_icons.dart';

// 🌎 Project imports:
import '../../../core/services/instances.dart';
import '../../../meta/components/globals.dart';
import '../../../meta/components/paints/tab_indicator.dart';
import '../../../meta/components/sheets/add_connection.dart';
import '../../../meta/components/sheets/add_persona.dart';
import '../../../meta/components/sync_indicator.dart';
import '../../constants/page_route_name.dart';
import '../../provider/notifiers/user_data.dart';
import '../../provider/user_data.listener.dart';
import 'tabs/connections.dart';
import 'tabs/personas.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _title = 'Connections';
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this,
    );
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My ' + _title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              isMobile && !isTablet(context)
                  ? await showModalBottomSheet(
                      isScrollControlled: true,
                      enableDrag: false,
                      isDismissible: true,
                      context: context,
                      shape: _tabController.index.isEven
                          ? null
                          : RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                      builder: (_) {
                        return _tabController.index.isEven
                            ? const AddConnectionSheet()
                            : const AddPersonaSheet();
                      })
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
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Center(
                              child: _tabController.index.isEven
                                  ? const AddConnectionSheet()
                                  : const AddPersonaSheet(),
                            ),
                          ),
                        );
                      });
            },
            icon: const Icon(
              TablerIcons.plus,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () async =>
                Navigator.pushNamed(context, PageRoutes.notifications),
            icon: Icon(
              isIOS || isMacOS ? TablerIcons.notification : TablerIcons.bell,
              color: Colors.black,
            ),
          ),
          if (!isMobile && isTablet(context))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: UserDataListener(
                  builder: (BuildContext context, UserData value) {
                return SyncIndicator(
                  size: 50,
                  child: GestureDetector(
                    onTap: ServiceInstances.sdkServices.syncData,
                    child: Hero(
                      transitionOnUserGestures: true,
                      tag: 'propic',
                      child: ClipOval(
                        child: Image(
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                          image: Image.memory(value.currentProfilePic).image,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            )
        ],
        leading: !isTablet(context)
            ? UserDataListener(builder: (BuildContext context, UserData value) {
                return SyncIndicator(
                  size: 50,
                  child: GestureDetector(
                    onTap: () async =>
                        Navigator.pushNamed(context, PageRoutes.profile),
                    child: Hero(
                      transitionOnUserGestures: true,
                      tag: 'propic',
                      child: ClipOval(
                        child: Image(
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                          image: Image.memory(value.currentProfilePic).image,
                        ),
                      ),
                    ),
                  ),
                );
              })
            : null,
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        dragStartBehavior: DragStartBehavior.start,
        children: <Widget>[
          const ConnectionsScreen(),
          const PersonasScreen(),
        ],
      ),
      bottomNavigationBar: !isTablet(context) || isMobile
          ? BottomAppBar(
              child: Container(
                height: 50,
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: TabBar(
                    controller: _tabController,
                    indicator: CircleTabIndicator(
                      color: Theme.of(context).primaryColor,
                      radius: 3,
                    ),
                    automaticIndicatorColorAdjustment: true,
                    indicatorPadding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.15),
                    onTap: (_) {
                      setState(() {
                        _ == 0 ? _title = 'Connections' : _title = 'Personas';
                      });
                    },
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(
                          TablerIcons.home,
                          color: Theme.of(context).primaryColor.withOpacity(
                              _tabController.index.isEven ? 1 : 0.5),
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          TablerIcons.id,
                          color: Theme.of(context).primaryColor.withOpacity(
                              _tabController.index.isOdd ? 1 : 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
