// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_onboarding_flutter/services/onboarding_service.dart';
import 'package:at_onboarding_flutter/utils/response_status.dart';
import 'package:at_server_status/at_server_status.dart';

// 🌎 Project imports:
import '../../meta/extensions/logger.ext.dart';
import '../../meta/utils/buzz_env.dart';
import '../services/app_services.dart';
import '../services/instances.dart';

class OnboardServices {
  static final OnboardServices _singleton = OnboardServices._internal();
  final AppLogger _logger = AppLogger('SDK services');

  OnboardServices._internal();

  factory OnboardServices() {
    return _singleton;
  }

  /// Returns the current status of the @sign.
  Future<AtStatus> getAtSignStatus(String atSign) async =>
      AtStatusImpl().get(atSign);

  /// Onboard the app with an @sign and return the response as bool
  Future<ResponseStatus> onboardWithAtKeys(
      String atSign, String keysData) async {
    _logger.finer('Onboarding with @sign: $atSign using atKeys file');
    try {
      dynamic status = await ServiceInstances.onboardingService.authenticate(
          atSign,
          jsonData: keysData,
          decryptKey: json.decode(keysData)[atSign]);
      _logger.finer('Onboarding with atKeys file result: $status');
      return status;
    } on Exception catch (e, s) {
      _logger.severe('Error onboarding with @sign: $atSign', e, s);
      return ResponseStatus.authFailed;
    }
  }

  /// Returns the current status of the @sign.
  Future<bool> actiavteAtSign(
      String atSign, AtClientPreference preference) async {
    try {
      _logger.finer('Activating @sign: $atSign');
      ResponseStatus _cramAuthResponse = await OnboardingService.getInstance()
          .authenticate(atSign, cramSecret: preference.cramSecret);
      if (_cramAuthResponse.name == 'authSuccess') {
        _logger.finer('CRAM authentication success');
        Map<String, String> keyData = await AppService.getInstance().getKeysFileData(atSign);
        ResponseStatus _pkamAuthResponse =
            await onboardWithAtKeys(atSign, jsonEncode(keyData));
        _logger.finer('PKAM authentication result: ${_pkamAuthResponse.name}');
        _pkamAuthResponse.name == 'authSuccess'
            ? await AtClientManager.getInstance()
                .setCurrentAtSign(atSign, BuzzEnv.appNamespace, preference)
            : null;
        return _pkamAuthResponse.name == 'authSuccess';
      } else {
        return false;
      }
    } on Exception catch (e) {
      Exception('Error while activating @sign : ' + e.toString());
      return false;
    }
  }
}
