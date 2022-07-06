import 'package:freezed_annotation/freezed_annotation.dart';

/// API Request type
enum ApiRequest { post, get }

/// Notification type
enum Notification { update, delete }

/// Email type
enum EmailType {
  /// Professional/work email
  @JsonValue('work')
  work,

  /// Personal email
  @JsonValue('personal')
  personal,
}

/// Phone number type
enum PhoneType {
  /// Professional/work phone
  @JsonValue('work')
  work,

  /// Personal phone
  @JsonValue('personal')
  personal,

  /// Home phone
  @JsonValue('home')
  home,
}

enum BorderType { circle, rRect, rect, oval }
