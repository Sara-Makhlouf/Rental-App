import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:rental_appartment/controllers/authcontroller.dart';
import 'package:rental_appartment/controllers/favcontroller.dart';
import 'package:rental_appartment/core/services/notiefication_service.dart';
import 'package:rental_appartment/screens2/details.dart';
import 'package:rental_appartment/screens2/events.dart';
import 'package:rental_appartment/screens2/favourit.dart';
import 'package:rental_appartment/screens2/setting.dart';
import 'package:rental_appartment/screens2/userprof.dart';
import 'package:rental_appartment/views/login_view.dart';
import '../data/models/apartment.dart';
import '../provider/setting_provuider.dart';
import '../controllers/apartment_controller.dart';

// ====== لوحة الألوان ======
const kCoral = Color(0xFFFF9D9D); // أساسي - أزرار وتمييزات
const kPeach = Color(0xFFFFC5AA); // ثانوي - تدرجات
const kLimeCream = Color(0xFFEEF8CD); // خلفيات فاتحة وخطوط التذكرة
const kMint = Color(0xFFBBF1D2); // شرائط الأسعار والتأكيدات

const kDarkText = Color(0xFF3B3634); // لون حبر التذكرة (بني داكن دافئ)
const kSecondaryText = Color(0xFF8B8378);
const kBgColor = Color(0xFFFFFCF7);

