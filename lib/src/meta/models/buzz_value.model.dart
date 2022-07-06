import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'buzz_value.model.freezed.dart';
part 'buzz_value.model.g.dart';

@freezed
class BuzzValue with _$BuzzValue {
  const BuzzValue._();

  const factory BuzzValue({
    String? labelName,
    dynamic value,
    String? type,
    DateTime? createdDate,
    @Default(false) bool isHidden,
    int? ttl,
    int? ttb,
    int? ttr,
    bool? ccd,
    DateTime? availableAt,
    DateTime? expiresAt,
    DateTime? refreshAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? dataSignature,
    String? sharedKeyStatus,
    @Default(false) bool? isPublic,
    @Default(true) bool namespaceAware,
    @Default(false) bool? isBinary,
    bool? isEncrypted,
    @Default(false) bool isCached,
    String? sharedKeyEnc,
    String? pubKeyCS,
  }) = _BuzzValue;

  factory BuzzValue.fromJson(Map<String, dynamic> parsedJson) =>
      _$BuzzValueFromJson(parsedJson);

  factory BuzzValue.fromAtValue(AtValue atValue) => BuzzValue(
        value: atValue.value,
        ttb: atValue.metadata!.ttb,
        ttl: atValue.metadata!.ttl,
        ttr: atValue.metadata!.ttr,
        ccd: atValue.metadata?.ccd ?? false,
        isBinary: atValue.metadata?.isBinary ?? false,
        isCached: atValue.metadata?.isCached ?? false,
        isHidden: atValue.metadata?.isHidden ?? false,
        isPublic: atValue.metadata?.isPublic ?? false,
        isEncrypted: atValue.metadata?.isEncrypted ?? false,
        namespaceAware: atValue.metadata?.namespaceAware ?? true,
        createdDate: atValue.metadata?.createdAt ?? DateTime.now(),
        availableAt: atValue.metadata?.availableAt,
        expiresAt: atValue.metadata?.expiresAt,
        createdAt: atValue.metadata?.createdAt,
        refreshAt: atValue.metadata?.refreshAt,
        updatedAt: atValue.metadata?.updatedAt,
        sharedKeyEnc: atValue.metadata?.sharedKeyEnc,
        pubKeyCS: atValue.metadata?.pubKeyCS,
        dataSignature: atValue.metadata?.dataSignature,
        sharedKeyStatus: atValue.metadata?.sharedKeyStatus,
      );

  AtValue toAtValue() {
    return AtValue()
      ..value = value
      ..metadata = (Metadata()
        ..ccd = ccd
        ..createdAt = createdDate
        ..isPublic = isPublic
        ..isHidden = isHidden
        ..isBinary = isBinary
        ..isEncrypted = isEncrypted
        ..isCached = isCached
        ..namespaceAware = namespaceAware
        ..ttl = ttl
        ..ttb = ttb
        ..ttr = ttr
        ..createdAt = createdAt
        ..updatedAt = updatedAt
        ..refreshAt = refreshAt
        ..availableAt = availableAt
        ..expiresAt = expiresAt
        ..dataSignature = dataSignature
        ..pubKeyCS = pubKeyCS
        ..sharedKeyEnc = sharedKeyEnc
        ..sharedKeyStatus = sharedKeyStatus);
  }
}
