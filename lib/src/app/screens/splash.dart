// 🐦 Flutter imports:
// 📦 Package imports:
import 'package:at_client/src/util/network_util.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_onboarding_flutter/services/onboarding_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import '../../core/services/instances.dart';
import '../../meta/components/globals.dart';
import '../../meta/extensions/logger.ext.dart';
import '../constants/assets.dart';
import '../constants/page_route_name.dart';
import '../provider/notifiers/user_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppLogger _logger = AppLogger('SplashScreen');
  final OnboardingService _os = OnboardingService.getInstance();
  String? msg;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> _init({Function? onFailure}) async {
    try {
      String? _currentAtSign;
      AtClientPreference? _preference;
      bool onboarded = false;
      Map<String, bool?> atSigns =
          await KeyChainManager.getInstance().getAtsignsWithStatus();
      if (atSigns.isNotEmpty) {
        bool _isNetworkavailable = await NetworkUtil.isNetworkAvailable();
        if (!_isNetworkavailable) {
          await showToast(context, 'No internet connection found',
              isError: true);
        }
        while (!await NetworkUtil.isNetworkAvailable()) {
          setState(() => msg = 'No internet');
          await Future<void>.delayed(const Duration(milliseconds: 3000));
        }
        _currentAtSign = atSigns.keys.firstWhere(
            (String key) => atSigns[key] == true,
            orElse: () => throw 'No AtSigns found');
        setState(() => msg = 'Authenticating...');
        context.read<UserData>().currentAtSign = _currentAtSign;
        _preference =
            await ServiceInstances.sdkServices.getAtClientPreferences();
        context.read<UserData>().setAtOnboardingPreference = _preference
          ..privateKey = await KeyChainManager.getInstance()
              .getEncryptionPrivateKey(_currentAtSign);
        _preference = context.read<UserData>().atOnboardingPreference;
        _os.setAtClientPreference = _preference;
        onboarded = await _os.onboard();
        context.read<UserData>().authenticated = onboarded;
        if (!onboarded) {
          setState(() => msg = null);
          await showToast(_scaffoldKey.currentContext,
              'Auto login failed. Please onboard with at sign again.',
              isError: true);
        }
      } else {
        setState(() => msg = null);
        await Future<void>.delayed(const Duration(milliseconds: 3200));
      }
      _logger.finer('Checking done...');
      setState(() => msg = null);
      if (mounted) {
        await Navigator.pushReplacementNamed(
            context, onboarded ? PageRoutes.loading : PageRoutes.onboard);
      }
    } catch (e, s) {
      _logger.severe(e.toString(), e, s);
      if (onFailure != null) {
        onFailure();
      }
      return;
    }
  }

  @override
  void initState() {
    Future<void>.delayed(Duration.zero, () async {
      // if (mounted && MediaQuery.of(context).size.width >= 500) {
      //   await Navigator.pushReplacementNamed(
      //       context, PageRouteNames.mobileDeviceScreen);
      //   return;
      // }
      await _init(onFailure: _init);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              Assets.logo,
              height: 200,
            ),
          ),
          if (msg != null) const VSpacer(30),
          if (msg != null)
            Text(
              msg!,
              style: Theme.of(context).textTheme.bodyText1!,
            ),
        ],
      ),
    );
  }
}
