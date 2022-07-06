// 🎯 Dart imports:
import 'dart:typed_data';

// � Package imports:
import 'package:at_client_mobile/at_client_mobile.dart';
// � Flutter imports:
import 'package:flutter/cupertino.dart';

// 🌎 Project imports:
import '../../../meta/extensions/logger.ext.dart';
import '../../../meta/models/connection.model.dart';
import '../../../meta/models/persona.model.dart';
import '../../../meta/models/qr.dart';

class UserData extends ChangeNotifier {
  final AppLogger _logger = AppLogger('UserData');

  /// @sign from Qr Code
  late String _qrAtSign;

  /// CRAM secret from Qr Code
  late String _cramSecret;

  /// Sync status
  SyncStatus _syncStatus = SyncStatus.notStarted;

  /// Getter for the [QrModel].
  QrModel get getQrData => QrModel(atSign: _qrAtSign, cramSecret: _cramSecret);

  /// Setter for the [QrModel].
  set setQrData(QrModel value) {
    _qrAtSign = value.atSign;
    _cramSecret = value.cramSecret;
    notifyListeners();
  }

  /// Current @sign
  String? _currentAtSign;

  /// Get current @sign
  String get currentAtSign => _currentAtSign ?? '';

  /// Set current @sign
  set currentAtSign(String value) {
    _logger.finer('Setting current @sign to $value');
    _currentAtSign = value;
    notifyListeners();
  }

  /// Current ProfilePic
  Uint8List _currentProfilePic = Uint8List(0);

  /// Get current ProfilePic
  Uint8List get currentProfilePic => _currentProfilePic;

  /// Set current ProfilePic
  set currentProfilePic(Uint8List value) {
    _logger.finer('Setting current profile pic');
    _currentProfilePic = value;
    notifyListeners();
  }

  /// User authentication status
  bool _authenticated = false;

  /// Getter for the [_authenticated].
  bool get authenticated => _authenticated;

  /// Setter for the [_authenticated].
  set authenticated(bool _auth) {
    _logger.finer('Setting user auth status to $_auth');
    _authenticated = _auth;
    notifyListeners();
  }

  /// Application storage path
  late String userPath;

  /// Setter for the application storage path
  set setUserPath(String value) {
    userPath = value;
    notifyListeners();
  }

  /// Getter for the application storage path
  String get getUserPath => userPath;

  /// Get the sync status.
  SyncStatus get syncStatus => _syncStatus;

  /// Setter for the sync status.
  set setSyncStatus(SyncStatus isSyncing) {
    _syncStatus = isSyncing;
    notifyListeners();
  }

  /// Onboarding preferences
  AtClientPreference? _atOnboardingPreference;

  /// Get onboarding preferences
  AtClientPreference get atOnboardingPreference => _atOnboardingPreference!;

  /// Set onboarding preferences
  set setAtOnboardingPreference(AtClientPreference value) {
    _logger.finer('Setting onboarding preferences...');
    _atOnboardingPreference = value;
    notifyListeners();
  }

  /// List of connections
  List<Connection>? _connections;

  /// Getter for the [_connections].
  List<Connection> get connections => _connections ?? <Connection>[];

  /// Setter for the [_connections].
  set connections(List<Connection> value) {
    _logger.finer('Setting connections...');
    _connections = value;
    notifyListeners();
  }

  /// List of personas
  List<Persona>? _personas;

  /// Getter for the [_personas].
  List<Persona> get personas => _personas ?? <Persona>[];

  /// Setter for the [_personas].
  set personas(List<Persona> value) {
    _logger.finer('Setting personas...');
    _personas = value;
    notifyListeners();
  }

  void disposeUser() {
    _syncStatus = SyncStatus.notStarted;
    _currentProfilePic = Uint8List(0);
    _currentAtSign = null;
    notifyListeners();
  }
}
