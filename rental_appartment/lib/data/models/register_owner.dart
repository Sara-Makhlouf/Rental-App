class RegisterResponse {
  final String message;
  final RegisterUser user;
  final String token;

  RegisterResponse({
    required this.message,
    required this.user,
    required this.token,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] ?? '',
      user: RegisterUser.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
      'token': token,
    };
  }
}

class RegisterUser {
  final String phone;
  final String firstName;
  final String lastName;
  final DateTime? dateOfBirth;
  final String role;
  final bool isApproved;
  final String? profilePicture;
  final String? idPicture;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int id;

  RegisterUser({
    required this.phone,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    required this.role,
    required this.isApproved,
    this.profilePicture,
    this.idPicture,
    this.updatedAt,
    this.createdAt,
    required this.id,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) {
    return RegisterUser(
      phone: json['phone'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'])
          : null,
      role: json['role'] ?? '',
      isApproved: json['is_approved'] ?? false,
      profilePicture: json['profile_picture'],
      idPicture: json['id_picture'],
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'role': role,
      'is_approved': isApproved,
      'profile_picture': profilePicture,
      'id_picture': idPicture,
      'updated_at': updatedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'id': id,
    };
  }
}
