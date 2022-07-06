// 📦 Package imports:
import 'package:uuid/uuid.dart';

// 🌎 Project imports:
import '../../meta/models/dictionary/blood/blood.model.dart';
import '../../meta/models/dictionary/custom/custom.model.dart';
import '../../meta/models/dictionary/date/date.model.dart';
import '../../meta/models/dictionary/email/email.model.dart';
import '../../meta/models/dictionary/fax/fax.model.dart';
import '../../meta/models/dictionary/file/file.model.dart';
import '../../meta/models/dictionary/image/image.model.dart';
import '../../meta/models/dictionary/links/links.model.dart';
import '../../meta/models/dictionary/location/location.model.dart';
import '../../meta/models/dictionary/password/password.model.dart';
import '../../meta/models/dictionary/phone/phone.model.dart';
import '../../meta/utils/buzz_env.dart';

class Constants {
  /// Doamin for the API
  static String get domain => BuzzEnv.rootDomain.split('.')[2] == 'wtf'
      ? 'my.atsign.wtf'
      : 'my.atsign.com';

  /// API version path
  static const String apiPath = '/api/app/v2/';

  /// End point for getting a new atsign
  static const String getFreeAtSign = 'get-free-atsign';

  /// End point for registering a new atsign to an user
  static const String registerUser = 'register-person';

  /// End point for validating a new atsign to an user
  static const String validateOTP = 'validate-person';

  /// Domain for fetching favicons of websites
  static const String faviconDomain = 'api.faviconkit.com';

  /// @sign regex pattern
  static const String atSignPattern =
      '[a-zA-Z0-9_]|\u00a9|\u00af|[\u2155-\u2900]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]';

  static Map<String, String> apiHeaders = <String, String>{
    'Authorization': BuzzEnv.apiKey,
    'Content-Type': 'application/json',
  };

  /// Get a new UUID
  static String get uuid => const Uuid().v4();

  /// Persona name prefix
  static const String personaPrefix = 'persona.';

  static List<dynamic> allPersonas = <dynamic>[
    Fax.defaultFaxField,
    Date.defaultDateField,
    Password.defaultPasswordField,
    Email.defaultEmailField,
    Phone.defaultPhoneField,
    BloodGroup.defaultBloodGroupField,
    Url.defaultUrlField,
    UserFile.defaultUserFileField,
    UserImage.defaultImageField,
    Location.defaultLocationField,
    CustomData.defaultCustomDataField,
  ];
}

mixin BasePersona {
  String? get icon;
  String get name;
  String get description;
  String? get hint;
  String get value;
  bool get isPublic;
}
