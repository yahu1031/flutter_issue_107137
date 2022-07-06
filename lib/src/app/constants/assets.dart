// 🎯 Dart imports:
import 'dart:math';

/// Assets class
class Assets {
  /// Base path of assets folder
  static const String _basePath = 'assets';

  /// Base path of config folder
  static const String _configPath = '$_basePath/config';

  /// App configuration file
  static const String envConfig = '$_configPath/env_config.yaml';

  /// Base path of images folder
  static const String _imgBasePath = '$_basePath/images';

  /// Base path of lottie folder
  static const String _lottieBasePath = '$_basePath/lottie';

  /// Base path of avatars folder
  static const String _avatarBasePath = '$_imgBasePath/avatars';

  /// Base path of flags folder
  static const String flagsBasePath = '$_imgBasePath/flags';

  /// Path for logo image
  static const String logo = '$_imgBasePath/@buzz_logo.png';

  /// Path for @ logo image
  static const String atLogo = '$_imgBasePath/@.png';

  /// Path for atKeys image
  static const String atKeys = '$_imgBasePath/atKeys.png';

  /// Paths of avatars
  static const List<String> avatars = <String>[
    '$_avatarBasePath/alien.png',
    '$_avatarBasePath/bear.png',
    '$_avatarBasePath/cat.png',
    '$_avatarBasePath/cow.png',
    '$_avatarBasePath/dog.png',
    '$_avatarBasePath/fox.png',
    '$_avatarBasePath/frog.png',
    '$_avatarBasePath/ghost.png',
    '$_avatarBasePath/kola.png',
    '$_avatarBasePath/lion.png',
    '$_avatarBasePath/monkey.png',
    '$_avatarBasePath/octopus.png',
    '$_avatarBasePath/owl.png',
    '$_avatarBasePath/panda.png',
    '$_avatarBasePath/pig.png',
    '$_avatarBasePath/rabbit.png',
    '$_avatarBasePath/rat.png',
    '$_avatarBasePath/shark.png',
    '$_avatarBasePath/tiger.png',
  ];

  /// Otp lottie file
  static const String otpLottie = '$_lottieBasePath/otp.json';

  /// Get random avatar
  static String get randomAvatar => avatars[Random().nextInt(avatars.length)];

  /// Dashboard QR for website
  static const String dashboardQR = '$_imgBasePath/dashboard_qr.png';
}
