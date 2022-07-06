import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/constants/constants.dart';
part 'file.model.freezed.dart';
part 'file.model.g.dart';

@Freezed()
class UserFile with _$UserFile, BasePersona {
  // @Assert('value.isNotEmpty', 'Your image cannot be empty')
  const factory UserFile({
    @Default('📄') String? icon,
    @Default('File') String name,
    @Default('Some file') String description,
    @Default('Upload a file') String? hint,
    @Default(true) bool isImage,
    required String value,
    @Default(true) bool isPublic,
  }) = _UserFile;

  /// This is a default File data model.
  /// ```
  /// name: 'File',
  /// description: 'Some file',
  /// hint: 'Upload a file',
  /// isPublic: true,
  /// isImage: true,
  /// value: '', // Value is empty by default, Please make sure of the value.
  /// ```
  static BasePersona defaultUserFileField = const UserFile(
    name: 'File',
    description: 'Description',
    hint: 'Upload a file',
    isPublic: true,
    isImage: true,
    value: '',
  );

  factory UserFile.fromJson(Map<String, dynamic> json) =>
      _$UserFileFromJson(json);
}
