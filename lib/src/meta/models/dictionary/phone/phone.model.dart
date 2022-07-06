import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/constants/constants.dart';
import '../../../../app/constants/enums.dart';

part 'phone.model.freezed.dart';
part 'phone.model.g.dart';

@Freezed()
class Phone with _$Phone, BasePersona {
  // @Assert('value.isNotEmpty', 'Phone number cannot be empty')
  const factory Phone({
    @Default('📱') String? icon,
    @Default('Phone') String name,
    @Default(PhoneType.personal) PhoneType type,
    @Default('+1 1234-567-890') String? hint,
    required String value,
    required String description,
    @Default(true) bool isPublic,
  }) = _Phone;

  /// This is a default email data model.
  /// ```

  /// name: 'Personal Phone number',
  /// type: PhoneType.personal,
  /// description: 'You can contact me at this number time.',
  /// hint: 'eg: +90-123-456-7890',
  /// isPublic: true,
  /// value: '', // Value is empty by default, Please make sure of the value.
  /// ```
  static BasePersona defaultPhoneField = const Phone(
    name: 'Phone number',
    type: PhoneType.personal,
    description: 'Description',
    hint: 'eg: +90-123-456-7890',
    isPublic: true,
    value: '',
  );

  factory Phone.fromJson(Map<String, dynamic> json) => _$PhoneFromJson(json);
}
