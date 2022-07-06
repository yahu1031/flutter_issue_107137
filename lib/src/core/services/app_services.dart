// 🎯 Dart imports:
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// � Package imports:
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_contact/at_contact.dart';
// import 'package:at_location_flutter/utils/constants/init_location_service.dart';
import 'package:at_utils/at_utils.dart';
import 'package:file_picker/file_picker.dart';
// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zxing2/qrcode.dart';

// 🌎 Project imports:
import '../../app/constants/constants.dart';
import '../../app/constants/enums.dart';
import '../../app/provider/notifiers/user_data.dart';
import '../../meta/components/globals.dart';
import '../../meta/extensions/string.ext.dart';
import '../../meta/models/buzz_key.model.dart';
import '../../meta/models/connection.model.dart';
import '../../meta/models/qr.dart';
import 'instances.dart';

class AppService {
  final AtSignLogger _logger = AtSignLogger('AppService');

  // singleton with getInstance()
  static final AppService _singleton = AppService._internal();

  AppService._internal();
  factory AppService.getInstance() {
    return _singleton;
  }

  Future<void> mapsInit() async {
    // await initializeLocationService(
    //   navKey,
    //   mapKey: BuzzEnv.mapApiKey!,
    //   apiKey: BuzzEnv.hereApiKey!,
    //   showDialogBox: true,
    //   streamAlternative: (__) {
    //     return Stream<void>.periodic(const Duration(seconds: 1), (__) {
    //       _logger.finer('streamAlternative $__');
    //     });
    //   },
    //   isEventInUse: true,
    // );
  }

  Future<List<Connection>> getAllContacts() async {
    AtContactsImpl _atContact = await AtContactsImpl.getInstance(
        ServiceInstances.sdkServices.currentAtSign!);
    late List<Connection> _connections;
    List<Connection> connections = <Connection>[];
    List<AtContact> _allContacts = await _atContact.listContacts();
    _connections = _allContacts.map((AtContact atContact) {
      return Connection.fromAtContact(atContact);
    }).toList();
    for (Connection connection in _connections) {
      BuzzKey? imageKey = await ServiceInstances.sdkServices
          .getConnectionImage(connection.atSign!);
      String? email =
          await ServiceInstances.sdkServices.getEmail(connection.atSign!);
      String? phone =
          await ServiceInstances.sdkServices.getPhone(connection.atSign!);
      connection = connection.copyWith(
          profilePicture: imageKey, email: email, phoneNumber: phone);
      connections.add(connection);
    }
    return connections;
  }

