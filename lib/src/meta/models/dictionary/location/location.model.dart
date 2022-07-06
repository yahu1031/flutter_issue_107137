import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../app/constants/constants.dart';
part 'location.model.freezed.dart';
part 'location.model.g.dart';

@Freezed()
class Location with _$Location, BasePersona {
  // @Assert('value.isNotEmpty', 'Your location cannot be empty')
  const factory Location({
    @Default('📍') String? icon,
    @Default('Location') String name,
    @Default('My Location') String description,
    @Default('Location') String? hint,
    required String value,
    @Default(true) bool isPublic,
  }) = _Location;

  /// This is a default Location data model.
  /// ```

  /// name: 'Location',
  /// description: 'My Location',
  /// hint: 'Location',
  /// isPublic: true,
  /// value: <String, String>{
  ///   'Lat': '',
  ///   'Long': '',
  /// }, // Value is empty by default, Please make sure of the value.
  /// ```
  static BasePersona defaultLocationField = Location(
    name: 'Location',
    description: 'Description',
    hint: 'Location',
    isPublic: true,
    value: jsonEncode(<String, String>{
      'Lat': '',
      'Long': '',
    }),
  );

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
