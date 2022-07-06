import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/constants/constants.dart';
part 'date.model.freezed.dart';
part 'date.model.g.dart';

@Freezed()
class Date with _$Date, BasePersona {
  // @Assert('value.isNotEmpty', 'Date cannot be empty')
  const factory Date({
    @Default('📅') String? icon,
    @Default('Date') String name,
    required String description,
    @Default('EG: 10/11/1999') String? hint,
    required String value,
    @Default(true) bool isPublic,
  }) = _Date;

  /// This is a default Date data model.
  /// ```
  /// dataType: DateTime,
  /// name: 'My Date of Birth',
  /// description: 'My Date of Birth',
  /// hint: '10/11/1999',
  /// isPublic: true,
  /// value: DateTime.now(), // Value is empty by default, Please make sure of the value.
  /// ```
  static BasePersona defaultDateField = Date(
    name: 'Date',
    description: 'Description',
    hint: '10/11/1999',
    isPublic: true,
    value: DateTime.now().millisecondsSinceEpoch.toString(),
  );

  factory Date.fromJson(Map<String, dynamic> json) => _$DateFromJson(json);
}
