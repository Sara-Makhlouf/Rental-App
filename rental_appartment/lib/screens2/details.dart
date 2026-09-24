import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_appartment/views/bopking.dart';
import '../data/models/apartment.dart';
import '../provider/setting_provuider.dart';
import '../provider/fav_provider.dart';

// ====== لوحة الألوان الجديدة ======
const kCoral = Color(0xFFFF9D9D); // أساسي - أزرار وتمييزات
const kPeach = Color(0xFFFFC5AA); // ثانوي - تدرجات
const kLimeCream = Color(0xFFEEF8CD); // خلفيات فاتحة وخطوط التذكرة
const kMint = Color(0xFFBBF1D2); // شرائط الأسعار والتأكيدات

const kBackground = Color(0xFFFDFDFD);
const kSecondaryText = Color(0xFF64748B);

class ApartmentDetailsPage extends StatelessWidget {
  final Apartment apartment;

  const ApartmentDetailsPage({super.key, required this.apartment});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsProvider, FavoritesProvider>(
      builder: (context, settings, fav, _) {
        final isArabic = settings.locale.languageCode == 'ar';
        final isFav = fav.isFavorite(apartment);

        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderImage(context, isFav, fav),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleAndPrice(settings),
                            const SizedBox(height: 24),
                            _buildInfoRow(settings),
                            const SizedBox(height: 30),
                            _buildDescriptionSection(settings),
                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildBottomAction(context, settings),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderImage(
    BuildContext context,
    bool isFav,
    FavoritesProvider fav,
  ) {
    return Stack(
      children: [
        Hero(
          tag: 'apartment_img_${apartment.id}',
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            child: Image.network(
              (apartment.imagesUrls != null && apartment.imagesUrls!.isNotEmpty)
                  ? apartment.imagesUrls![0]
                  : "https://via.placeholder.com/400x200.png?text=No+Image",
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120,
                color: Colors.grey[200],
                child: const Icon(
                  Icons.broken_image,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: () => Navigator.pop(context),
                ),
                _circleButton(
                  icon: isFav ? Icons.favorite : Icons.favorite_border,
                  iconColor: isFav ? kCoral : Colors.black87,
                  onTap: () => fav.toggleFavorite(apartment),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndPrice(SettingsProvider settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                apartment.title ?? '',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            Text(
              "\$${apartment.pricePerNight}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kCoral,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: kCoral),
            const SizedBox(width: 4),
            Text(
              apartment.address ?? '',
              style: const TextStyle(color: kSecondaryText, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(SettingsProvider settings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoItem(
          Icons.king_bed_outlined,
          apartment.bedrooms.toString(),
          settings.getLocalizedText('Beds', 'غرف'),
          kMint,
        ),
        _infoItem(
          Icons.bathtub_outlined,
          apartment.bathrooms.toString(),
          settings.getLocalizedText('Baths', 'حمامات'),
          kMint,
        ),
        _infoItem(
          Icons.straighten_outlined,
          "250",
          settings.getLocalizedText('m²', 'متر'),
          kMint,
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(SettingsProvider settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          settings.getLocalizedText('Description', 'التفاصيل'),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          apartment.description ?? '',
          style: const TextStyle(
            fontSize: 16,
            color: kSecondaryText,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context, SettingsProvider settings) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ApartmentBookingPage(apartment: apartment),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: kCoral,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 0,
          ),
          child: Text(
            settings.getLocalizedText('Book Now', 'احجز الآن'),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Icon(icon, color: iconColor ?? Colors.black87, size: 22),
      ),
    );
  }

  Widget _infoItem(IconData icon, String value, String label, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: kCoral, size: 26),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: kSecondaryText,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: kSecondaryText, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
