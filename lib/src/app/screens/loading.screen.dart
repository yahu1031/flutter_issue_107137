import 'dart:typed_data';

import 'package:at_base2e15/at_base2e15.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/instances.dart';
import '../../meta/components/adaptive/adaptive_loading.dart';
import '../../meta/components/globals.dart';
import '../../meta/components/set_propic.dart';
import '../../meta/components/sync_indicator.dart';
import '../../meta/extensions/logger.ext.dart';
import '../../meta/utils/buzz_env.dart';
import '../constants/assets.dart';
import '../constants/page_route_name.dart';
import '../provider/notifiers/user_data.dart';
import '../provider/user_data.listener.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final AppLogger _logger = AppLogger('LoadingScreen');

  String _message = 'Loading data...';

  bool _loading = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _loadData({Function? onFailed}) async {
    try {
      setState(() => _message = 'Initializing maps...');
      await ServiceInstances.appServices.mapsInit();
      setState(() => _message = 'Starting monitor...');
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await ServiceInstances.sdkServices.startMonitor();
      setState(() => _message = 'Setting up your atsign...');
      await ServiceInstances.atClientManager.setCurrentAtSign(
          context.read<UserData>().currentAtSign,
          BuzzEnv.appNamespace,
          context.read<UserData>().atOnboardingPreference);
      setState(() => _message = 'Syncing data, Please wait...');
      ServiceInstances.sdkServices.syncData();
      // while (true) {
      //   if (context.read<UserData>().syncStatus == SyncStatus.started) {
      //     await Future<void>.delayed(const Duration(milliseconds: 100));
      //   } else {
      //     break;
      //   }
      // }
      await ServiceInstances.sdkServices.waitForSync();
      setState(() => _message = 'Fetching your data...');
      String? _profilePic = await ServiceInstances.sdkServices.getProPic();
      if (_profilePic != null) {
        context.read<UserData>().currentProfilePic =
            Base2e15.decode(_profilePic);
      } else {
        Uint8List _avatar = await ServiceInstances.appServices
            .readLocalfilesAsBytes(Assets.randomAvatar);
        await showModalBottomSheet(
          backgroundColor: Colors.transparent,
          isScrollControlled: false,
          isDismissible: false,
          enableDrag: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          context: _scaffoldKey.currentContext!,
          builder: (_) {
            return SetProPic(_avatar);
          },
        );
      }
      setState(() => _message = 'Fetching connections...');
      context.read<UserData>().connections =
          await ServiceInstances.appServices.getAllContacts();
      setState(() => _message = 'Fetching personas...');
      await ServiceInstances.personaServices.getAllPersonas();
      setState(() => _loading = false);
      setState(() => _message = 'Done \u{1F643}');
      Future<void>.delayed(const Duration(milliseconds: 1200), () {
        Navigator.of(context).pushReplacementNamed(PageRoutes.home);
      });
    } on Exception catch (e, s) {
      _logger.severe('Failed to load data : $e', e, s);
      await showToast(_scaffoldKey.currentContext, e.toString(), isError: true);
      if (onFailed != null) {
        onFailed();
      }
    }
  }

  @override
  void initState() {
    Future<void>.microtask(() async => _loadData(onFailed: _loadData));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          UserDataListener(
            builder: (_, __) => SquareWidget(
              50,
              child: Center(
                child: SyncIndicator(size: 15),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_loading) const AdaptiveLoading(),
            if (_loading) const VSpacer(30),
            Text(
              _message,
              style: _message.startsWith('Done')
                  ? Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 24)
                  : Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
