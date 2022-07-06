import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/constants/constants.dart';
part 'fax.model.freezed.dart';
part 'fax.model.g.dart';
@Freezed()
class Fax with _$Fax, BasePersona {
  // @Assert('value.isNotEmpty', 'Fax cannot be empty')
  const factory Fax({
    @Default('📠') String? icon,
    @Default('Fax') String name,
    required String description,
    @Default('+1 1234-567-890') String? hint,
    required String value,
    @Default(true) bool isPublic,
  }) = _Fax;

  /// This is a default Date data model.
  /// ```
  /// name: 'My Fax number',
  /// description: 'This is a default Fax data model',
  /// hint: '+1 984-563-5865',
  /// isPublic: true,
  /// value: '', // Value is empty by default, Please make sure of the value.
  /// ```
  static BasePersona defaultFaxField = const Fax(
    name: 'Fax number',
    description: 'Description',
    hint: '+1 1234-567-890',
    isPublic: true,
    value: '',
  );

  factory Fax.fromJson(Map<String, dynamic> json) => _$FaxFromJson(json);
}
