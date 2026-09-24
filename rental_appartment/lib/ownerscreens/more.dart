import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:rental_appartment/controllers/authcontroller.dart';
import 'package:rental_appartment/core/cubit/theme_cubit.dart';
import 'package:rental_appartment/ownerscreens/ownerprofile.dart';
import 'package:rental_appartment/provider/setting_provuider.dart';
import 'package:rental_appartment/views/login_view.dart';

// ============================================================
// 🎨 COLORS
// ============================================================

const kCoral = Color(0xFFFF9D9D);
const kPeach = Color(0xFFFFC5AA);
const kLimeCream = Color(0xFFEEF8CD);
const kMint = Color(0xFFBBF1D2);

const kDarkText = Color(0xFF3B3634);
const kSecondaryText = Color(0xFF8B8378);
const kBgColor = Color(0xFFFFFCF7);

// ============================================================
// MORE PAGE
// ============================================================

class MorePage extends StatelessWidget {
  MorePage({super.key});

  final AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, _) {
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
                    settingsProvider.getLocalizedText('More', 'المزيد'),
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: kDarkText,
                    ),
                  ),
                ],
              ),
            ),

            // ==================================================
            // BODY
            // ==================================================
            body: ListView(
              physics: const BouncingScrollPhysics(),

              padding: const EdgeInsets.fromLTRB(20, 4, 20, 35),

              children: [
                buildHeader(settingsProvider),

                const SizedBox(height: 28),

                sectionTitle(
                  settingsProvider.getLocalizedText('Account', 'الحساب'),
                  Icons.person_outline_rounded,
                ),

                const SizedBox(height: 10),

                settingTile(
                  icon: Icons.person_outline_rounded,
                  title: settingsProvider.getLocalizedText(
                    'Profile',
                    'الملف الشخصي',
                  ),
                  subtitle: settingsProvider.getLocalizedText(
                    'Manage your personal information',
                    'إدارة معلوماتك الشخصية',
                  ),
                  color: kCoral,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OwnerProfilePage()),
                    );
                  },
                ),

                settingTile(
                  icon: Icons.notifications_none_rounded,
                  title: settingsProvider.getLocalizedText(
                    'Notifications',
                    'الإشعارات',
                  ),
                  subtitle: settingsProvider.getLocalizedText(
                    'Manage your notifications',
                    'إدارة الإشعارات',
                  ),
                  color: kPeach,
                ),

                settingTile(
                  icon: Icons.lock_outline_rounded,
                  title: settingsProvider.getLocalizedText(
                    'Security',
                    'الخصوصية والأمان',
                  ),
                  subtitle: settingsProvider.getLocalizedText(
                    'Password and account security',
                    'كلمة المرور وأمان الحساب',
                  ),
                  color: kMint,
                ),

                settingTile(
                  icon: Icons.help_outline_rounded,
                  title: settingsProvider.getLocalizedText(
                    'Help & Support',
                    'المساعدة والدعم',
                  ),
                  subtitle: settingsProvider.getLocalizedText(
                    'Get help when you need it',
                    'احصل على المساعدة عند الحاجة',
                  ),
                  color: kLimeCream,
                ),

                const SizedBox(height: 26),

                sectionTitle(
                  settingsProvider.getLocalizedText('Preferences', 'التفضيلات'),
                  Icons.tune_rounded,
                ),

                const SizedBox(height: 10),

                themeTile(),

                languageTile(context, settingsProvider),

                const SizedBox(height: 26),

                logoutTile(context, settingsProvider),

                const SizedBox(height: 15),

                Center(
                  child: Text(
                    settingsProvider.getLocalizedText(
                      'Rental Apartment • Owner',
                      'Rental Apartment • المالك',
                    ),
                    style: const TextStyle(
                      fontSize: 10,
                      color: kSecondaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget buildHeader(SettingsProvider settingsProvider) {
    return Container(
      height: 160,
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
          Row(
            children: [
              Container(
                width: 62,
                height: 62,

                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.person_rounded,
                  size: 34,
                  color: kCoral,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      settingsProvider.getLocalizedText(
                        'OWNER ACCOUNT',
                        'حساب المالك',
                      ),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.8,
                        color: kDarkText,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      settingsProvider.getLocalizedText(
                        'Manage your account',
                        'إدارة حسابك',
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: kDarkText,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      settingsProvider.getLocalizedText(
                        'Everything is in your hands.',
                        'كل شيء بين يديك.',
                      ),
                      style: TextStyle(
                        fontSize: 10.5,
                        color: kDarkText.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            right: -25,
            bottom: -40,
            child: Container(
              width: 110,
              height: 110,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.65),
                  width: 2,
                ),
              ),

              child: const Icon(
                Icons.settings_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,

          decoration: BoxDecoration(
            color: kLimeCream,
            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(icon, size: 19, color: kDarkText),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: kDarkText,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SETTING TILE
  // ============================================================

  Widget settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: color.withOpacity(0.25), width: 1.2),

        boxShadow: [
          BoxShadow(
            color: kDarkText.withOpacity(0.04),
            blurRadius: 13,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),

          child: Padding(
            padding: const EdgeInsets.all(13),

            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,

                  decoration: BoxDecoration(
                    color: color.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Icon(icon, color: kDarkText, size: 23),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w900,
                          color: kDarkText,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: kSecondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: kSecondaryText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // THEME TILE
  // ============================================================

  Widget themeTile() {
    return Consumer<SettingsProvider>(
      builder: (context, value, _) {
        final isArabic = value.locale.languageCode == 'ar';

        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,

          child: Container(
            margin: const EdgeInsets.only(bottom: 11),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kMint.withOpacity(0.35)),
              boxShadow: [
                BoxShadow(
                  color: kDarkText.withOpacity(0.04),
                  blurRadius: 13,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 5,
              ),

              leading: Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: kMint.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),

                child: const Icon(Icons.dark_mode_outlined, color: kDarkText),
              ),

              title: Text(
                value.getLocalizedText('Theme', 'المظهر'),
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  color: kDarkText,
                ),
              ),

              subtitle: Text(
                value.getLocalizedText('Light / Dark', 'فاتح / داكن'),
                style: const TextStyle(fontSize: 10, color: kSecondaryText),
              ),

              trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return Switch(
                    activeColor: kCoral,
                    activeTrackColor: kPeach,
                    inactiveThumbColor: kSecondaryText,
                    value: themeMode == ThemeMode.dark,
                    onChanged: (_) {
                      context.read<ThemeCubit>().toggle();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // LANGUAGE TILE
  // ============================================================

  Widget languageTile(BuildContext context, SettingsProvider settingsProvider) {
    final isArabic = settingsProvider.locale.languageCode == 'ar';

    return Container(
      margin: const EdgeInsets.only(bottom: 11),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kPeach.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: kDarkText.withOpacity(0.04),
            blurRadius: 13,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),

        leading: Container(
          width: 48,
          height: 48,

          decoration: BoxDecoration(
            color: kPeach.withOpacity(0.45),
            borderRadius: BorderRadius.circular(15),
          ),

          child: const Icon(Icons.language_rounded, color: kDarkText),
        ),

        title: Text(
          settingsProvider.getLocalizedText('Language', 'اللغة'),
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w900,
            color: kDarkText,
          ),
        ),

        subtitle: Text(
          isArabic ? 'العربية' : 'English',
          style: const TextStyle(fontSize: 10, color: kSecondaryText),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: kSecondaryText,
        ),

        onTap: () => showLanguageDialog(context, settingsProvider),
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Widget logoutTile(BuildContext context, SettingsProvider settingsProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: Colors.redAccent.withOpacity(0.18)),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),

        leading: Container(
          width: 48,
          height: 48,

          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.10),
            borderRadius: BorderRadius.circular(15),
          ),

          child: const Icon(Icons.logout_rounded, color: Colors.redAccent),
        ),

        title: Text(
          settingsProvider.getLocalizedText('Logout', 'تسجيل خروج'),
          style: const TextStyle(
            color: Colors.redAccent,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),

        subtitle: Text(
          settingsProvider.getLocalizedText(
            'Sign out from your account',
            'تسجيل الخروج من حسابك',
          ),
          style: const TextStyle(color: kSecondaryText, fontSize: 10),
        ),

        onTap: () async {
          await authController.logout();

          Provider.of<SettingsProvider>(context, listen: false).clearUserData();

          Get.offAll(() => LoginView());
        },
      ),
    );
  }
}

// ============================================================
// LANGUAGE DIALOG
// ============================================================

void showLanguageDialog(BuildContext context, SettingsProvider provider) {
  showDialog(
    context: context,

    builder: (context) {
      return AlertDialog(
        backgroundColor: kBgColor,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),

        title: Text(
          provider.getLocalizedText('Select Language', 'اختر اللغة'),
          style: const TextStyle(fontWeight: FontWeight.w900, color: kDarkText),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            languageOption(
              context,
              title: 'English',
              icon: Icons.language_rounded,
              color: kPeach,
              onTap: () {
                provider.setLocale('en');
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 10),

            languageOption(
              context,
              title: 'العربية',
              icon: Icons.language_rounded,
              color: kMint,
              onTap: () {
                provider.setLocale('ar');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

// ============================================================
// LANGUAGE OPTION
// ============================================================

Widget languageOption(
  BuildContext context, {
  required String title,
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(17),

    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: color.withOpacity(0.45)),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: color.withOpacity(0.4),
              borderRadius: BorderRadius.circular(13),
            ),

            child: Icon(icon, color: kDarkText, size: 20),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: kDarkText,
              ),
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 13,
            color: kSecondaryText,
          ),
        ],
      ),
    ),
  );
}
