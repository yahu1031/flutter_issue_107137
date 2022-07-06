// 📦 Package imports:
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_onboarding_flutter/services/onboarding_service.dart';

// 🌎 Project imports:
import '../sdk_services/persona_services.dart';
import 'app_services.dart';
import '../sdk_services/sdk_services.dart';

class ServiceInstances {
  /// The [KeyChainManager] instance.
  static final KeyChainManager keyChainManager = KeyChainManager.getInstance();

  /// The [AtClientManager] instance.
  static AtClientManager atClientManager = AtClientManager.getInstance();

  /// The [AtClient] instance.
  static AtClient atClient = atClientManager.atClient;

  /// Setter for [AtClientManager] instance.
  static set setAtClientManagerInstance(AtClientManager instance) =>
      atClientManager = instance;

  /// The [SdkServices] instance.
  static final SdkServices sdkServices = SdkServices.getInstance();

  /// The [AppService] instance.
  static final AppService appServices = AppService.getInstance();
  
  /// The [PersonaService] instance.
  static final PersonaService personaServices = PersonaService.getInstance();

  /// The [OnboardingService] instance.
  static final OnboardingService onboardingService =
    OnboardingService.getInstance();
}
