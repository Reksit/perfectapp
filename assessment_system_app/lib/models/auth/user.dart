class User {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? department;
  final String? className;
  final String? phoneNumber;
  final bool? verified;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.department,
    this.className,
    this.phoneNumber,
    this.verified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      department: json['department'],
      className: json['className'],
      phoneNumber: json['phoneNumber'],
      verified: json['verified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'department': department,
      'className': className,
      'phoneNumber': phoneNumber,
      'verified': verified,
    };
  }
}