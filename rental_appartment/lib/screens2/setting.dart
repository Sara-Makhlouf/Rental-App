import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rental_appartment/controllers/authcontroller.dart';
import 'package:rental_appartment/core/cubit/theme_cubit.dart';
import 'package:rental_appartment/provider/setting_provuider.dart';

// ====== لوحة الألوان الجديدة ======
const kCoral = Color(0xFFFF9D9D); // أساسي - أزرار وتمييزات
const kPeach = Color(0xFFFFC5AA); // ثانوي - تدرجات
const kLimeCream = Color(0xFFEEF8CD); // خلفيات فاتحة وخطوط التذكرة
const kMint = Color(0xFFBBF1D2); // شرائط الأسعار والتأكيدات

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void showLanguageDialog(BuildContext context, SettingsProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            provider.getLocalizedText('Select Language', 'اختر اللغة'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kCoral,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageTile(context, 'English', Icons.language, () {
                provider.setLocale('en');
                Navigator.pop(context);
              }),
              const SizedBox(height: 12),
              _buildLanguageTile(context, 'العربية', Icons.language, () {
                provider.setLocale('ar');
                Navigator.pop(context);
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: kLimeCream.withOpacity(0.5),
          border: Border.all(color: kMint.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: kCoral, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleLogout(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Confirm Logout',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kCoral,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.rawSnackbar(
                  message: 'You are logging out...',
                  backgroundColor: kCoral,
                  showProgressIndicator: true,
                );
                authController.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kCoral,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        final isArabic = settingsProvider.locale.languageCode == 'ar';

        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kCoral,
              elevation: 0,
              title: Text(
                settingsProvider.getLocalizedText('Settings', 'الإعدادات'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kCoral.withOpacity(0.05),
                    kLimeCream.withOpacity(0.1),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: ListView(
                  children: [
                    // ===== القسم الأول: الإعدادات العامة =====
                    _buildSectionTitle(
                      settingsProvider.getLocalizedText('General', 'عام'),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsCard(
                      children: [
                        _buildSettingsTile(
                          icon: Icons.language,
                          title: settingsProvider.getLocalizedText(
                            'Language',
                            'اللغة',
                          ),
                          subtitle: isArabic ? 'العربية' : 'English',
                          onTap: () =>
                              showLanguageDialog(context, settingsProvider),
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.notifications,
                          title: settingsProvider.getLocalizedText(
                            'Notifications',
                            'الإشعارات',
                          ),
                          subtitle: settingsProvider.getLocalizedText(
                            'Manage alerts',
                            'إدارة التنبيهات',
                          ),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.dark_mode,
                          title: settingsProvider.getLocalizedText(
                            'Dark Mode',
                            'الوضع الداكن',
                          ),
                          trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                            builder: (context, themeMode) {
                              return Switch(
                                value: themeMode == ThemeMode.dark,
                                onChanged: (_) {
                                  context.read<ThemeCubit>().toggle();
                                },
                                activeColor: kCoral,
                                inactiveThumbColor: Colors.grey,
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ===== القسم الثاني: خيارات إضافية =====
                    _buildSectionTitle(
                      settingsProvider.getLocalizedText(
                        'More Options',
                        'خيارات إضافية',
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsCard(
                      children: [
                        _buildSettingsTile(
                          icon: Icons.payment,
                          title: settingsProvider.getLocalizedText(
                            'Payment & Billing',
                            'الدفع والفواتير',
                          ),
                          subtitle: settingsProvider.getLocalizedText(
                            'Manage payment methods',
                            'إدارة طرق الدفع',
                          ),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.share,
                          title: settingsProvider.getLocalizedText(
                            'Share App',
                            'مشاركة التطبيق',
                          ),
                          subtitle: settingsProvider.getLocalizedText(
                            'Share with friends',
                            'شارك مع الأصدقاء',
                          ),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.feedback,
                          title: settingsProvider.getLocalizedText(
                            'Feedback',
                            'الملاحظات',
                          ),
                          subtitle: settingsProvider.getLocalizedText(
                            'Send us your feedback',
                            'أرسل لنا ملاحظاتك',
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ===== القسم الثالث: الحساب والأمان =====
                    _buildSectionTitle(
                      settingsProvider.getLocalizedText(
                        'Account & Security',
                        'الحساب والأمان',
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsCard(
                      children: [
                        _buildSettingsTile(
                          icon: Icons.security,
                          title: settingsProvider.getLocalizedText(
                            'Privacy Settings',
                            'إعدادات الخصوصية',
                          ),
                          subtitle: settingsProvider.getLocalizedText(
                            'Control your data',
                            'تحكم ببيانات حسابك',
                          ),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.lock,
                          title: settingsProvider.getLocalizedText(
                            'Change Password',
                            'تغيير كلمة المرور',
                          ),
                          subtitle: settingsProvider.getLocalizedText(
                            'Update your password',
                            'حدّث كلمة مرورك',
                          ),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.verified_user,
                          title: settingsProvider.getLocalizedText(
                            'Two-Factor Authentication',
                            'المصادقة الثنائية',
                          ),
                          subtitle: settingsProvider.getLocalizedText(
                            'Add extra security',
                            'أضف حماية إضافية',
                          ),
                          trailing: const Switch(
                            value: false,
                            onChanged: null,
                            activeColor: kCoral,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ===== القسم الرابع: حول التطبيق =====
                    _buildSectionTitle(
                      settingsProvider.getLocalizedText('About', 'حول التطبيق'),
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsCard(
                      children: [
                        _buildSettingsTile(
                          icon: Icons.info,
                          title: settingsProvider.getLocalizedText(
                            'About App',
                            'عن التطبيق',
                          ),
                          subtitle: 'Version 1.0.0',
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.description,
                          title: settingsProvider.getLocalizedText(
                            'Terms & Conditions',
                            'الشروط والأحكام',
                          ),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildSettingsTile(
                          icon: Icons.privacy_tip,
                          title: settingsProvider.getLocalizedText(
                            'Privacy Policy',
                            'سياسة الخصوصية',
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ===== زر تسجيل الخروج =====
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(colors: [kCoral, kPeach]),
                        boxShadow: [
                          BoxShadow(
                            color: kCoral.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => handleLogout(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  settingsProvider.getLocalizedText(
                                    'Logout',
                                    'تسجيل الخروج',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: kCoral,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: kLimeCream,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: kCoral, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w400,
              ),
            )
          : null,
      trailing:
          trailing ??
          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFFCBD5E1),
          ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey.withOpacity(0.1),
      indent: 20,
      endIndent: 20,
    );
  }
}
