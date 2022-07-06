import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/constants/constants.dart';

part 'password.model.freezed.dart';
part 'password.model.g.dart';

@Freezed()
class Password with _$Password, BasePersona {
  // @Assert('value.isNotEmpty', 'Password cannot be empty')
  const factory Password({
    @Default('🔑') String? icon,
    @Default('Password') String name,
    required String description,
    @Default('Pass****') String? hint,
    required String value,
    @Default(false) bool isPublic,
  }) = _Password;

  /// This is a default Password data model.
  /// ```
  /// name: 'Gmail password',
  /// description: 'My gmail password',
  /// hint: 'somepasssword',
  /// isPublic: true,
  /// value: '', // Value is empty by default, Please make sure of the value.
  /// ```
  static BasePersona defaultPasswordField = const Password(
    name: 'password',
    description: 'Description',
    hint: 'pass****',
    isPublic: false,
    value: '',
  );

  factory Password.fromJson(Map<String, dynamic> json) =>
      _$PasswordFromJson(json);
}
