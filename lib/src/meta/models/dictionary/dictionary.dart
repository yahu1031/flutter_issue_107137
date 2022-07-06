import 'package:freezed_annotation/freezed_annotation.dart';

import 'blood/blood.model.dart';
import 'date/date.model.dart';
import 'email/email.model.dart';
import 'fax/fax.model.dart';
import 'file/file.model.dart';
import 'image/image.model.dart';
import 'links/links.model.dart';
import 'location/location.model.dart';
import 'password/password.model.dart';
import 'phone/phone.model.dart';

part 'dictionary.freezed.dart';
part 'dictionary.g.dart';

@Freezed()
class Dictionary with _$Dictionary {
  const factory Dictionary({
    List<Fax>? faxes,
    List<Date>? dates,
    List<Password>? passwords,
    List<Email>? emails,
    List<Phone>? phones,
    BloodGroup? bloodGroup,
    List<Url>? urls,
    List<UserFile>? userFiles,
    List<UserImage>? images,
    List<Location>? locations,
  }) = _Dictionary;

  factory Dictionary.fromJson(Map<String, dynamic> json) =>
      _$DictionaryFromJson(json);
}
