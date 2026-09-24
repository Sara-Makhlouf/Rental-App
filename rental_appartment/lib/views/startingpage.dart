import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:rental_appartment/data/models/startdata.dart';
import 'package:rental_appartment/provider/setting_provuider.dart';
import 'package:rental_appartment/views/login_view.dart';

const kCoral = Color(0xFFFF9D9D);
const kPeach = Color(0xFFFFC5AA);
const kLimeCream = Color(0xFFEEF8CD);
const kMint = Color(0xFFBBF1D2);

const kDarkText = Color(0xFF25313C);
const kSecondaryText = Color(0xFF64748B);

// ============================================================
// ONBOARDING VIEW
// ============================================================

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    final isArabic = settings.locale.languageCode == 'ar';

    // ==========================================================
    // ONBOARDING DATA
    // ==========================================================

    final pages = [
      OnboardData(
        image:
            'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=800&q=80',

        title: settings.getLocalizedText(
          'Find Your Dream Apartment',
          'اعثر على شقتك المثالية',
        ),

        description: settings.getLocalizedText(
          'Explore listings with real images, details, and reviews.',
          'تصفح الشقق مع صور حقيقية وتفاصيل وتقييمات.',
        ),

        gradient: const [kLimeCream, kMint],
      ),

      OnboardData(
        image:
            'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=800&q=80',

        title: settings.getLocalizedText(
          'Fast & Easy Booking',
          'حجز سريع وسهل',
        ),

        description: settings.getLocalizedText(
          'Reserve apartments instantly with confidence and security.',
          'احجز شقتك بسرعة وسهولة وبكل ثقة وأمان.',
        ),

        gradient: const [kPeach, kLimeCream],
      ),

      OnboardData(
        image:
            'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80',

        title: settings.getLocalizedText(
          'Manage Your Properties',
          'إدارة شققك',
        ),

        description: settings.getLocalizedText(
          'Owners can manage listings, bookings, and income professionally.',
          'يمكن لأصحاب العقارات إدارة الشقق والحجوزات والدخل باحتراف.',
        ),

        gradient: const [kCoral, kPeach],
      ),
    ];

    // ==========================================================
    // VIEW
    // ==========================================================

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,

      child: Scaffold(
        backgroundColor: kLimeCream,

        body: Stack(
          children: [
            // ==================================================
            // BACKGROUND
            // ==================================================
            AnimatedContainer(
              duration: const Duration(milliseconds: 700),

              curve: Curves.easeInOut,

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,

                  colors: pages[_index].gradient,
                ),
              ),
            ),

            // Soft decorative circles
            Positioned(
              top: -80,
              right: -60,

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),

                width: 220,
                height: 220,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Positioned(
              bottom: 120,
              left: -100,

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),

                width: 240,
                height: 240,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // ==================================================
            // CONTENT
            // ==================================================
            SafeArea(
              child: Column(
                children: [
                  // ==============================================
                  // TOP AREA
                  // ==============================================
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,

                      itemCount: pages.length,

                      onPageChanged: (i) {
                        setState(() {
                          _index = i;
                        });
                      },

                      itemBuilder: (_, i) {
                        return _AnimatedOnboardPage(
                          data: pages[i],
                          index: i,
                          currentIndex: _index,
                        );
                      },
                    ),
                  ),

                  // ==============================================
                  // BOTTOM CONTROLS
                  // ==============================================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 25),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        // Indicator
                        _indicator(pages.length),

                        const SizedBox(height: 25),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            // ==================================
                            // SKIP
                            // ==================================
                            TextButton(
                              onPressed: () {
                                Get.offAll(() => const LoginView());
                              },

                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                              ),

                              child: Text(
                                settings.getLocalizedText('Skip', 'تخطي'),

                                style: const TextStyle(
                                  color: kDarkText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            // ==================================
                            // NEXT
                            // ==================================
                            ElevatedButton(
                              onPressed: () {
                                if (_index == pages.length - 1) {
                                  Get.offAll(() => const LoginView());
                                } else {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 450),
                                    curve: Curves.easeOutCubic,
                                  );
                                }
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: kCoral,

                                foregroundColor: Colors.white,

                                elevation: 4,

                                shadowColor: kCoral.withOpacity(0.35),

                                padding: const EdgeInsets.symmetric(
                                  horizontal: 27,
                                  vertical: 14,
                                ),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17),
                                ),
                              ),

                              child: Row(
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  Text(
                                    _index == pages.length - 1
                                        ? settings.getLocalizedText(
                                            'Get Started',
                                            'ابدأ الآن',
                                          )
                                        : settings.getLocalizedText(
                                            'Next',
                                            'التالي',
                                          ),

                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Icon(
                                    isArabic
                                        ? Icons.arrow_back_rounded
                                        : Icons.arrow_forward_rounded,

                                    size: 19,
                                  ),
                                ],
                              ),
                            ),
                          ],
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
    );
  }

  // ============================================================
  // INDICATOR
  // ============================================================

  Widget _indicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: List.generate(count, (i) {
        final active = _index == i;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),

          curve: Curves.easeOut,

          margin: const EdgeInsets.symmetric(horizontal: 4),

          width: active ? 30 : 8,

          height: 8,

          decoration: BoxDecoration(
            color: active ? kCoral : Colors.white.withOpacity(0.75),

            borderRadius: BorderRadius.circular(20),

            boxShadow: active
                ? [BoxShadow(color: kCoral.withOpacity(0.3), blurRadius: 6)]
                : null,
          ),
        );
      }),
    );
  }
}

// ============================================================
// ANIMATED PAGE
// ============================================================

class _AnimatedOnboardPage extends StatelessWidget {
  final OnboardData data;
  final int index;
  final int currentIndex;

  const _AnimatedOnboardPage({
    required this.data,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final active = index == currentIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          // ======================================================
          // IMAGE
          // ======================================================
          AnimatedScale(
            scale: active ? 1.0 : 0.86,

            duration: const Duration(milliseconds: 500),

            curve: Curves.easeOutBack,

            child: AnimatedOpacity(
              opacity: active ? 1 : 0,

              duration: const Duration(milliseconds: 400),

              child: Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.42),

                  borderRadius: BorderRadius.circular(30),

                  border: Border.all(
                    color: Colors.white.withOpacity(0.55),

                    width: 1.2,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: kDarkText.withOpacity(0.10),

                      blurRadius: 25,

                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(23),

                  child: Image.network(
                    data.image,

                    height: 245,

                    width: double.infinity,

                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 245,

                        color: kLimeCream,

                        child: const Icon(
                          Icons.image_not_supported_outlined,

                          size: 60,

                          color: kCoral,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 34),

          // ======================================================
          // TITLE
          // ======================================================
          AnimatedSlide(
            offset: active ? Offset.zero : const Offset(0, 0.20),

            duration: const Duration(milliseconds: 500),

            curve: Curves.easeOut,

            child: AnimatedOpacity(
              opacity: active ? 1 : 0,

              duration: const Duration(milliseconds: 500),

              child: Text(
                data.title,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 28,

                  fontWeight: FontWeight.w900,

                  color: kDarkText,

                  height: 1.15,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // ======================================================
          // DESCRIPTION
          // ======================================================
          AnimatedSlide(
            offset: active ? Offset.zero : const Offset(0, 0.30),

            duration: const Duration(milliseconds: 700),

            curve: Curves.easeOut,

            child: AnimatedOpacity(
              opacity: active ? 1 : 0,

              duration: const Duration(milliseconds: 700),

              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),

                child: Text(
                  data.description,

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontSize: 15,

                    height: 1.6,

                    color: kSecondaryText,

                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
