// 🎯 Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:at_base2e15/at_base2e15.dart';
// 📦 Package imports:
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_onboarding_flutter/utils/response_status.dart';
import 'package:at_server_status/at_server_status.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart' as p;

// 🌎 Project imports:
import '../../app/constants/enums.dart';
import '../../app/provider/notifiers/user_data.dart';
import '../../meta/extensions/logger.ext.dart';
import '../../meta/extensions/string.ext.dart';
import '../../meta/models/buzz_key.model.dart';
import '../../meta/models/buzz_value.model.dart';
import '../../meta/utils/buzz_env.dart';
import '../services/instances.dart';

class SdkServices {
  late final UserData _userData;

  static late FlutterLocalNotificationsPlugin _notificationsPlugin;

  static final SdkServices _singleton = SdkServices._internal();
  SdkServices._internal();
  factory SdkServices.getInstance() {
    return _singleton;
  }

  static final AppLogger _logger = AppLogger('SdkServices');

  /// Initialize the [UserData].
  Future<void> init(UserData userData) async {
    try {
      _userData = userData;
      ServiceInstances.personaServices.init(userData);
      _notificationsPlugin = FlutterLocalNotificationsPlugin();
      if (Platform.isIOS) {
        await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: false,
              badge: true,
              sound: true,
            );
      }
      await _notificationsPlugin.initialize(
        InitializationSettings(
          android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification:
                (int id, String? title, String? body, String? payload) async {
              _logger
                  .finer('id $id, title $title, body $body, payload $payload');
            },
          ),
          macOS: const MacOSInitializationSettings(
            defaultPresentAlert: true,
            defaultPresentBadge: true,
            defaultPresentSound: true,
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          ),
        ),
        onSelectNotification: (String? payload) async {
          if (payload != null) {
            log('notification payload: ' + payload);
          }
        },
      );
      _logger.finer('initialiazed notification service');
    } on Exception catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      _logger.severe('failed to initialize notification service : $e', e, s);
    }
  }

  AtClientManager atClientManager = ServiceInstances.atClientManager;

  String? get currentAtSign =>
      atClientManager.atClient.getCurrentAtSign()?.formatAtSign();

  /// Check if user is onboarded and returns the result.
  Future<bool> checkIfAtSignExistInDevice(
      String atSign, AtClientPreference preference) async {
    _logger.finer('Checking if @sign exist in device: $atSign');
    bool isExists = await (ServiceInstances.onboardingService
          ..setAtsign = atSign
          ..setAtClientPreference = preference)
        .isExistingAtsign(atSign);
    _logger.finer('@sign exist in device: $isExists');
    return isExists;
  }

  /// Function to get [AtClientPreference].
  Future<AtClientPreference> getAtClientPreferences() async {
    String appDirPath = await ServiceInstances.appServices.getSuportDirPath();
    return AtClientPreference()
      ..commitLogPath = appDirPath
      ..hiveStoragePath = appDirPath
      ..downloadPath = p.join(appDirPath, 'downloads')
      ..syncRegex = BuzzEnv.syncRegex
      ..isLocalStoreRequired = true
      ..rootDomain = BuzzEnv.rootDomain
      ..namespace = BuzzEnv.appNamespace;
  }

  /// Get @sign status
  Future<AtStatus> getAtSignStatus(String atSign) async => AtStatusImpl(
        rootUrl: BuzzEnv.rootDomain,
      ).get(atSign);

  /// Function to setCurrentAtSign of the application.
  Future<void> setCurrentAtSign(String atSign, String namespace,
          AtClientPreference preference) async =>
      ServiceInstances.setAtClientManagerInstance = await ServiceInstances
          .atClientManager
          .setCurrentAtSign(atSign, namespace, preference);

  // --------------------- //
  //    Onboard & Login    //
  // --------------------- //

  /// Onboard the app with an @sign and return the response as bool
  Future<ResponseStatus> onboardWithAtKeys(
      String atSign, String keysData) async {
    _logger.finer('Onboarding with @sign: $atSign using atKeys file');
    try {
      ResponseStatus status = await ServiceInstances.onboardingService
          .authenticate(atSign,
              jsonData: keysData, decryptKey: jsonDecode(keysData)[atSign]);
      _logger.finer('Onboarding with atKeys file result: $status');
      return status;
    } on Exception catch (e, s) {
      _logger.severe('Error onboarding with @sign: $atSign', e, s);
      return ResponseStatus.authFailed;
    }
  }

  /// Function to logout the user
  Future<bool> logout() async {
    AtClientPreference? _pref = atClientManager.atClient.getPreferences();
    if (_pref != null) {
      try {
        _logger.finer('Stopping app notification monitor');
        atClientManager.notificationService.stopAllSubscriptions();
        ServiceInstances.onboardingService.setAtClientPreference =
            AtClientPreference();
        atClientManager.atClient.setPreferences(AtClientPreference());
        await KeyChainManager.getInstance().clearKeychainEntries();
        _userData.disposeUser();
        _userData.dispose();
        return true;
      } on Exception catch (e, s) {
        _logger.severe('Error while logging out: $e', e, s);
        return false;
      }
    } else {
      _logger.severe('Error while logging out: AtClient preference is null');
      return false;
    }
  }

  // --------------------- //
  //    Other services     //
  // --------------------- //

  Future<void> acceptStream(AtNotification response) async {
    try {
      if (response.value == null) {
        return;
      } else {
        syncData();
        AtNotification atNotification = response;
        if (atNotification.operation == 'update' &&
            atNotification.to == ServiceInstances.atClient.getCurrentAtSign() &&
            (atNotification.key.contains('added_to_connections') ||
                atNotification.key.contains('shared_a_persona') ||
                (atNotification.key.contains('updated_persona')))) {
          if (atNotification.key.contains('shared_a_persona') ||
              atNotification.key.contains('updated_persona')) {
            // await _contactDetailsProvider
            //     .getKeysSharedByAtsign(atNotification.from);
            // await _shortDetailsProvider.loadBasicInfo(atNotification.from);
          }
          // await _notificationService.showNotification(atNotification);
          // await _notificationProvider.getNofifications();
        } else {
          // if (atNotification.to == globals.atSign) {
          //   await _contactDetailsProvider
          //       .getKeysSharedByAtsign(atNotification.from);
          //   await _shortDetailsProvider.loadBasicInfo(atNotification.from);
          // }
        }
      }
    } catch (e) {
      _logger.severe('Error in accepting stream : ', e);
    }
  }

  // startMonitor needs to be called at the beginning of session
  Future<void> startMonitor() async {
    _logger.finer('Starting app notification monitor');
    atClientManager.notificationService
        .subscribe(regex: BuzzEnv.syncRegex)
        .listen((AtNotification monitorNotification) async {
      try {
        _logger.finer('Listening to notification: ${monitorNotification.id}');
        if (!(await atClientManager.syncService.isInSync())) {
          syncData();
        }
        await _listenToNotifications(monitorNotification);
      } catch (e) {
        _logger.severe(e.toString());
      }
    });
  }

  Future<void> _listenToNotifications(
      AtNotification monitorNotification) async {
    _logger.finer('Listening to notification: ${monitorNotification.id}');
    await _showNotification(monitorNotification);
  }

  Future<void> _showNotification(AtNotification atNotification) async {
    _logger.finer('inside show notification...');
    NotificationDetails platformChannelSpecifics = const NotificationDetails(
      android: AndroidNotificationDetails('CHANNEL_ID', 'CHANNEL_NAME',
          channelDescription: 'CHANNEL_DESCRIPTION',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false),
      iOS: IOSNotificationDetails(),
    );

    if (atNotification.key.contains('report')) {
      await _notificationsPlugin.show(
          0,
          'Report',
          atNotification.from + ' submitted feedback.',
          platformChannelSpecifics,
          payload: jsonEncode(atNotification.toJson()));
    }
  }

  Future<void> waitForSync([Function()? onWait]) async {
    while (!(await atClientManager.syncService.isInSync())) {
      await Future<void>.delayed(
        const Duration(milliseconds: 500),
        onWait,
      );
    }
  }

  /// Function that calls sync.
  void syncData([Function? onSyncDone]) {
    Future<void> _onSyncData(SyncResult synRes) async {
      await _onSuccessCallback(synRes);
      await getProPic();
      await ServiceInstances.appServices.getAllContacts();
      if (onSyncDone != null) {
        onSyncDone();
      }
    }

    _userData.setSyncStatus = SyncStatus.started;
    atClientManager.syncService.setOnDone(_onSyncData);
    atClientManager.syncService.sync();
  }

  /// Function to be called when sync is done
  Future<void> _onSuccessCallback(SyncResult syncResult) async {
    _logger.finer(
        '======================= ${syncResult.syncStatus.name} =======================');
    _userData.setSyncStatus = syncResult.syncStatus;
    await HapticFeedback.lightImpact();
  }

  // --------------------- //
  //    CRUD operations    //
  // --------------------- //

  Future<bool> put(BuzzKey entity) async {
    try {
      //set value
      dynamic value = entity.isBinary == false
          ? jsonEncode(entity.value?.toJson())
          : entity.value?.value;
      bool putResult =
          await atClientManager.atClient.put(entity.toAtKey(), value);
      _logger.finer('Put result: $putResult');
      if (putResult) {
        NotificationResult notificationResult =
            await atClientManager.notificationService.notify(
                NotificationParams.forUpdate(
                  entity.toAtKey(),
                  value: entity.key!.toLowerCase() == 'profilepic'
                      ? value
                      : value['title'],
                ), onSuccess: () {
          _logger.finer('Key ${entity.key} update notified.');
        }, onError: () {
          _logger.warning('Failed to notify Key update.');
        }).onError((Object? error, StackTrace stackTrace) {
          _logger.severe(
              'Error while notifying Key update: $error', error, stackTrace);
          return NotificationResult()
            ..notificationStatusEnum = NotificationStatusEnum.undelivered;
        });
        notificationResult.notificationStatusEnum ==
                NotificationStatusEnum.delivered
            ? _logger.finer('Notification delivered for Key ${entity.key}')
            : _logger.severe('Notification failed for Key ${entity.key}');
      }
      syncData();
      return putResult;
    } catch (e, s) {
      _logger.severe('Error while putting data: $e', e, s);
      return false;
    }
  }

  /// Get the value of the key.
  Future<BuzzValue?> get(BuzzKey buzzKey) async {
    try {
      AtValue _value = await atClientManager.atClient.get(buzzKey.toAtKey());
      return BuzzValue.fromAtValue(_value);
    } on KeyNotFoundException catch (e, s) {
      _logger.severe('Key not found with message ${e.message}', e, s);
      return null;
    } on FormatException catch (e, s) {
      _logger.severe('FormatError: $e', e, s);
      return null;
    } on Exception catch (e, s) {
      _logger.severe('Error while getting data, Error: $e', e, s);
      return null;
    }
  }

  Future<bool> delete(String key, [Function? onSyncDone]) async {
    bool _keyDeleted = false;
    late AtKey _key;
    try {
      List<BuzzKey> allKeys = await getAllKeys(regex: key);
      if (allKeys.length > 1) {
        _logger
            .severe('Looks like you have more that one key with the keyname');
        return false;
      }
      for (BuzzKey key in allKeys) {
        _key = key.toAtKey();
        _keyDeleted = await atClientManager.atClient.delete(_key);
      }
      if (_keyDeleted) {
        _logger.finer('$key deleted successfully');
        await atClientManager.notificationService
            .notify(NotificationParams.forDelete(_key), onSuccess: () {
          _logger.finer('Key deletion notified.');
        }, onError: () {
          _logger.warning('Failed to notify Key deletion.');
        }).then((NotificationResult value) => _logger.finer(
                'Notification status: ${value.notificationStatusEnum.name}'));
        syncData();
      }
      return _keyDeleted;
    } on KeyNotFoundException catch (e, s) {
      _logger.severe('${e.message} to delete it.', e, s);
      return false;
    } on Exception catch (e, s) {
      _logger.severe('Error while deleting data', e, s);
      return false;
    }
  }

  Future<void> noitfy(Notification notificationType, AtKey key,
      {String? value}) async {
    assert(value != null && notificationType == Notification.update,
        'Value cannot be null');
    await atClientManager.notificationService.notify(
        notificationType.index == 0
            ? NotificationParams.forUpdate(key, value: value)
            : NotificationParams.forDelete(key), onSuccess: () {
      _logger.finer('Key deletion notified.');
    }, onError: () {
      _logger.warning('Failed to notify Key deletion.');
    }).then((NotificationResult value) => _logger
        .finer('Notification status: ${value.notificationStatusEnum.name}'));
  }

  Future<List<BuzzKey>> getAllKeys({
    String? regex,
    String? sharedBy,
    String? sharedWith,
  }) async {
    try {
      List<AtKey> result = await atClientManager.atClient
          .getAtKeys(regex: regex, sharedBy: sharedBy, sharedWith: sharedWith);
      return result.map(BuzzKey.fromAtKey).toList();
    } on Exception catch (e, s) {
      _logger.severe('Error while fetching keys', e, s);
      return <BuzzKey>[];
    }
  }

  Future<BuzzKey?> getConnectionImage(String sharedBy) async {
    String cachedRegex = '^cached:$currentAtSign:.*$sharedBy\$';
    List<BuzzKey> allKeys = await getAllKeys(regex: cachedRegex);
    BuzzKey? proPic;
    for (BuzzKey key in allKeys) {
      if (key.key!.contains('profilepic')) {
        proPic = key.copyWith(value: await get(key));
      }
    }
    return proPic;
  }

  Future<String?> getEmail(String sharedBy) async {
    String? email;
    String cachedRegex = '^cached:$currentAtSign:.*$sharedBy\$';
    List<BuzzKey> allKeys = await getAllKeys(regex: cachedRegex);
    for (BuzzKey key in allKeys) {
      if (key.key!.contains('email**contact')) {
        BuzzValue? _emailVal = await get(key);
        email = jsonDecode(_emailVal?.value)['value'];
      }
    }
    return email;
  }

  Future<String?> getPhone(String sharedBy) async {
    String? _phone;
    String cachedRegex = '^cached:$currentAtSign:.*$sharedBy\$';
    List<BuzzKey> allKeys = await getAllKeys(regex: cachedRegex);
    for (BuzzKey key in allKeys) {
      if (key.key!.contains('phone**contact')) {
        BuzzValue? _phoneVal = await get(key);
        _phone = jsonDecode(_phoneVal?.value)['value'];
      }
    }
    return _phone;
  }

  Future<String?> getProPic() async {
    _logger.finer('Fetching profile pic');
    String? _img;
    try {
      List<AtKey> list = await atClientManager.atClient
          .getAtKeys(regex: 'profilepic', sharedBy: currentAtSign);
      for (AtKey key in list) {
        if (key.key == 'profilepic' && key.namespace == BuzzEnv.appNamespace) {
          AtValue img = await atClientManager.atClient.get(key);
          _logger.finer('Got profile pic value');
          _userData.currentProfilePic = Base2e15.decode(img.value);
          _img = json.decode(img.value)['value'];
          break;
        }
      }
      if (_img == null) _logger.warning('Cannot get profile pic value');
      return _img;
    } on Exception catch (e, s) {
      _logger.severe('Error getting profile pic', e, s);
      return null;
    }
  }
}
