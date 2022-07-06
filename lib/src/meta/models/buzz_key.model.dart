// 📦 Package imports:
import 'package:at_commons/at_commons.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// 🌎 Project imports:
import '../utils/buzz_env.dart';
import 'buzz_value.model.dart';

part 'buzz_key.model.freezed.dart';
part 'buzz_key.model.g.dart';

// BuzzValue _buzzValue() => BuzzValue();
// DateTime _time() => DateTime.now();

@freezed
class BuzzKey with _$BuzzKey {
  const BuzzKey._();

  @JsonSerializable(explicitToJson: true)
  const factory BuzzKey({
    @Default(null) String? key,
    BuzzValue? value,
    @Default(null) String? sharedWith,
    @Default(null) String? sharedBy,
    @Default('buzz') String namespace,
    @Default(false) bool isPublic,
    @Default(false) bool isCached,
    @Default(false) bool isHidden,
    @Default(false) bool isBinary,
    @Default(false) bool isRef,
    @Default(false) bool ccd,
    @Default(false) bool isEncrypted,
    @Default(true) bool namespaceAware,
    DateTime? createdDate,
    @Default(null) int? ttb,
    @Default(null) int? ttl,
    @Default(null) int? ttr,
  }) = _BuzzKey;

  factory BuzzKey.fromJson(Map<String, dynamic> json) =>
      _$BuzzKeyFromJson(json);

  factory BuzzKey.fromAtKey(AtKey atKey) => BuzzKey(
        key: atKey.key!,
        sharedBy: atKey.sharedBy!,
        sharedWith: atKey.sharedWith,
        ttb: atKey.metadata!.ttb,
        ttl: atKey.metadata!.ttl,
        ttr: atKey.metadata!.ttr,
        isBinary: atKey.metadata?.isBinary ?? false,
        isCached: atKey.metadata?.isCached ?? false,
        isHidden: atKey.metadata?.isHidden ?? false,
        isPublic: atKey.metadata?.isPublic ?? false,
        isEncrypted: atKey.metadata?.isEncrypted ?? false,
        namespaceAware: atKey.metadata?.namespaceAware ?? true,
        namespace: atKey.namespace ?? BuzzEnv.appNamespace,
        createdDate: atKey.metadata?.createdAt ?? DateTime.now(),
        ccd: atKey.metadata?.ccd ?? false,
        isRef: atKey.isRef,
      );

  AtKey toAtKey() {
    return AtKey()
      ..key = key
      ..isRef = isRef
      ..sharedBy = sharedBy
      ..sharedWith = sharedWith
      ..namespace = namespace
      ..metadata = (Metadata()
        ..ccd = ccd
        ..createdAt = createdDate
        ..isPublic = isPublic
        ..isHidden = isHidden
        ..isCached = isCached
        ..isEncrypted = isEncrypted
        ..isBinary = isBinary
        ..namespaceAware = namespaceAware
        ..ttl = ttl
        ..ttb = ttb
        ..ttr = ttr);
  }

  @override
  String toString() => 'BuzzKey{key: $key ,value: ${value.toString()},isPublic: $isPublic, isCached: $isCached, isHidden: $isHidden,isBinary: $isBinary, namespaceAware : $namespaceAware , isEncrypted : $isEncrypted, ttl: $ttl, ttb: $ttb, ttr: $ttr ,sharedWith : $sharedWith, sharedBy : $sharedBy, isref : $isRef}';
}
