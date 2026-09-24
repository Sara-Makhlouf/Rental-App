class Booking {
  final int? id;
  String title;
  String status;
  final String image;
  String date;
  final double price;
  final int? rescheduleCount;

  Booking({
    this.id,
    required this.title,
    required this.image,
    required this.date,
    required this.price,
    required this.status,
    this.rescheduleCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'date': date,
      'price': price,
      'status': status,
      'reschedule_count': rescheduleCount,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    var apartment = map['apartment'] ?? {};
    var imagesUrls = apartment['images_urls'] as List? ?? [];
    var photos = apartment['photos'] as List? ?? [];

    // دالة مساعدة للتأكد من أن الرابط كامل
    String formatImageUrl(String path) {
      if (path.startsWith('http')) return path;

      return "http://10.130.61.158:8000/storage/$path";
    }

    String finalImage;
    if (imagesUrls.isNotEmpty) {
      finalImage = imagesUrls[0];
    } else if (photos.isNotEmpty) {
      finalImage = formatImageUrl(photos[0]);
    } else {
      finalImage = 'https://via.placeholder.com/400x200';
    }

    String cleanCheckIn = (map['check_in'] ?? '').toString().split('T').first;
    String cleanCheckOut = (map['check_out'] ?? '').toString().split('T').first;

    return Booking(
      id: map['id'],
      title: apartment['title'] ?? 'Apartment',
      image: finalImage,
      date: "$cleanCheckIn to $cleanCheckOut",
      price: (map['total_price'] ?? map['price'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      rescheduleCount: map['reschedule_count'] ?? 0,
    );
  }
}
