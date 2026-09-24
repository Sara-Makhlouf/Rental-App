class LoginResponse {
  final String message;
  final LoginUser? user; // Nullable
  final String? token;   // Nullable

  LoginResponse({
    required this.message,
    this.user,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] ?? '',
      user: json['user'] != null ? LoginUser.fromJson(json['user']) : null,
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user?.toJson(),
      'token': token,
    };
  }
}

class LoginUser {
  final int id;
  final String? name;
  final String? email;
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String phone;
  final String firstName;
  final String lastName;
  final String? profilePicture;
  final DateTime? dateOfBirth;
  final String? idPicture;
  final String role;
  final bool isApproved;
  final String themePreference;

  LoginUser({
    required this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    required this.phone,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
    this.dateOfBirth,
    this.idPicture,
    required this.role,
    required this.isApproved,
    required this.themePreference,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      id: json['id'] ?? 0,
      name: json['name'],   
      email: json['email'], 
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.tryParse(json['email_verified_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      phone: json['phone'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      profilePicture: json['profile_picture'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'])
          : null,
      idPicture: json['id_picture'],
      role: json['role'] ?? 'tenant',
      isApproved: json['is_approved'] ?? false,
      themePreference: json['theme_preference'] ?? 'light',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'profile_picture': profilePicture,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'id_picture': idPicture,
      'role': role,
      'is_approved': isApproved,
      'theme_preference': themePreference,
    };
  }
}
