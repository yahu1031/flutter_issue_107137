import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/constants/constants.dart';
import '../../../../app/constants/enums.dart';
part 'email.model.freezed.dart';
part 'email.model.g.dart';

@Freezed()
class Email with _$Email, BasePersona {
  // @Assert('value.isNotEmpty', 'Email cannot be empty')
  const factory Email({
    @Default('📧') String? icon,
    @Default('Email') String name,
    @Default(EmailType.personal) EmailType type,
    @Default('@gmail.com') String emailTypeMap,
    required String description,
    @Default('eg: myEmail@gmail.com') String? hint,
    required String value,
    @Default(true) bool isPublic,
  }) = _Email;

  /// This is a default email data model.
  /// ```
  /// name: 'Personal Email',
  /// type: EmailType.personal,
  /// emailTypeMap: '@gmail.com',
  /// description: 'You can contact me at this mail any time.',
  /// hint: 'eg: myEmail@gmail.com',
  /// isPublic: true,
  /// value: '', // Value is empty by default, Please make sure of the value.
  /// ```
  static BasePersona defaultEmailField = const Email(
    name: 'Email',
    type: EmailType.personal,
    emailTypeMap: '@gmail.com',
    description: 'Description',
    hint: 'eg: myEmail@gmail.com',
    isPublic: true,
    value: '',
  );

  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);
}