// أسماء متوافقة مع الاستخدام القديم
const kPrimaryPink = kCoral;
const kPurpleDeep = kPeach;
const kDarkBlue = kMint;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApartmentController controller = Get.put(ApartmentController());
  final FavoriteController favController = Get.put(FavoriteController());
  AuthController authController = AuthController();
  final TextEditingController searchController = TextEditingController();

  int _currentIndex = 0;
  double maxPrice = 5000;
  List<Apartment> filteredApartments = [];

  @override
  void initState() {
    super.initState();
    controller.fetchApartments();

    ever<List<Apartment>>(controller.apartments, (list) {
      if (mounted) {
        setState(() {
          filteredApartments = List.from(list);
        });
      }
    });
    NotificationService.listenForeground();
    NotificationService.listenNotificationClick();
  }

  void applyFilter() {
    final q = searchController.text.toLowerCase();
    setState(() {
      filteredApartments = controller.apartments.where((ap) {
        final title = ap.title?.toLowerCase() ?? '';
        final address = ap.address?.toLowerCase() ?? '';
        final price = ap.pricePerNight ?? 0;
        return (title.contains(q) || address.contains(q)) && price <= maxPrice;
      }).toList();
    });
  }

  void _showRatingDialog(String apartmentTitle) {
    double userRating = 0;
    Get.defaultDialog(
      title: "تقييم الإقامة",
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: kDarkText,
      ),
      backgroundColor: Colors.white,
      radius: 20,
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return Column(
            children: [
              Text(
                apartmentTitle,
                style: const TextStyle(fontSize: 14, color: kDarkText),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < userRating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: kCoral,
                      size: 35,
                    ),
                    onPressed: () =>
                        setDialogState(() => userRating = index + 1.0),
                  );
                }),
              ),
            ],
          );
        },
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kCoral,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () {
          Get.back();
          Get.snackbar(
            "شكراً لك!",
            "تم استلام تقييمك",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: kMint,
            colorText: kDarkText,
          );
        },
        child: const Text("إرسال", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        final isArabic = settings.locale.languageCode == 'ar';

        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: kBgColor,
            extendBody: true,
            appBar: buildAppBar(settings),
            drawer: Drawer(child: drawer(settings)),
            bottomNavigationBar: bottomNav(settings),
            body: _currentIndex == 0
                ? homeBody(settings)
                : placeholderPage(
                    _currentIndex == 1
                        ? settings.getLocalizedText('Favorites', 'المفضلة')
                        : settings.getLocalizedText('Bookings', 'الحجوزات'),
                  ),
          ),
        );
      },
    );
  }

  // ===== AppBar بلمسة "بطاقة صعود" =====
  PreferredSizeWidget buildAppBar(SettingsProvider settings) {
    return AppBar(
      backgroundColor: kBgColor,
      elevation: 0,
      centerTitle: false,
      toolbarHeight: 70,
      iconTheme: const IconThemeData(color: kDarkText),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            settings.getLocalizedText('YOUR NEXT STAY', 'وجهتك القادمة'),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: kSecondaryText,
              letterSpacing: 2.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            settings.getLocalizedText('Explore Apartments', 'استكشف الشقق'),
            style: const TextStyle(
              color: kDarkText,
              fontWeight: FontWeight.w900,
              fontSize: 21,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: kMint.withOpacity(0.45),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_activity_rounded,
                    size: 15,
                    color: kDarkText,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${controller.apartments.length}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: kDarkText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget homeBody(SettingsProvider settings) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: kCoral));
      }

      return Column(
        children: [
          // الهيرو + البحث يبقوا ثابتين
          buildHeroStamp(settings),
          buildSearchAndFilter(settings),

          // قائمة الشقق هي التي تعمل Scroll
          Expanded(
            child: filteredApartments.isEmpty
                ? emptyState(settings)
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 6, bottom: 100),
                    itemCount: filteredApartments.length,
                    itemBuilder: (context, index) {
                      final ap = filteredApartments[index];

                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ApartmentDetailsPage(apartment: ap));
                        },
                        child: boardingPassCard(ap, settings),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  // ===== العنصر المميز #1: بطاقة "ختم جواز سفر" في الأعلى =====
  Widget buildHeroStamp(SettingsProvider settings) {
    final List<Map<String, dynamic>> slides = [
      {
        'title': settings.getLocalizedText(
          'Find your perfect stay',
          'إقامتك المثالية',
        ),
        'sub': settings.getLocalizedText(
          'Luxury & Comfort',
          'فخامة وراحة تامة',
        ),
        'icon': Icons.home_work_rounded,
        'colors': [kCoral, kPeach],
      },
      {
        'title': settings.getLocalizedText(
          'Best City Locations',
          'أفضل مواقع المدن',
        ),
        'sub': settings.getLocalizedText(
          'Close to everything',
          'قريب من كل شيء',
        ),
        'icon': Icons.location_city_rounded,
        'colors': [kPeach, kMint],
      },
      {
        'title': settings.getLocalizedText(
          'Verified Reviews',
          'تقييمات موثوقة',
        ),
        'sub': settings.getLocalizedText(
          'Trusted by thousands',
          'يثق بنا الآلاف',
        ),
        'icon': Icons.verified_user_rounded,
        'colors': [kMint, kLimeCream],
      },
    ];

    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.88),
        itemCount: slides.length,
        itemBuilder: (context, index) {
          final s = slides[index];
          final colors = s['colors'] as List<Color>;
          return Container(
            margin: const EdgeInsets.fromLTRB(8, 10, 8, 4),
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors[0].withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      s['title'],
                      style: const TextStyle(
                        color: kDarkText,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.3,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      s['sub'],
                      style: TextStyle(
                        color: kDarkText.withOpacity(0.65),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // ختم دائري مزخرف بحدود متقطعة، بلمسة "موافق عليه" مائلة
                Positioned(
                  right: -6,
                  bottom: -6,
                  child: Transform.rotate(
                    angle: -0.22,
                    child: _StampBadge(icon: s['icon'] as IconData),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchAndFilter(SettingsProvider settings) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kLimeCream, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: kCoral.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (_) => applyFilter(),
              style: const TextStyle(color: kDarkText),
              decoration: InputDecoration(
                hintText: settings.getLocalizedText(
                  'Search by name or city...',
                  'ابحث عن اسم أو مدينة...',
                ),
                hintStyle: const TextStyle(color: kSecondaryText),
                prefixIcon: const Icon(Icons.search_rounded, color: kCoral),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            CustomPaint(
              painter: _DashedLinePainter(
                color: kLimeCream,
                dashWidth: 5,
                dashSpace: 4,
              ),
              size: const Size(double.infinity, 1.2),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  settings.getLocalizedText('BUDGET', 'الميزانية'),
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: kSecondaryText,
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbColor: kCoral,
                      activeTrackColor: kCoral,
                      inactiveTrackColor: kMint.withOpacity(0.4),
                      overlayColor: kCoral.withOpacity(0.15),
                      trackHeight: 3,
                    ),
                    child: Slider(
                      value: maxPrice,
                      min: 0,
                      max: 5000,
                      onChanged: (v) {
                        setState(() => maxPrice = v);
                        applyFilter();
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: kCoral.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "\$${maxPrice.toInt()}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: kCoral,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===== العنصر المميز #2: بطاقة الشقة بشكل "بطاقة صعود الطائرة" =====
  Widget boardingPassCard(Apartment ap, SettingsProvider settings) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: ClipPath(
        clipper: _TicketClipper(notchRadius: 11, notchFraction: 0.62),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- جزء الصورة (مثل صورة الوجهة) ----
              Stack(
                children: [
                  Image.network(
                    (ap.imagesUrls != null && ap.imagesUrls!.isNotEmpty)
                        ? ap.imagesUrls![0]
                        : "https://via.placeholder.com/400x200.png?text=No+Image",
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 130,
                      color: kLimeCream,
                      child: const Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Obx(() {
                      bool isFav = favController.isFavorite(ap.id);
                      return GestureDetector(
                        onTap: () => favController.toggleFavorite(ap),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.92),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? kCoral : Colors.grey,
                            size: 20,
                          ),
                        ),
                      );
                    }),
                  ),
                  // شريط "STAY" مائل، بديل شارة التقييم القديمة
                  Positioned(
                    top: 14,
                    right: -30,
                    child: Transform.rotate(
                      angle: 0.78,
                      child: Container(
                        width: 110,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        color: kCoral,
                        child: const Text(
                          "STAY",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ---- خط التقطيع المتقطع، بلمسة الحواف المسننة الحقيقية للتذكرة ----
              CustomPaint(
                painter: _DashedLinePainter(
                  color: kLimeCream,
                  dashWidth: 5,
                  dashSpace: 4,
                  strokeWidth: 1.4,
                ),
                size: const Size(double.infinity, 1.4),
              ),

              // ---- جزء "كعب" التذكرة: التفاصيل والسعر ----
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ap.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: kDarkText,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: kSecondaryText,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  ap.address ?? '',
                                  style: const TextStyle(
                                    color: kSecondaryText,
                                    fontSize: 12.5,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => _showRatingDialog(ap.title ?? ""),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: kPeach,
                                  size: 17,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  settings.getLocalizedText(
                                    'Rate Now',
                                    'قيم الآن',
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11.5,
                                    color: kSecondaryText,
                                    decoration: TextDecoration.underline,
                                    decorationColor: kSecondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: kMint.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            settings.getLocalizedText('PER NIGHT', 'لليلة'),
                            style: const TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                              color: kSecondaryText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "\$${ap.pricePerNight}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: kCoral,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawer(SettingsProvider settings) {
    return Drawer(
      backgroundColor: kBgColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [kCoral, kPeach],
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: kCoral, size: 32),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Drawer",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          color: kDarkText,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Premium Member since 2024",
                        style: TextStyle(fontSize: 11.5, color: kDarkText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          drawerItem(
            Icons.person,
            settings.getLocalizedText('Profile', 'الملف الشخصي'),
            "info",
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          drawerItem(
            Icons.account_balance_wallet_outlined,
            settings.getLocalizedText('My Wallet', 'محفظتي'),
            "Balance: \$1,250",
            () {},
          ),
          drawerItem(
            Icons.card_giftcard_rounded,
            settings.getLocalizedText('Offers', 'العروض الخاصة'),
            "Get 20% discount",
            () {},
          ),
          drawerItem(
            Icons.headset_mic_outlined,
            settings.getLocalizedText('Support', 'مركز الدعم والمساعدة'),
            "24/7 Service",
            () {},
          ),
          drawerItem(
            Icons.settings_outlined,
            settings.getLocalizedText('Settings', 'الإعدادات'),
            null,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
            height: 40,
            color: kLimeCream,
          ),
          drawerItem(
            Icons.info_outline,
            settings.getLocalizedText('About', 'عن التطبيق'),
            null,
            () {},
          ),
          const SizedBox(height: 10),
          drawerItem(
            Icons.logout_rounded,
            settings.getLocalizedText('Logout', 'تسجيل الخروج'),
            null,
            () async {
              await authController.logout();
              Provider.of<SettingsProvider>(
                context,
                listen: false,
              ).clearUserData();
              Get.offAll(() => LoginView());
            },
            isError: true,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget drawerItem(
    IconData icon,
    String title,
    String? subTitle,
    VoidCallback onTap, {
    bool isError = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isError ? Colors.redAccent : kCoral),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isError ? Colors.redAccent : kDarkText,
        ),
      ),
      subtitle: subTitle != null
          ? Text(
              subTitle,
              style: const TextStyle(fontSize: 11, color: kSecondaryText),
            )
          : null,
      onTap: onTap,
    );
  }

  // ===== العنصر المميز #3: شريط تنقل عائم بمؤشر منزلق =====
  Widget bottomNav(SettingsProvider settings) {
    final items = [
      {
        'icon': Icons.explore_outlined,
        'active': Icons.explore,
        'label': settings.getLocalizedText('Home', 'الرئيسية'),
      },
      {
        'icon': Icons.favorite_border,
        'active': Icons.favorite,
        'label': settings.getLocalizedText('Favorites', 'المفضلة'),
      },
      {
        'icon': Icons.calendar_today_outlined,
        'active': Icons.calendar_today,
        'label': settings.getLocalizedText('Bookings', 'حجوزاتي'),
      },
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
        child: Container(
          height: 66,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: kDarkText.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = _currentIndex == i;

              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (i == 0) {
                      setState(() => _currentIndex = i);
                    }
                    if (i == 1) {
                      Get.to(() => const FavouritePage());
                    }
                    if (i == 2) {
                      Get.to(() => EventPage());
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selected ? kCoral : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          selected
                              ? items[i]['active'] as IconData
                              : items[i]['icon'] as IconData,
                          color: selected ? Colors.white : kSecondaryText,
                          size: 22,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          items[i]['label'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: selected ? Colors.white : kSecondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget placeholderPage(String title) => Center(
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: kDarkText,
      ),
    ),
  );

  Widget emptyState(SettingsProvider settings) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.airplane_ticket_outlined, size: 48, color: kLimeCream),
        const SizedBox(height: 10),
        Text(
          settings.getLocalizedText('No apartments found', 'لا توجد نتائج'),
          style: const TextStyle(
            color: kSecondaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

// ============================================================
// أدوات رسم مخصصة تصنع لمسة "بطاقة الصعود / التذكرة"
// ============================================================

/// يقص الحاوية بحواف دائرية، ويضيف "عضّتين" نصف دائريتين على الجانبين
/// عند نسبة معينة من الارتفاع، لمحاكاة ثقب تذكرة حقيقية.
class _TicketClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double notchFraction;
  _TicketClipper({required this.notchRadius, required this.notchFraction});

  @override
  Path getClip(Size size) {
    final notchY = size.height * notchFraction;
    const r = 22.0;
    final path = Path()
      ..moveTo(r, 0)
      ..lineTo(size.width - r, 0)
      ..arcToPoint(Offset(size.width, r), radius: const Radius.circular(r))
      ..lineTo(size.width, notchY - notchRadius)
      ..arcToPoint(
        Offset(size.width, notchY + notchRadius),
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..lineTo(size.width, size.height - r)
      ..arcToPoint(
        Offset(size.width - r, size.height),
        radius: const Radius.circular(r),
      )
      ..lineTo(r, size.height)
      ..arcToPoint(Offset(0, size.height - r), radius: const Radius.circular(r))
      ..lineTo(0, notchY + notchRadius)
      ..arcToPoint(
        Offset(0, notchY - notchRadius),
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..lineTo(0, r)
      ..arcToPoint(Offset(r, 0), radius: const Radius.circular(r))
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// يرسم خط متقطع أفقي، يمثل خط تمزيق التذكرة.
class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  _DashedLinePainter({
    required this.color,
    this.dashWidth = 5,
    this.dashSpace = 4,
    this.strokeWidth = 1.2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;
    double startX = 0;
    final y = size.height / 2;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// شارة دائرية بحدود متقطعة تحاكي "ختم" جواز السفر، تُستخدم فوق شرائح الهيرو.
class _StampBadge extends StatelessWidget {
  final IconData icon;
  const _StampBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      height: 78,
      child: CustomPaint(
        painter: _DashedCirclePainter(color: Colors.white.withOpacity(0.9)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 2),
              const Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    const dashCount = 26;
    const gapFraction = 0.45;
    for (int i = 0; i < dashCount; i++) {
      final startAngle = (2 * math.pi / dashCount) * i;
      final sweep = (2 * math.pi / dashCount) * (1 - gapFraction);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
