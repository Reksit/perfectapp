class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RegisterRequest {
  final String email;
  final String password;
  final String name;
  final String role;
  final String? department;
  final String? className;
  final String? phoneNumber;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    this.department,
    this.className,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'role': role,
      'department': department,
      'className': className,
      'phoneNumber': phoneNumber,
    };
  }
}

class OTPVerificationRequest {
  final String email;
  final String otp;

  OTPVerificationRequest({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}

class LoginResponse {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? department;
  final String? className;
  final String? phoneNumber;
  final bool? verified;
  final String accessToken;

  LoginResponse({
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

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      department: json['department'],
      className: json['className'],
      phoneNumber: json['phoneNumber'],
      verified: json['verified'],
      accessToken: json['accessToken'] ?? '',
    );
  }
}