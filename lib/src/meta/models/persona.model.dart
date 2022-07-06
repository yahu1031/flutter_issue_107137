import 'package:freezed_annotation/freezed_annotation.dart';

import 'buzz_key.model.dart';

part 'persona.model.freezed.dart';
part 'persona.model.g.dart';

@freezed
class Persona with _$Persona {
  const Persona._();
  const factory Persona({
    String? name,
    @Default(false) bool isSelected,
    List<BuzzKey>? keysList,
    List<String>? atSignsList,
    Map<String, String?>? personasSharedWith,
  }) = _Persona;

  factory Persona.fromJson(Map<String, dynamic> json) => Persona(
        atSignsList: (json['atSigns'] as List<dynamic>)
            .map((dynamic e) => e.toString())
            .toList(),
        name: json['name'],
        keysList: (json['entityList'] as List<dynamic>)
            // ignore: unnecessary_lambdas
            .map((_) => BuzzKey.fromJson(_))
            .toList(),
        personasSharedWith: json['sharedWith']
      );

  @override
  String toString() =>
      'Persona{name: $name, isSelected: $isSelected, keysList: $keysList, atSignsList: $atSignsList}';
}
