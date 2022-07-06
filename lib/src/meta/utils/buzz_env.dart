// 📦 Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 🌎 Project imports:
import '../extensions/logger.ext.dart';

/// Buzz configurations class.
class BuzzEnv {
  static final AppLogger _logger = AppLogger('BuzzEnv');

  /// Load the environment variables from the .env file.
  /// Directly calls load from the dotenv package.
  static Future<void> loadEnv() async {
    _logger.finer('Loading environment variables...');
    return dotenv.load();
  }

  /// The root domain from the config file.
  static final String rootDomain =
      dotenv.env['ROOT_DOMAIN'] ?? 'root.atsign.org';

  /// The API key from the config file.
  static final String apiKey =
      dotenv.env['API_KEY'] ?? '477b-876u-bcez-c42z-6a3d';

  /// The port from the config file.
  static final int port = int.parse(dotenv.env['ROOT_PORT'] ?? 64.toString());

  /// The app namespace from the config file.
  static final String appNamespace = dotenv.env['NAMESPACE'] ?? 'buzz';

  /// The app sync regex from the config file.
  static final String syncRegex = dotenv.env['SYNC_REGEX'] ?? '.buzz';

  /// The MAPS API key for maps from the config file.
  static final String? mapApiKey = dotenv.env['MAP_KEY'];

  /// The HERE API Key from the config file.
  static final String? hereApiKey = dotenv.env['HERE_API'];
}
