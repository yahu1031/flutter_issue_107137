import 'package:freezed_annotation/freezed_annotation.dart';

part 'index_tuple.freezed.dart';
part 'index_tuple.g.dart';

@freezed
class IndexTuple with _$IndexTuple {
  const factory IndexTuple({
    @Default(-1) int index,
    Object? value,
  }) = _IndexTuple;

  factory IndexTuple.fromJson(Map<String, dynamic> json) =>
      _$IndexTupleFromJson(json);
}
