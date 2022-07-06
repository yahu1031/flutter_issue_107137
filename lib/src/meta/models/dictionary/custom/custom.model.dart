import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/constants/constants.dart';

part 'custom.model.freezed.dart';
part 'custom.model.g.dart';

@Freezed()
class CustomData with _$CustomData, BasePersona {
  // @Assert('value.isNotEmpty', 'CustomData cannot be empty')
  const factory CustomData({
    @Default('➕') String? icon,
    @Default('CustomData') String name,
    required String description,
    @Default('EG: 10/11/1999') String? hint,
    required String value,
    @Default(true) bool isPublic,
  }) = _CustomData;

  /// This is a default CustomData data model.
  /// ```
  /// dataType: CustomData,
  /// name: 'Custom Data',
  /// description: 'My custom data description',
  /// hint: 'My own data',
  /// isPublic: true,
  /// value: 'My custom value here', // Value is empty by default, Please make sure of the value.
  /// ```
  static BasePersona defaultCustomDataField = const CustomData(
    name: 'Custom Data',
    description: 'Description',
    hint: 'My own data',
    isPublic: true,
    value: '',
  );

  factory CustomData.fromJson(Map<String, dynamic> json) =>
      _$CustomDataFromJson(json);
}
