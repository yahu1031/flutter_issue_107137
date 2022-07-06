// 🐦 Flutter imports:
// 📦 Package imports:
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:at_onboarding_flutter/utils/response_status.dart';
import 'package:at_server_status/at_server_status.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tabler_icons/tabler_icons.dart';

// 🌎 Project imports:
import '../../../app/constants/assets.dart';
import '../../../app/constants/page_route_name.dart';
import '../../../core/services/app_services.dart';
import '../../../core/services/instances.dart';
import '../../../core/sdk_services/sdk_services.dart';
import '../../../meta/components/adaptive/adaptive_loading.dart';
import '../../../meta/components/buttons/curved.button.dart';
import '../../../meta/components/file_upload_space.dart';
import '../../../meta/components/filled.textfield.dart';
import '../../../meta/components/globals.dart';
import '../../../meta/extensions/logger.ext.dart';
import '../../../meta/extensions/string.ext.dart';
import '../../constants/constants.dart';
import '../../provider/notifiers/user_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin<OnboardingScreen> {
  final AppLogger _logger = AppLogger('OnboardingScreen');
  late final TextEditingController _atSignController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _atSign, _oldAtSign, fileName;
  bool _uploadKeys = false, _checking = false, _uploading = false;
  late AnimationController loadingController;
  late FocusNode _atSignFocus;
  final SdkServices _sdkServices = SdkServices.getInstance();
  Set<PlatformFile> _platformFiles = <PlatformFile>{};
  String? _atKeysData;

  Future<void> login() async {
    if (_platformFiles.isEmpty) {
      await showToast(context, 'Please select a file to upload', isError: true);
      return;
    }
    setState(() => _checking = true);
    try {
      context.read<UserData>().disposeUser();
      bool _alreadyExists = await _alreadyLoggedin();
      if (_alreadyExists) {
        await showToast(
            _scaffoldKey.currentContext, 'User account already exists.',
            isError: true);
      } else {
        setState(() => _checking = true);
        Map<String, dynamic> _atkeysDataMap = jsonDecode(_atKeysData!);
        if (_atkeysDataMap.keys.last != _atSign) {
          await showToast(_scaffoldKey.currentContext,
              '@sign doesn\'t match with .atKeys file.',
              isError: true);
          setState(() => _checking = false);
          return;
        }
        ResponseStatus status =
            await _sdkServices.onboardWithAtKeys(_atSign!, _atKeysData!);
        context.read<UserData>().authenticated = status.name == 'authSuccess';
        if (status.name == 'authSuccess') {
          _platformFiles.clear();
          _atKeysData?.clear();
          context.read<UserData>().currentAtSign = _atSign!;
          setState(() => _checking = false);
          await Navigator.pushReplacementNamed(context, PageRoutes.loading);
        } else if (status == ResponseStatus.authFailed) {
          _platformFiles.clear();
          _atKeysData?.clear();
          setState(() => _checking = false);
          await showToast(_scaffoldKey.currentContext,
              'Failed to authenticate. Please pick files and try again.',
              isError: true);
        } else if (status == ResponseStatus.serverNotReached ||
            status == ResponseStatus.timeOut) {
          _platformFiles.clear();
          _atKeysData?.clear();
          setState(() => _checking = false);
          await showToast(_scaffoldKey.currentContext,
              'Unable to reach server. Please try again later.',
              isError: true);
        }
      }
    } on FileSystemException catch (e, s) {
      _platformFiles.clear();
      _atKeysData?.clear();
      setState(() => _checking = false);
      _logger.severe('FileSystemException: ${e.toString}', e, s);
      await showToast(_scaffoldKey.currentContext,
          e.message + '😥. Please upload the atKeys file again.',
          isError: true);
    } catch (e, s) {
      _platformFiles.clear();
      _atKeysData?.clear();
      setState(() => _checking = false);
      await showToast(_scaffoldKey.currentContext, 'Authentication failed',
          isError: true);
      _logger.severe('Authentication failed', e, s);
      log('Authentication failed', error: e, stackTrace: s);
    }
  }

  Future<bool> _alreadyLoggedin() async {
    setState(() {
      _checking = true;
    });
    bool _atSignLoggedIn = await ServiceInstances.sdkServices
        .checkIfAtSignExistInDevice(
            _atSign!, context.read<UserData>().atOnboardingPreference);
    if (_atSignLoggedIn) {
      bool onboarded = await ServiceInstances.onboardingService.onboard();
      if (onboarded) {
        setState(() {
          _checking = false;
        });
        await Navigator.pushReplacementNamed(context, PageRoutes.loading);
      }
    } else {
      setState(() {
        _checking = false;
      });
    }
    return _atSignLoggedIn;
  }

  Future<void> uploadAtKeys(Set<PlatformFile> _l) async {
    if (_l.isEmpty) {
      setState(() {
        fileName = null;
        _uploading = false;
        _platformFiles = _l;
      });
      await showToast(_scaffoldKey.currentContext, 'No file selected');
      return;
    } else {
      setState(() {
        _platformFiles = _l;
        fileName = _l.first.name;
      });
    }
    _atKeysData = await AppService.getInstance()
        .readAtKeysFile(_platformFiles.first.path!);
    setState(() => _uploading = false);
  }

  @override
  void initState() {
    loadingController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _atSignController = TextEditingController();
    _atSignFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _checking = false;
    loadingController.dispose();
    _atSignController.dispose();
    _atSignFocus.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: Image.asset(
                          Assets.atLogo,
                          color: Colors.blue,
                          height: 170,
                          width: 170,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Control access to your data with\nyour own unique digital ID.\nEnter your @Sign.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: _uploadKeys ? 150 : 40,
                    width: _uploadKeys ? 300 : 250,
                    child: _uploadKeys ? _atKeysUploadSpace() : _atSignField(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          primary: Colors.blue,
                          padding: const EdgeInsets.all(10),
                          splashFactory: NoSplash.splashFactory,
                        ),
                        onPressed:
                            _checking || (_atSign == null || _atSign!.isEmpty)
                                ? null
                                : _uploadKeys
                                    ? login
                                    : _getAtSignStatus,
                        child: _checking
                            ? const AdaptiveLoading(
                                strokeWidth: 2,
                                size: 20,
                                color: Colors.blue,
                              )
                            : Text(_uploadKeys ? 'Onboard' : 'Connect'),
                      ),
                      const VSpacer(10),
                      CurvedButton(
                        textStyle: const TextStyle(color: Colors.blue),
                        onPressed: () async {
                          setState(() => _checking = false);
                          await Navigator.pushNamed(
                              context, PageRoutes.getAtSign);
                          setState(() => _uploadKeys = false);
                        },
                        text: 'Get an @sign',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, PageRoutes.qr);
                },
                icon: const Icon(TablerIcons.qrcode),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
              top: 10,
              right: 10,
            ),
          ],
        ),
      ),
    );
  }

  /// Check if the @sign is valid or not.
  Future<void> _getAtSignStatus() async {
    try {
      setState(() {
        _checking = true;
        _atSign = '@' + _atSignController.text.trim();
      });
      _atSignFocus.unfocus();
      AtStatus _atSignStatus =
          await SdkServices.getInstance().getAtSignStatus(_atSign!);
      setState(() {
        _checking = false;
        _uploadKeys = _atSignStatus.rootStatus == RootStatus.found;
      });
    } on Exception catch (e) {
      await showToast(context, e.toString(), isError: true);
    }
  }

  FilledTextField _atSignField() {
    return FilledTextField(
      autocorrect: false,
      focusNode: _atSignFocus,
      onChanged: (_) {
        setState(() {
          _atSign = '@' + _atSignController.text.trim();
        });
        if (_platformFiles.isNotEmpty) {
          setState(() {
            _platformFiles.clear();
            _uploadKeys = false;
            _atSign = '@' + _atSignController.text.trim();
          });
        }
      },
      onFieldSubmitted: (_) {
        if (_atSign != _oldAtSign) {
          setState(() {
            _platformFiles.clear();
            _atSign = '@' + _atSignController.text.trim();
          });
        } else {
          setState(() {
            _atSign = '@' + _atSignController.text.trim();
          });
        }
      },
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Enter your @sign',
        prefixText: '@',
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        fillColor: Colors.grey[200],
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(
          RegExp(Constants.atSignPattern),
        ),
      ],
      textCapitalization: TextCapitalization.none,
      controller: _atSignController,
    );
  }

  FileUploadSpace _atKeysUploadSpace() {
    return FileUploadSpace(
      size: const Size(300, 150),
      onTap: (_) async {
        setState(() => _uploading = true);
        await uploadAtKeys(_);
      },
      assetPath: Assets.atKeys,
      uploadMessage:
          _platformFiles.isEmpty ? 'Upload your atKeys file.' : fileName,
      dismissable: !_uploading,
      isUploading: _uploading,
      onDismmisTap: () {
        _platformFiles.clear();
        setState(() {
          _uploadKeys = false;
        });
      },
    );
  }
}
