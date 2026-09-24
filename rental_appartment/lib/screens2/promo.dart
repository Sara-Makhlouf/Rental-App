import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_appartment/provider/setting_provuider.dart';

class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  late List<Map<String, dynamic>> promos;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isArabic = settingsProvider.locale.languageCode == 'ar';

    promos = [
      {
        "color": Colors.deepPurple,
        "icon": Icons.local_cafe,
        "title": settingsProvider.getLocalizedText(
          'Daily Coffee Tips',
          isArabic ? 'نصائح القهوة اليومية' : 'Daily Coffee Tips',
        ),
        "subtitle": settingsProvider.getLocalizedText(
          'Discover the best coffee blends',
          isArabic
              ? 'اكتشف أفضل أنواع القهوة!'
              : 'Discover the best coffee blends!',
        ),
      },
      {
        "color": Colors.teal,
        "icon": Icons.fitness_center,
        "title": settingsProvider.getLocalizedText(
          'Fitness Challenges',
          isArabic ? 'تحديات اللياقة البدنية' : 'Fitness Challenges',
        ),
        "subtitle": settingsProvider.getLocalizedText(
          'Stay active',
          isArabic
              ? 'ابق نشيطًا وصحيًا كل يوم'
              : 'Stay active and healthy every day',
        ),
      },
      {
        "color": Colors.orange,
        "icon": Icons.book,
        "title": settingsProvider.getLocalizedText(
          'Reading Recommendations',
          isArabic ? 'توصيات القراءة' : 'Reading Recommendations',
        ),
        "subtitle": settingsProvider.getLocalizedText(
          'Explore Top books',
          isArabic
              ? 'استكشف أفضل الكتب هذا الشهر'
              : 'Explore top books this month',
        ),
      },
      {
        "color": Colors.pink,
        "icon": Icons.travel_explore,
        "title": settingsProvider.getLocalizedText(
          'Travel Adventures',
          isArabic ? 'مغامرات السفر' : 'Travel Adventures',
        ),
        "subtitle": settingsProvider.getLocalizedText(
          'Find Dream Destination',
          isArabic
              ? 'اكتشف وجهتك الحلم القادمة'
              : 'Find your next dream destination',
        ),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isArabic = settingsProvider.locale.languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _controller,
              itemCount: promos.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final promo = promos[index];
                return Transform.scale(
                  scale: index == _currentPage ? 1 : 0.9,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: promo['color'],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white24,
                          child: Icon(
                            promo['icon'],
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                promo['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                promo['subtitle'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              promos.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.deepPurple
                      : Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
