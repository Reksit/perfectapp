import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? department;
  final String? className;
  final String? phoneNumber;
  final bool? verified;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.department,
    this.className,
    this.phoneNumber,
    this.verified,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? department,
    String? className,
    String? phoneNumber,
    bool? verified,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      department: department ?? this.department,
      className: className ?? this.className,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verified: verified ?? this.verified,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        role,
        department,
        className,
        phoneNumber,
        verified,
      ];
}

@JsonSerializable()
class LoginResponse extends Equatable {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? department;
  final String? className;
  final String? phoneNumber;
  final bool? verified;
  final String accessToken;

  const LoginResponse({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.department,
    this.className,
    this.phoneNumber,
    this.verified,
    required this.accessToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        role,
        department,
        className,
        phoneNumber,
        verified,
        accessToken,
      ];
}