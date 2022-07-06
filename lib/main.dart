// 🎯 Dart imports:
import 'dart:async';
import 'dart:developer';
import 'dart:io';

// � Package imports:
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'src/app/constants/page_route_name.dart';
import 'src/app/provider/notifiers/user_data.dart';
import 'src/app/provider/providers.dart';
import 'src/app/screens/home/home.dart';
import 'src/app/screens/loading.screen.dart';
import 'src/app/screens/notifications.dart';
import 'src/app/screens/onboard/activating.screen.dart';
import 'src/app/screens/onboard/get_atsign.screen.dart';
import 'src/app/screens/onboard/onboarding.screen.dart';
import 'src/app/screens/onboard/qr.screen.dart';
import 'src/app/screens/profile.screen.dart';
import 'src/app/screens/splash.dart';
import 'src/core/services/app_services.dart';
import 'src/core/services/instances.dart';
import 'src/meta/components/globals.dart';
import 'src/meta/extensions/logger.ext.dart';
import 'src/meta/utils/buzz_env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await KeyChainManager.getInstance().clearKeychainEntries();
  AppLogger.rootLevel = 'finer';
  await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);
  String _logsPath =
      p.join(await ServiceInstances.appServices.getSuportDirPath(), 'logs');
  logFileLocation = _logsPath;
  log(_logsPath);
  if (!await Directory(_logsPath).exists()) {
    await Directory(_logsPath).create(recursive: true);
  }
  await BuzzEnv.loadEnv();
  await AppService.getInstance().checkFirstRun();
  runApp(
    const MultiProviders(
      child: MyApp(),
    ),
  );
  if (isDesktop) {
    doWhenWindowReady(() {
      Size initialSize = const Size(750, 750);
      appWindow.minSize = const Size(350, 750);
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLogger _logger = AppLogger('MyApp');

  @override
  void initState() {
    _logger.finer('Started initializing the app...');
    Future<void>.microtask(
      () async {
        await ServiceInstances.sdkServices.init(context.read<UserData>());
        String _path = await ServiceInstances.appServices.getSuportDirPath();
        String _downloadsPath = p.join(_path, 'downloads');
        if (!await Directory(_downloadsPath).exists()) {
          await Directory(_downloadsPath).create(recursive: true);
          _logger.finer('Created downloads directory at $_downloadsPath');
        }
        AtClientPreference _preference =
            await ServiceInstances.sdkServices.getAtClientPreferences();
        context.read<UserData>().setAtOnboardingPreference = _preference;
        ServiceInstances.onboardingService.setAtClientPreference = _preference;
      },
    );
    _logger.finer('Initializing the app successfully completed.');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buzz app',
      // showPerformanceOverlay: true,
      debugShowCheckedModeBanner: false,
      navigatorKey: navKey,
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        primarySwatch: Colors.blue,
      ),
      initialRoute: PageRoutes.splash,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case PageRoutes.splash:
            return pageTransision(
              settings,
              const SplashScreen(),
            );
          case PageRoutes.onboard:
            return pageTransision(
              settings,
              const OnboardingScreen(),
            );
          case PageRoutes.qr:
            return pageTransision(
              settings,
              const QRScreen(),
            );
          case PageRoutes.loading:
            return pageTransision(
              settings,
              const LoadingScreen(),
            );
          case PageRoutes.getAtSign:
            return pageTransision(
              settings,
              const GetAtSignScreen(),
            );
          case PageRoutes.activatingAtSign:
            return pageTransision(
              settings,
              const ActivatingAtSignScreen(),
            );
          case PageRoutes.home:
            return pageTransision(
              settings,
              const HomeScreen(),
            );
          case PageRoutes.profile:
            return pageTransision(
              settings,
              const ProfileScreen(),
            );
          case PageRoutes.notifications:
            return pageTransision(
              settings,
              const NotificationsScreen(),
            );
          default:
            return pageTransision(
              settings,
              const SplashScreen(),
            );
        }
      },
    );
  }
}
