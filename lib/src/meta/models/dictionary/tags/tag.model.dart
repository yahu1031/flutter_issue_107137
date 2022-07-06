import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/constants/constants.dart';
part 'tag.model.freezed.dart';
part 'tag.model.g.dart';

@Freezed()
class Tags with _$Tags, BasePersona {
  const factory Tags({
    @Default('🏷️') String? icon,
    @Default('Tags') String name,
    @Default('My Tags') String description,
    @Default('Tags') String? hint,
    @Default(true) bool isPublic,
    required String value,
  }) = _Tags;

  /// This is a default Tags data model.
  /// ```
  /// name: 'Tags',
  /// description: 'My Tags',
  /// hint: 'Tags',
  /// isPublic: true,
  /// value: <String>{'Salad', 'Fruit', 'Vegetable'}, // Value is empty by default, Please make sure of the value.
  /// ```

  static BasePersona defaultTagsField = Tags(
    name: 'Tags',
    description: 'Description',
    hint: 'Tags',
    isPublic: true,
    value: <String>[].toString(),
  );

  factory Tags.fromJson(Map<String, dynamic> json) => _$TagsFromJson(json);
}
