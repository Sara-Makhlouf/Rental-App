class Apartment {
  final int id;
  final int ownerId;
  final String? title;
  final String? description;
  final String? address;
  final double? pricePerNight;
  final int? bedrooms;
  final int? bathrooms;
  final bool? isAvailable;
  final List<String>? imagesUrls;
  final List<String>? amenities;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Owner? owner;

  Apartment({
    required this.id,
    required this.ownerId,
    this.title,
    this.description,
    this.address,
    this.pricePerNight,
    this.bedrooms,
    this.bathrooms,
    this.isAvailable,
    this.imagesUrls,
    this.amenities,
    this.createdAt,
    this.updatedAt,
    this.owner,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json["id"] ?? 0,
      ownerId: json["owner_id"] ?? 0,
      title: json["title"],
      description: json["description"],
      address: json["address"],
      pricePerNight: json["price_per_night"] != null
          ? double.tryParse(json["price_per_night"].toString())
          : null,
      bedrooms: json["bedrooms"] != null
          ? int.tryParse(json["bedrooms"].toString())
          : null,
      bathrooms: json["bathrooms"] != null
          ? int.tryParse(json["bathrooms"].toString())
          : null,
      isAvailable: json["is_available"] == 1 || json["is_available"] == true,
      imagesUrls: json['images_urls'] != null
          ? List<String>.from(json['images_urls'])
          : [],
      amenities: json["amenities"] == null
          ? null
          : List<String>.from(json["amenities"]),
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
      owner: json["owner"] != null ? Owner.fromJson(json["owner"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "owner_id": ownerId,
    "title": title,
    "description": description,
    "address": address,
    "price_per_night": pricePerNight,
    "bedrooms": bedrooms,
    "bathrooms": bathrooms,
    "is_available": isAvailable,
    "images": imagesUrls,
    "amenities": amenities,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "owner": owner?.toJson(),
  };
}

class Owner {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? profilePicture;
  final String? idPicture;
  final String? role;
  final bool? isApproved;
  final String? themePreference;
  final DateTime? dateOfBirth;

  Owner({
    required this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.profilePicture,
    this.idPicture,
    this.role,
    this.isApproved,
    this.themePreference,
    this.dateOfBirth,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      phone: json["phone"],
      profilePicture: json["profile_picture"],
      idPicture: json["id_picture"],
      role: json["role"],
      isApproved: json["is_approved"],
      themePreference: json["theme_preference"],
      dateOfBirth: json["date_of_birth"] != null
          ? DateTime.tryParse(json["date_of_birth"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "profile_picture": profilePicture,
    "id_picture": idPicture,
    "role": role,
    "is_approved": isApproved,
    "theme_preference": themePreference,
    "date_of_birth": dateOfBirth?.toIso8601String(),
  };
}
