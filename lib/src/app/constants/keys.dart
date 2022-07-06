import '../../meta/models/buzz_key.model.dart';
import '../../meta/models/buzz_value.model.dart';

class Keys {
  static BuzzKey profilePicKey = BuzzKey(
    key: 'ProfilePic',
    isPublic: false,
    isBinary: false,
    namespaceAware: true,
    ccd: true,
    ttr: (24 * 60 * 60 * 1000),
    value: BuzzValue(
      type: 'ProfilePic',
      createdDate: DateTime.now(),
      labelName: 'Profile Pic',
    ),
  );
}
