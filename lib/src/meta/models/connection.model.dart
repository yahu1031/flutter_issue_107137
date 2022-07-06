import 'package:at_contact/at_contact.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'buzz_key.model.dart';

part 'connection.model.freezed.dart';
part 'connection.model.g.dart';

@freezed
class Connection with _$Connection {
  const Connection._();
  const factory Connection({
    String? atSign,
    ContactType? type,
    List<ContactCategory>? categories,
    bool? favourite,
    @Default(false) bool? blocked,
    Map<dynamic, dynamic>? tags,
    List<String>? personas,
    DateTime? createdOn,
    DateTime? updatedOn,
    BuzzKey? profilePicture,
    String? phoneNumber,
    String? email,
    @Default(false) bool error,
    String? errorMsg,
    @Default(false) bool isSelected,
  }) = _Connection;

  factory Connection.fromJson(Map<String, dynamic> json) =>
      _$ConnectionFromJson(json);

  factory Connection.fromAtContact(AtContact atContact) {
    return Connection(
        atSign: atContact.atSign,
        type: atContact.type,
        categories: atContact.categories,
        favourite: atContact.favourite,
        blocked: atContact.blocked,
        personas: atContact.personas,
        tags: atContact.tags,
        createdOn: atContact.createdOn,
        updatedOn: atContact.updatedOn);
  }
}
