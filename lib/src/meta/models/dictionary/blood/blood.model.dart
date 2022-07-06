import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/constants/constants.dart';
part 'blood.model.freezed.dart';
part 'blood.model.g.dart';

@Freezed()
class BloodGroup with _$BloodGroup, BasePersona {
  // @Assert('value.isNotEmpty', 'Your blood group cannot be empty')
  const factory BloodGroup({
    @Default('🩸') String? icon,
    @Default('Blood Group') String name,
    @Default('My Blood Group') String description,
    @Default('Blood Group') String? hint,
    required String value,
    @Default(true) bool isPublic,
  }) = _BloodGroup;

  /// This is a default Blood Group data model.
  /// ```

  /// name: 'Blood Group',
  /// description: 'Your blood group',
  /// hint: 'Blood Group',
  /// isPublic: true,
  /// value: '', // Value is empty by default, Please make sure of the value.
  /// ```
  static BasePersona defaultBloodGroupField = const BloodGroup(
    name: 'Blood Group',
    description: 'Description',
    hint: 'Blood Group',
    isPublic: true,
    value: '',
  );

  factory BloodGroup.fromJson(Map<String, dynamic> json) =>
      _$BloodGroupFromJson(json);
}
