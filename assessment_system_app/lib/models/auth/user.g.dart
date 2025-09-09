// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  role: json['role'] as String,
  department: json['department'] as String?,
  className: json['className'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  verified: json['verified'] as bool?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'role': instance.role,
  'department': instance.department,
  'className': instance.className,
  'phoneNumber': instance.phoneNumber,
  'verified': instance.verified,
};

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      department: json['department'] as String?,
      className: json['className'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      verified: json['verified'] as bool?,
      accessToken: json['accessToken'] as String,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': instance.role,
      'department': instance.department,
      'className': instance.className,
      'phoneNumber': instance.phoneNumber,
      'verified': instance.verified,
      'accessToken': instance.accessToken,
    };
