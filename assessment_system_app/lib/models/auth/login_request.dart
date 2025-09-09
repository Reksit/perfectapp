import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest extends Equatable {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  @override
  List<Object> get props => [email, password];
}

@JsonSerializable()
class RegisterRequest extends Equatable {
  final String email;
  final String password;
  final String name;
  final String role;
  final String? department;
  final String? className;
  final String? phoneNumber;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    this.department,
    this.className,
    this.phoneNumber,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);

  @override
  List<Object?> get props => [
        email,
        password,
        name,
        role,
        department,
        className,
        phoneNumber,
      ];
}

@JsonSerializable()
class OTPVerificationRequest extends Equatable {
  final String email;
  final String otp;

  const OTPVerificationRequest({
    required this.email,
    required this.otp,
  });

  factory OTPVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$OTPVerificationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$OTPVerificationRequestToJson(this);

  @override
  List<Object> get props => [email, otp];
}