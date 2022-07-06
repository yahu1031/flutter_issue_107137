import 'dart:convert';
import 'dart:developer';

import '../../app/constants/constants.dart';
import '../../app/provider/notifiers/user_data.dart';
import '../../meta/extensions/string.ext.dart';
import '../../meta/models/buzz_key.model.dart';
import '../../meta/models/buzz_value.model.dart';
import '../../meta/models/connection.model.dart';
import '../../meta/models/persona.model.dart';
import '../../meta/utils/buzz_env.dart';
import '../services/instances.dart';

class PersonaService {
  static final PersonaService _singleton = PersonaService._internal();

  PersonaService._internal();
  factory PersonaService.getInstance() {
    return _singleton;
  }

  late final UserData _userData;

  /// Initialize the userData
  void init(UserData userData) {
    _userData = userData;
  }

  Future<void> getAllPersonas() async {
    List<BuzzKey> buzzKeys = await ServiceInstances.sdkServices
        .getAllKeys(regex: BuzzEnv.appNamespace);
    List<Persona> personas = <Persona>[];
    for (BuzzKey buzzKey in buzzKeys) {
      if (buzzKey.key!.contains(Constants.personaPrefix) &&
          buzzKey.sharedBy != null &&
          buzzKey.sharedWith != null &&
          buzzKey.sharedBy!.formatAtSign() ==
              buzzKey.sharedWith!.formatAtSign()) {
        Persona? _persona = await getPersona(buzzKey);
        personas.add(_persona!);
        log(_persona.atSignsList.toString());
      }
    }
    _userData.personas = personas;
  }

  Future<Persona?> getPersona(BuzzKey buzzKey) async {
    BuzzValue? value = await ServiceInstances.sdkServices.get(buzzKey);
    Map<String, dynamic> _persona = jsonDecode(value?.value)['value'];
    _persona.addAll(<String, Map<String, String?>>{
      'sharedWith': await getPersonaSharedWithAtSigns(_persona['name'])
    });
    return value != null ? Persona.fromJson(_persona) : null;
  }

  /// Get the list of sharedWith atSigns for the persona
  Future<Map<String, String?>> getPersonaSharedWithAtSigns(
      String personaName) async {
    Map<String, String?> _atSignWithImg = <String, String?>{};
    List<Connection> _connectionsList = _userData.connections
        .where((Connection element) => element.personas!.contains(personaName))
        .toList();
    for (Connection element in _connectionsList) {
      BuzzKey? imgKey = await ServiceInstances.sdkServices
          .getConnectionImage(element.atSign!);
      _atSignWithImg[element.atSign!] =
          imgKey != null ? jsonDecode(imgKey.value?.value)['value'] : null;
    }
    return _atSignWithImg;
  }
}
