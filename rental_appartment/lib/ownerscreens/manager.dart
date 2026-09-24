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
// MANAGE PAGE
// ============================================================

class ManagePage extends StatelessWidget {
  const ManagePage({super.key});

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
                    settingsProvider.getLocalizedText('Manage', 'الإدارة'),
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
                // =================================================
                // HERO CARD
                // =================================================
                buildHeroCard(settingsProvider),

                const SizedBox(height: 26),

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
                        Icons.dashboard_customize_rounded,
                        color: kDarkText,
                        size: 21,
                      ),
                    ),

                    const SizedBox(width: 11),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            settingsProvider.getLocalizedText(
                              'Management Tools',
                              'أدوات الإدارة',
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
                              'Manage your properties easily',
                              'أدر عقاراتك بسهولة',
                            ),
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: kSecondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // =================================================
                // MANAGEMENT ITEMS
                // =================================================
                managementTile(
                  icon: Icons.add_business_rounded,
                  title: settingsProvider.getLocalizedText(
                    'Add New Item',
                    'إضافة عنصر جديد',
                  ),
                  subtitle: settingsProvider.getLocalizedText(
                    'Create a new property',
                    'إضافة عقار جديد',
                  ),
                  color: kCoral,
                  onTap: () {},
                ),

                managementTile(
                  icon: Icons.edit_rounded,
                  title: settingsProvider.getLocalizedText(
                    'Edit Existing Item',
                    'تعديل العقارات',
                  ),
                  subtitle: settingsProvider.getLocalizedText(
                    'Update your property details',
                    'تعديل معلومات العقارات',
                  ),
                  color: kPeach,
                  onTap: () {},
                ),

                managementTile(
                  icon: Icons.delete_outline_rounded,
                  title: settingsProvider.getLocalizedText(
                    'Remove Item',
                    'إزالة عقار',
                  ),
                  subtitle: settingsProvider.getLocalizedText(
                    'Remove a property from your listings',
                    'حذف عقار من قوائمك',
                  ),
                  color: kLimeCream,
                  isDanger: true,
                  onTap: () {},
                ),

                managementTile(
                  icon: Icons.tune_rounded,
                  title: settingsProvider.getLocalizedText(
                    'Management Settings',
                    'إعدادات الإدارة',
                  ),
                  subtitle: settingsProvider.getLocalizedText(
                    'Configure your management options',
                    'تخصيص خيارات الإدارة',
                  ),
                  color: kMint,
                  onTap: () {},
                ),

                const SizedBox(height: 12),

                // =================================================
                // INFO CARD
                // =================================================
                buildInfoCard(settingsProvider),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // HERO CARD
  // ============================================================

  Widget buildHeroCard(SettingsProvider settingsProvider) {
    return Container(
      height: 155,
      width: double.infinity,
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
                  'PROPERTY CONTROL',
                  'إدارة العقارات',
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
                  'Everything you need,\nin one place.',
                  'كل ما تحتاجه،\nفي مكان واحد.',
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
            right: -10,
            bottom: -20,
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
                Icons.settings_suggest_rounded,
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
  // MANAGEMENT TILE
  // ============================================================

  Widget managementTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: color.withOpacity(0.22), width: 1.2),

        boxShadow: [
          BoxShadow(
            color: kDarkText.withOpacity(0.045),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),

            child: Row(
              children: [
                // ==============================================
                // ICON
                // ==============================================
                Container(
                  width: 52,
                  height: 52,

                  decoration: BoxDecoration(
                    color: color.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(17),
                  ),

                  child: Icon(icon, size: 25, color: kDarkText),
                ),

                const SizedBox(width: 14),

                // ==============================================
                // TEXT
                // ==============================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: isDanger ? kDarkText : kDarkText,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 10.5,
                          color: kSecondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ==============================================
                // ARROW
                // ==============================================
                Container(
                  width: 34,
                  height: 34,

                  decoration: BoxDecoration(
                    color: kBgColor,
                    borderRadius: BorderRadius.circular(11),
                  ),

                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: kSecondaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget buildInfoCard(SettingsProvider settingsProvider) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: kLimeCream.withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kLimeCream),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: const BoxDecoration(
              color: kMint,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: kDarkText,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              settingsProvider.getLocalizedText(
                'Keep your property information up to date for a better management experience.',
                'حافظ على تحديث معلومات عقاراتك للحصول على تجربة إدارة أفضل.',
              ),
              style: const TextStyle(
                fontSize: 10.5,
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: kDarkText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
