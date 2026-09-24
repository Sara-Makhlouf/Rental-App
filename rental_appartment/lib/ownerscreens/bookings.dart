import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_appartment/provider/setting_provuider.dart';

// ============================================================
// 🎨 APP COLORS
// ============================================================

const kCoral = Color(0xFFFF9D9D);
const kPeach = Color(0xFFFFC5AA);
const kLimeCream = Color(0xFFEEF8CD);
const kMint = Color(0xFFBBF1D2);

const kDarkText = Color(0xFF3B3634);
const kSecondaryText = Color(0xFF8B8378);
const kBgColor = Color(0xFFFFFCF7);

// ============================================================
// BOOKINGS PAGE
// ============================================================

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (BuildContext context, settingsProvider, Widget? child) {
        final isArabic = settingsProvider.locale.languageCode == 'ar';

        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,

          child: Scaffold(
            backgroundColor: kBgColor,

            // ==================================================
            // APP BAR
            // ==================================================
            appBar: AppBar(
              backgroundColor: kBgColor,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 76,

              leading: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),

                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: kDarkText.withOpacity(0.07),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: kDarkText,
                      size: 21,
                    ),
                  ),
                ),
              ),

              titleSpacing: 8,

              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    settingsProvider.getLocalizedText(
                      'OWNER SPACE',
                      'مساحة المالك',
                    ),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: kSecondaryText,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    settingsProvider.getLocalizedText('Bookings', 'الحجوزات'),
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: kDarkText,
                    ),
                  ),
                ],
              ),

              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    width: 42,
                    height: 42,

                    decoration: BoxDecoration(
                      color: kMint.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: kDarkText,
                      size: 21,
                    ),
                  ),
                ),
              ],
            ),

            // ==================================================
            // BODY
            // ==================================================
            body: ListView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(20, 5, 20, 30),

              children: [
                // =================================================
                // HEADER CARD
                // =================================================
                buildBookingHeader(settingsProvider),

                const SizedBox(height: 25),

                // =================================================
                // SECTION TITLE
                // =================================================
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,

                      decoration: BoxDecoration(
                        color: kCoral.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: const Icon(
                        Icons.event_available_rounded,
                        color: kDarkText,
                        size: 21,
                      ),
                    ),

                    const SizedBox(width: 11),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          settingsProvider.getLocalizedText(
                            'Recent Bookings',
                            'الحجوزات الأخيرة',
                          ),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: kDarkText,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          settingsProvider.getLocalizedText(
                            'Manage your reservations',
                            'إدارة حجوزاتك',
                          ),
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: kSecondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // =================================================
                // BOOKINGS
                // =================================================
                ...List.generate(
                  5,
                  (index) => bookingCard(context, settingsProvider, index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // HEADER CARD
  // ============================================================

  Widget buildBookingHeader(SettingsProvider settingsProvider) {
    return Container(
      height: 155,
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kCoral, kPeach],
        ),

        borderRadius: BorderRadius.circular(28),

        boxShadow: [
          BoxShadow(
            color: kCoral.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),

      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                settingsProvider.getLocalizedText(
                  'RESERVATION CENTER',
                  'مركز الحجوزات',
                ),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: kDarkText,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                settingsProvider.getLocalizedText(
                  'Your guests,\nyour reservations.',
                  'ضيوفك،\nحجوزاتك.',
                ),
                style: const TextStyle(
                  fontSize: 23,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                  color: kDarkText,
                ),
              ),
            ],
          ),

          Positioned(
            right: -8,
            bottom: -18,
            child: Container(
              width: 105,
              height: 105,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.75),
                  width: 2,
                ),
              ),

              child: const Icon(
                Icons.event_note_rounded,
                color: Colors.white,
                size: 42,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOOKING CARD
  // ============================================================

  Widget bookingCard(
    BuildContext context,
    SettingsProvider settingsProvider,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: kDarkText.withOpacity(0.055),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],

        border: Border.all(color: kLimeCream, width: 1.2),
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(22),

          onTap: () {
            // TODO:
            // افتح تفاصيل الحجز هنا
          },

          child: Padding(
            padding: const EdgeInsets.all(15),

            child: Column(
              children: [
                // ================================================
                // TOP ROW
                // ================================================
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 54,
                      height: 54,

                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [kCoral, kPeach],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),

                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),

                    const SizedBox(width: 13),

                    // Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            settingsProvider.getLocalizedText(
                              'Custom Name',
                              'اسم المستأجر',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: kDarkText,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Row(
                            children: [
                              const Icon(
                                Icons.home_outlined,
                                size: 13,
                                color: kSecondaryText,
                              ),

                              const SizedBox(width: 4),

                              Expanded(
                                child: Text(
                                  settingsProvider.getLocalizedText(
                                    'Apartment Reservation',
                                    'حجز شقة',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: kSecondaryText,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Status
                    buildStatusBadge(settingsProvider),
                  ],
                ),

                const SizedBox(height: 15),

                // ================================================
                // DASHED DIVIDER
                // ================================================
                Row(
                  children: [
                    Expanded(child: Container(height: 1, color: kLimeCream)),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.circle, size: 5, color: kPeach),
                    ),

                    Expanded(child: Container(height: 1, color: kLimeCream)),
                  ],
                ),

                const SizedBox(height: 14),

                // ================================================
                // BOOKING DETAILS
                // ================================================
                Row(
                  children: [
                    Expanded(
                      child: bookingInfo(
                        Icons.calendar_today_rounded,
                        settingsProvider.getLocalizedText(
                          'BOOKING DATE',
                          'تاريخ الحجز',
                        ),
                        settingsProvider.getLocalizedText(
                          'Jan 18, 2025',
                          '18/01/2025',
                        ),
                        kMint,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: bookingInfo(
                        Icons.access_time_rounded,
                        settingsProvider.getLocalizedText(
                          'CHECK-IN',
                          'تسجيل الدخول',
                        ),
                        '12:00 PM',
                        kLimeCream,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Container(
                      width: 36,
                      height: 36,

                      decoration: BoxDecoration(
                        color: kCoral.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: kCoral,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget buildStatusBadge(SettingsProvider settingsProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),

      decoration: BoxDecoration(
        color: kMint.withOpacity(0.65),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,

            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 5),

          Text(
            settingsProvider.getLocalizedText('Pending', 'قيد الانتظار'),
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              color: kDarkText,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOOKING INFO
  // ============================================================

  Widget bookingInfo(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),

      decoration: BoxDecoration(
        color: color.withOpacity(0.45),
        borderRadius: BorderRadius.circular(13),
      ),

      child: Row(
        children: [
          Icon(icon, size: 15, color: kDarkText),

          const SizedBox(width: 6),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 7.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4,
                    color: kSecondaryText,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: kDarkText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
