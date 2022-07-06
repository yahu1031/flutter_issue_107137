import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/constants/constants.dart';
part 'links.model.freezed.dart';
part 'links.model.g.dart';

@Freezed()
class Url with _$Url, BasePersona {
  // @Assert('value.isNotEmpty', 'Your URL cannot be empty')
  const factory Url({
    @Default('🌐') String? icon,
    @Default('Website') String name,
    @Default('My Website') String description,
    @Default('https://www.google.com') String? hint,
    required String value,
    @Default(true) bool isPublic,
  }) = _Url;

  /// This is a default Url data model.
  /// ```

  /// name: 'Website',
  /// description: 'My Website',
  /// hint: 'https://www.google.com',
  /// isPublic: true,
  /// value: '', // Value is empty by default, Please make sure of the value.
  /// ```
  static BasePersona defaultUrlField = const Url(
    name: 'Urls/Website links',
    description: 'Description',
    hint: 'https://www.google.com',
    isPublic: true,
    value: '',
  );

  factory Url.fromJson(Map<String, dynamic> json) => _$UrlFromJson(json);
}
