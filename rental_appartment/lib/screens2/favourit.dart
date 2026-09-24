import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rental_appartment/controllers/favcontroller.dart';
import 'package:rental_appartment/provider/setting_provuider.dart';
import 'package:rental_appartment/views/bopking.dart';
import '../data/models/apartment.dart';

// =====================================================
// 🎨 App Color Palette
// =====================================================

const kCoral = Color(0xFFFF9D9D); // Primary
const kPeach = Color(0xFFFFC5AA); // Secondary
const kLimeCream = Color(0xFFEEF8CD); // Light backgrounds
const kMint = Color(0xFFBBF1D2); // Prices / confirmations

const kDarkText = Color(0xFF25313C);
const kSecondaryText = Color(0xFF7C8A93);
const kBgColor = Color(0xFFFFFCF7);

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favController = Get.put(FavoriteController());

    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, _) {
        final isArabic = settingsProvider.locale.languageCode == 'ar';

        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: kBgColor,

            // =====================================================
            // App Bar
            // =====================================================
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,

              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: kDarkText.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    isArabic
                        ? Icons.arrow_forward_ios_rounded
                        : Icons.arrow_back_ios_new_rounded,
                    size: 17,
                    color: kDarkText,
                  ),
                ),
              ),

              title: Column(
                children: [
                  Text(
                    settingsProvider.getLocalizedText(
                      'My Favourites',
                      'المفضلة',
                    ),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: kDarkText,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    settingsProvider.getLocalizedText(
                      'Your favourite apartments',
                      'الشقق التي أعجبتك',
                    ),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: kSecondaryText,
                    ),
                  ),
                ],
              ),

              toolbarHeight: 82,
            ),

            // =====================================================
            // Body
            // =====================================================
            body: Obx(() {
              if (favController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: kCoral,
                    strokeWidth: 3,
                  ),
                );
              }

              if (favController.favorites.isEmpty) {
                return _emptyState(settingsProvider);
              }

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                itemCount: favController.favorites.length,
                itemBuilder: (context, index) {
                  final apartment = favController.favorites[index];

                  return _apartmentCard(
                    context,
                    apartment,
                    favController,
                    settingsProvider,
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }

  // =====================================================
  // Empty State
  // =====================================================

  Widget _emptyState(SettingsProvider settingsProvider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kCoral.withOpacity(0.12),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: kPeach.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Icon(Icons.favorite_rounded, size: 45, color: kCoral),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Text(
              settingsProvider.getLocalizedText(
                'No favorite apartments yet',
                'لا توجد شقق مفضلة بعد',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: kDarkText,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              settingsProvider.getLocalizedText(
                'Save apartments you love and find them here later.',
                'احفظ الشقق التي تعجبك لتجدها هنا لاحقاً.',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: kSecondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // Apartment Card
  // =====================================================

  Widget _apartmentCard(
    BuildContext context,
    Apartment apartment,
    FavoriteController fav,
    SettingsProvider settingsProvider,
  ) {
    final isArabic = settingsProvider.locale.languageCode == 'ar';

    final isFav = fav.isFavorite(apartment.id);

    final imageUrl =
        (apartment.imagesUrls != null && apartment.imagesUrls!.isNotEmpty)
        ? apartment.imagesUrls!.first
        : '';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: kDarkText.withOpacity(0.07),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // Image
            // =====================================================
            Stack(
              children: [
                SizedBox(
                  height: 205,
                  width: double.infinity,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _imagePlaceholder();
                          },
                        )
                      : _imagePlaceholder(),
                ),

                // Soft image overlay
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.10),
                            Colors.transparent,
                            Colors.black.withOpacity(0.08),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Favorite button
                Positioned(
                  top: 14,
                  right: isArabic ? null : 14,
                  left: isArabic ? 14 : null,
                  child: GestureDetector(
                    onTap: () => fav.toggleFavorite(apartment),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFav
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFav ? kCoral : kSecondaryText,
                        size: 23,
                      ),
                    ),
                  ),
                ),

                // Price badge
                Positioned(
                  bottom: 14,
                  left: isArabic ? null : 14,
                  right: isArabic ? 14 : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: kMint,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: kDarkText.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$${apartment.pricePerNight ?? 0}',
                          style: const TextStyle(
                            color: kDarkText,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          settingsProvider.getLocalizedText(
                            '/ night',
                            '/ الليلة',
                          ),
                          style: const TextStyle(
                            color: kSecondaryText,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // =====================================================
            // Card Content
            // =====================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(17, 17, 17, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    apartment.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      color: kDarkText,
                      letterSpacing: -0.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      Container(
                        width: 29,
                        height: 29,
                        decoration: BoxDecoration(
                          color: kPeach.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          size: 16,
                          color: kCoral,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          apartment.address ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: kSecondaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Divider
                  Container(height: 1, color: kLimeCream),

                  const SizedBox(height: 15),

                  // Book Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => Get.to(
                        () => ApartmentBookingPage(apartment: apartment),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kCoral,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_month_rounded, size: 19),
                          const SizedBox(width: 8),
                          Text(
                            settingsProvider.getLocalizedText(
                              'Book Now',
                              'احجز الآن',
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // Image Placeholder
  // =====================================================

  Widget _imagePlaceholder() {
    return Container(
      color: kLimeCream,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.home_work_rounded, size: 32, color: kCoral),
          ),
          const SizedBox(height: 10),
          const Text(
            'No Image Available',
            style: TextStyle(
              color: kSecondaryText,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
