// 🐦 Flutter imports:

// � Package imports:

//  Package imports:
import 'package:at_base2e15/at_base2e15.dart';
import 'package:at_server_status/at_server_status.dart';
// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import '../../../core/sdk_services/onboarding.dart';
import '../../../core/sdk_services/sdk_services.dart';
import '../../../core/services/app_services.dart';
import '../../../meta/components/globals.dart';
import '../../../meta/extensions/logger.ext.dart';
import '../../../meta/models/buzz_key.model.dart';
import '../../../meta/models/buzz_value.model.dart';
import '../../../meta/models/qr.dart';
import '../../../meta/theme/theme_colors.dart';
import '../../constants/keys.dart';
import '../../constants/page_route_name.dart';
import '../../provider/notifiers/new_user.dart';
import '../../provider/notifiers/user_data.dart';

// � Flutter imports:

// 🌎 Project imports:
class ActivatingAtSignScreen extends StatefulWidget {
  const ActivatingAtSignScreen({Key? key}) : super(key: key);

  @override
  State<ActivatingAtSignScreen> createState() => _ActivatingAtSignScreenState();
}

class _ActivatingAtSignScreenState extends State<ActivatingAtSignScreen>
    with SingleTickerProviderStateMixin {
  final AppService _appService = AppService.getInstance();
  final AppLogger _logger = AppLogger('ActivatingAtSignScreen');
  SdkServices sdk = SdkServices.getInstance();
  final BuzzKey _buzzKey = const BuzzKey();
  AtStatus? status;
  final OnboardServices _onboardServices = OnboardServices();
  String content = 'Fetching @sign...';
  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  late final CurvedAnimation _curve = CurvedAnimation(
    parent: controller,
    curve: Curves.easeOut,
  );
  late final Animation<double> _smallDiscAnimation = Tween<double>(
    begin: 0.0,
    end: 75,
  ).animate(_curve);
  late final Animation<double> _mediumDiscAnimation = Tween<double>(
    begin: 0.0,
    end: 137.5,
  ).animate(_curve);
  late final Animation<double> _bigDiscAnimation = Tween<double>(
    begin: 0.0,
    end: 200,
  ).animate(_curve);
  late final Animation<double> _alphaAnimation = Tween<double>(
    begin: 0.30,
    end: 0.0,
  ).animate(controller);

  Future<void> _statusListener(_) async {
    if (controller.status == AnimationStatus.completed) {
      if (mounted) {
        controller.reset();
        await controller.forward();
      }
    }
  }

  @override
  void initState() {
    _buzzKey.copyWith(
        sharedWith: context.read<NewUser>().getQrData.atSign,
        sharedBy: context.read<NewUser>().getQrData.atSign,
        value: BuzzValue(
          value: Base2e15.encode(context.read<NewUser>().newUserData['img']),
          type: 'profilepic',
        ));
    Future<void>.microtask(
      () async {
        await _appService.checkPermission(<Permission>[
          Permission.storage,
          Permission.photos,
          Permission.manageExternalStorage
        ]);
        controller.addStatusListener(_statusListener);
        String _atSign = context.read<NewUser>().getQrData.atSign;
        content = 'fetching $_atSign status...';
        bool _keySaved = false;
        if (mounted) {
          controller.reset();
          await controller.forward();
        }
        status = await _onboardServices.getAtSignStatus(_atSign);
        setState(() {});
        if (status?.serverStatus != ServerStatus.activated) {
          setState(() {
            content = 'Activating $_atSign...';
          });
          bool activationResponse = await _onboardServices.actiavteAtSign(
              _atSign, context.read<UserData>().atOnboardingPreference);
          _logger.finer('$_atSign activation response : $activationResponse');
          context.read<UserData>().authenticated = activationResponse;
          if (activationResponse) {
            status = await _onboardServices.getAtSignStatus(_atSign);
            content = 'Activated $_atSign.\nPolishing your account...';
            _logger.finer('Activated $_atSign. Polishing your account...');
            BuzzKey _proPicKey = Keys.profilePicKey;
            BuzzKey _profilePicKey = _proPicKey.copyWith(
              sharedBy: _atSign,
              sharedWith: _atSign,
              createdDate: DateTime.now(),
              value: BuzzValue(
                value:
                    Base2e15.encode(context.read<NewUser>().newUserData['img']),
                type: 'profilepic',
                labelName: 'profilepic',
                createdAt: DateTime.now(),
                isPublic: true,
                namespaceAware: true,
                availableAt: DateTime.now(),
              ),
            );
            bool _propicUpdated = await sdk.put(_profilePicKey);
            if (_propicUpdated) {
              await sdk.startMonitor();
              context.read<UserData>().currentAtSign = _atSign;
              context.read<UserData>().currentProfilePic =
                  context.read<NewUser>().newUserData['img'];
              _logger.finer('profile pic updated');
            } else {
              _logger.severe('profile pic not updated');
              await showToast(_scaffoldKey.currentContext,
                  'Failed to updated default profile pic',
                  isError: true);
            }
            RenderBox? box = context.findRenderObject() as RenderBox?;
            _keySaved = await _appService.saveAtKeys(
                _atSign,
                context.read<UserData>().atOnboardingPreference.downloadPath!,
                box!.size);
            setState(() {});
            await Future<void>.delayed(
              const Duration(milliseconds: 2500),
              () async {
                if (mounted) {
                  await showToast(
                      _scaffoldKey.currentContext,
                      _keySaved
                          ? 'AtKeys saved successfully'
                          : 'Failed to save atKeys file.',
                      isError: !_keySaved);
                }
              },
            );
            await sdk.waitForSync(() => setState(() {}));
            context.read<NewUser>().newUserData = <String, dynamic>{};
            context.read<NewUser>().setQrData =
                const QrModel(atSign: '', cramSecret: '');
            await Navigator.pushNamedAndRemoveUntil(
              context,
              PageRoutes.loading,
              ModalRoute.withName(PageRoutes.onboard),
            );
          } else {
            status = status?..rootStatus = RootStatus.error;
            content = 'Failed to activate $_atSign.';
            _logger.severe('Failed to activate $_atSign.');
            setState(() {});
            Future<void>.delayed(const Duration(milliseconds: 2000), () {
              if (mounted) {
                Navigator.of(context).pop();
                return;
              }
            });
          }
        } else if (status?.serverStatus == ServerStatus.activated) {
          content = '$_atSign is already activated.';
          _logger.warning('$_atSign is already activated.');
          setState(() {});
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            AnimatedBuilder(
              animation: _alphaAnimation,
              child: Image.memory(context.read<NewUser>().newUserData['img'],
                  height: 70),
              builder: (BuildContext context, Widget? wChild) {
                BoxDecoration decoration = BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: waveColors,
                    width: 3,
                  ),
                  color: waveColors,
                );
                return SizedBox(
                  height: 200,
                  width: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      AnimatedBuilder(
                        animation: _bigDiscAnimation,
                        builder: (BuildContext context, Widget? widget) {
                          num size = _bigDiscAnimation.value.clamp(
                            0.0,
                            double.infinity,
                          );
                          return Container(
                            height: size as double?,
                            width: size as double?,
                            decoration: decoration,
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _mediumDiscAnimation,
                        builder: (BuildContext context, Widget? widget) {
                          num size = _mediumDiscAnimation.value.clamp(
                            0.0,
                            double.infinity,
                          );
                          return Container(
                            height: size as double?,
                            width: size as double?,
                            decoration: decoration,
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _smallDiscAnimation,
                        builder: (BuildContext context, Widget? widget) {
                          num size = _smallDiscAnimation.value.clamp(
                            0.0,
                            double.infinity,
                          );
                          return Container(
                            height: size as double?,
                            width: size as double?,
                            decoration: decoration,
                          );
                        },
                      ),
                      wChild!,
                    ],
                  ),
                );
              },
            ),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color get waveColors => status?.serverStatus == ServerStatus.ready ||
          status?.serverStatus == ServerStatus.activated ||
          status?.serverStatus == ServerStatus.ready
      ? Theme.of(context).primaryColor.withOpacity(
            _alphaAnimation.value.clamp(
              0.0,
              1.0,
            ),
          )
      : status?.serverStatus == ServerStatus.teapot
          ? Colors.yellow[800]!.withOpacity(
              _alphaAnimation.value.clamp(
                0.0,
                1.0,
              ),
            )
          : status?.serverStatus == ServerStatus.error ||
                  status?.serverStatus == ServerStatus.stopped
              ? Colors.red.withOpacity(
                  _alphaAnimation.value.clamp(
                    0.0,
                    1.0,
                  ),
                )
              : AppTheme.disabled.withOpacity(
                  _alphaAnimation.value.clamp(
                    0.0,
                    1.0,
                  ),
                );
}
