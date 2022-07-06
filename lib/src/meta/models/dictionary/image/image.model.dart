import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/constants/constants.dart';
part 'image.model.freezed.dart';
part 'image.model.g.dart';

@Freezed()
class UserImage with _$UserImage, BasePersona {
  // @Assert('value.isNotEmpty', 'Your image cannot be empty')
  const factory UserImage({
    @Default('🖼️') String? icon,
    @Default('Image') String name,
    @Default('My Image') String description,
    @Default('Image') String? hint,
    @Default(true) bool isImage,
    required String value,
    @Default(true) bool isPublic,
  }) = _UserImage;

  /// This is a default Image data model.
  /// ```

  /// name: 'Image',
  /// description: 'My Image',
  /// hint: 'Image',
  /// isPublic: true,
  /// isImage: true,
  /// value: '', // Value is empty by default, Please make sure of the value.
  /// ```
  static BasePersona defaultImageField = const UserImage(
    name: 'Image',
    description: 'Description',
    hint: 'Image',
    isPublic: true,
    isImage: true,
    value: '',
  );

  factory UserImage.fromJson(Map<String, dynamic> json) =>
      _$UserImageFromJson(json);
}