  /// This function will clear the keychain if the app installed newly again.
  Future<void> checkFirstRun() async {
    _logger.finer('Checking for keychain entries to clear');
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.getBool('first_run') ?? true) {
      _logger.finer('First run detected. Clearing keychain');
      await KeyChainManager.getInstance().clearKeychainEntries();
      await _prefs.setBool('first_run', false);
    }
  }

  /// Validates Email
  bool validateEmail(String email) {
    if (email.isEmpty) return false;
    return RegExp(
      r'^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$',
    ).hasMatch(email);
  }

  /// This function will get you a new @sign from the server
  Future<String?> getNewAtSign() async {
    late http.Response response;
    String? atSign;
    try {
      response = await _apiRequest(Constants.getFreeAtSign);
    } on Exception catch (e) {
      _logger.severe('Error while fetching new @sign: $e');
      return null;
    }
    if (response.statusCode == 200) {
      atSign = '@' + json.decode(response.body)['data']['atsign'];
    } else {
      _logger.info(json.decode(response.body)['message']);
      atSign = null;
    }
    return atSign;
  }

  /// Use email to register a new @sign
  Future<bool> registerWithMail(String email, String atSign) async {
    late http.Response response;
    try {
      response = await _apiRequest(Constants.registerUser,
          <String, String?>{'email': email, 'atsign': atSign}, ApiRequest.post);
    } on Exception catch (e) {
      _logger.severe('Error while fetching new @sign: $e');
    }
    _logger.finer(
        'Register with mail response status code: ${response.statusCode}');
    return response.statusCode == 200;
  }

  /// Validate otp to register your @sign
  Future<String?> getCRAM(Map<String, dynamic> requestBody) async {
    late http.Response response;
    try {
      response = await _apiRequest(
          Constants.validateOTP, requestBody, ApiRequest.post);
    } on Exception catch (e) {
      _logger.severe('Error while fetching new @sign: $e');
    }
    if (response.statusCode == 200 &&
        json.decode(response.body)['message'].toString().toLowerCase() ==
            'verified') {
      _logger.finer('Got CRAM response status code: ${response.statusCode}');
      return json.decode(response.body)['cramkey'];
    } else {
      _logger.warning('Got CRAM response status code: ${response.statusCode}');
      return null;
    }
  }

  /// General api requests
  Future<http.Response> _apiRequest(String endPoint,
          [Map<String, dynamic>? requestBody,
          ApiRequest request = ApiRequest.get]) async =>
      request.name == 'get'
          ? http.get(
              Uri.https(Constants.domain, Constants.apiPath + endPoint),
              headers: Constants.apiHeaders,
            )
          : http.post(
              Uri.https(Constants.domain, Constants.apiPath + endPoint),
              body: json.encode(requestBody),
              headers: Constants.apiHeaders,
            );

  Future<bool> getQRData(BuildContext context, String? filePath) async {
    if (filePath != null) {
      File imgFile = File(filePath);
      if ((await imgFile.length()) < 10) {
        await showToast(context, 'Incorrect QR code file', isError: true);
        return false;
      }
      img.Image? _image = img.decodeImage(await imgFile.readAsBytes());

      if (_image == null) {
        await showToast(context, 'Error while decoding image', isError: true);
        _logger.severe('Error while decoding image');
        return false;
      }
      late Result _result;
      try {
        LuminanceSource _source = RGBLuminanceSource(
            _image.width,
            _image.height,
            _image.getBytes(format: img.Format.abgr).buffer.asInt32List());
        BinaryBitmap _bitMap = BinaryBitmap(HybridBinarizer(_source));
        QRCodeReader _qrReader = QRCodeReader();
        _result = _qrReader.decode(_bitMap);
      } on Exception catch (e) {
        await showToast(context, 'Error while decoding QR code', isError: true);
        _logger.severe('Error while decoding QR code: $e');
        return false;
      }

      String _qrData = _result.text.replaceAll('"', '');
      context.read<UserData>().setQrData = QrModel(
        atSign: _qrData.split(':')[0],
        cramSecret: _qrData.split(':')[1],
      );
      await showToast(context, 'QR code decoded successfully');
      _logger.finer('QR code decoded successfully');
      return true;
    } else {
      await showToast(context, 'No image selected', isError: true);
      _logger.finer('No image selected');
      return false;
    }
  }

  /// Uploads the file to the device.
  /// This function will return the list of files.
  Future<Set<PlatformFile>> uploadFile(
          [FileType? fileType,
          bool? allowMultipleFiles,
          List<String>? extensions]) async =>
      (await FilePicker.platform.pickFiles(
              type: fileType ?? FileType.any,
              allowMultiple: allowMultipleFiles ?? false,
              allowedExtensions: extensions))
          ?.files
          .toSet() ??
      <PlatformFile>{};

  /// This function will read local files as string.
  Future<String> readLocalfilesAsString(String filePath) async =>
      rootBundle.loadString(filePath);

  /// This function will read local files as bytes.
  Future<Uint8List> readLocalfilesAsBytes(String filePath) async =>
      (await rootBundle.load(filePath)).buffer.asUint8List();

  /// This function will read local files as bytes.
  Future<Uint8List> readFilesAsBytes(String filePath) async =>
      File(filePath).readAsBytes();

  /// Read .atKeys file and return the content as a Map<Strings, String>
  Future<String> readAtKeysFile(String filePath) async =>
      File(filePath).readAsString();

  Future<Map<String, String>> getKeysFileData(String atSign) async {
    Map<String, String> keysFileData =
        await KeychainUtil.getEncryptedKeys(atSign);
    keysFileData[atSign] = await KeychainUtil.getAESKey(atSign) ?? '';
    return keysFileData;
  }

  /// Function to save keys
  Future<bool> saveAtKeys(String atSign, String keysPath, Size size) async {
    try {
      String _fileName = p.join(keysPath, atSign + '_key.atKeys');
      if (!await File(_fileName).exists()) {
        await File(_fileName).create();
      }
      String _keys = jsonEncode(await getKeysFileData(atSign));
      IOSink _sink = File(_fileName).openWrite();
      _sink.write(_keys);
      await _sink.flush();
      await _sink.close();
      _keys.clear();
      ShareResult shareResult = await Share.shareFilesWithResult(<String>[
        _fileName
      ], sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2));
      return shareResult.status == ShareResultStatus.success;
    } on Exception catch (e) {
      _logger.severe('Error while saving keys: $e');
      return false;
    }
  }

  /// Check for the list of permissions.
  Future<bool> checkPermission(List<Permission> permissions) async {
    int _permissionsCount = permissions.length;
    while (_permissionsCount == 0) {
      for (Permission permission in permissions) {
        if (await permission.status != PermissionStatus.granted) {
          await permission.request();
          _permissionsCount--;
        } else {
          _permissionsCount--;
        }
      }
    }
    return _permissionsCount == 0;
  }

  Future<String> getSuportDirPath() async {
    String _path = (await getApplicationSupportDirectory()).path;
    List<String> _pathList = _path.split(Platform.pathSeparator);
    _pathList.removeWhere((String element) => element.contains('app_flutter'));
    return p.joinAll(_pathList);
  }
}
