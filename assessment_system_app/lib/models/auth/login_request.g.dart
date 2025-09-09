// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      department: json['department'] as String?,
      className: json['className'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'name': instance.name,
      'role': instance.role,
      'department': instance.department,
      'className': instance.className,
      'phoneNumber': instance.phoneNumber,
    };

OTPVerificationRequest _$OTPVerificationRequestFromJson(
  Map<String, dynamic> json,
) => OTPVerificationRequest(
  email: json['email'] as String,
  otp: json['otp'] as String,
);

Map<String, dynamic> _$OTPVerificationRequestToJson(
  OTPVerificationRequest instance,
) => <String, dynamic>{'email': instance.email, 'otp': instance.otp};
