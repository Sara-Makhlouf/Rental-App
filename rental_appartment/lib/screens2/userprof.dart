import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_appartment/controllers/profilecontroller.dart';
import 'package:rental_appartment/provider/setting_provuider.dart';

// ====== لوحة الألوان الجديدة ======
const kCoral = Color(0xFFFF9D9D); // أساسي - أزرار وتمييزات
const kPeach = Color(0xFFFFC5AA); // ثانوي - تدرجات
const kLimeCream = Color(0xFFEEF8CD); // خلفيات فاتحة وخطوط التذكرة
const kMint = Color(0xFFBBF1D2); // شرائط الأسعار والتأكيدات

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _showImagePicker(
    BuildContext context,
    UserController controller,
  ) async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kLimeCream,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt, color: kCoral),
                ),
                title: const Text(
                  'Camera',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  final photo = await picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (photo != null) {
                    controller.userData['images_urls'] = photo.path;
                    controller.userData.refresh();
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: kMint.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.photo_library, color: kCoral),
                ),
                title: const Text(
                  'Gallery',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  final photo = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (photo != null) {
                    controller.userData['images_urls'] = photo.path;
                    controller.userData.refresh();
                  }
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final userController = Get.put(UserController());
    final isArabic = settings.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          settings.getLocalizedText('My Account', 'حسابي'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kCoral,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kCoral),
            ),
          );
        }

        final name = userController.userData['first_name'] ?? 'Guest User';
        final phone = userController.userData['phone'] ?? '0000000000';
        final email = userController.userData['email'] ?? 'user@example.com';
        final profileImage = userController.userData['images_urls'];

        return SingleChildScrollView(
          child: Column(
            children: [
              // ===== رأس الملف الشخصي =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kCoral, kPeach],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kCoral.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.white,
                          backgroundImage: profileImage != null
                              ? (profileImage.contains('http')
                                    ? NetworkImage(profileImage)
                                    : FileImage(File(profileImage))
                                          as ImageProvider)
                              : null,
                          child: profileImage == null
                              ? Icon(
                                  Icons.person_rounded,
                                  size: 80,
                                  color: Colors.grey[300],
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () =>
                                _showImagePicker(context, userController),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 22,
                                color: kCoral,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          phone,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.email,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // ===== قسم إدارة الحساب =====
                    _sectionHeader(
                      settings.getLocalizedText(
                        'Manage Account',
                        'إدارة الحساب',
                      ),
                    ),
                    const SizedBox(height: 12),
                    _profileMenuTile(
                      Icons.edit_document,
                      settings.getLocalizedText(
                        'Edit Personal Info',
                        'تعديل البيانات الشخصية',
                      ),
                      'Update your profile details',
                      () {},
                    ),
                    const SizedBox(height: 10),
                    _profileMenuTile(
                      Icons.history_rounded,
                      settings.getLocalizedText('My Bookings', 'سجل حجوزاتي'),
                      'View your booking history',
                      () {},
                    ),
                    const SizedBox(height: 10),
                    _profileMenuTile(
                      Icons.favorite_border_rounded,
                      settings.getLocalizedText(
                        'Saved Apartments',
                        'الشقق المحفوظة',
                      ),
                      'View your favorite apartments',
                      () {},
                    ),
                    const SizedBox(height: 10),
                    _profileMenuTile(
                      Icons.receipt_long_rounded,
                      settings.getLocalizedText('My Reviews', 'تقييماتي'),
                      'Manage your reviews and ratings',
                      () {},
                    ),

                    const SizedBox(height: 30),

                    // ===== قسم الدعم الفني =====
                    _sectionHeader(
                      settings.getLocalizedText('Support', 'الدعم الفني'),
                    ),
                    const SizedBox(height: 12),
                    _profileMenuTile(
                      Icons.help_outline_rounded,
                      settings.getLocalizedText('Help Center', 'مركز المساعدة'),
                      'Get help and support',
                      () {},
                    ),
                    const SizedBox(height: 10),
                    _profileMenuTile(
                      Icons.mail_outline_rounded,
                      settings.getLocalizedText('Contact Us', 'اتصل بنا'),
                      'Send us a message',
                      () {},
                    ),
                    const SizedBox(height: 10),
                    _profileMenuTile(
                      Icons.bug_report_outlined,
                      settings.getLocalizedText(
                        'Report Issue',
                        'الإبلاغ عن مشكلة',
                      ),
                      'Report a bug or issue',
                      () {},
                    ),

                    const SizedBox(height: 30),

                    // ===== قسم التفضيلات =====
                    _sectionHeader(
                      settings.getLocalizedText('Preferences', 'التفضيلات'),
                    ),
                    const SizedBox(height: 12),
                    _profileMenuTile(
                      Icons.notifications_active_outlined,
                      settings.getLocalizedText(
                        'Notification Settings',
                        'إعدادات الإشعارات',
                      ),
                      'Manage your notifications',
                      () {},
                    ),
                    const SizedBox(height: 10),
                    _profileMenuTile(
                      Icons.privacy_tip_outlined,
                      settings.getLocalizedText(
                        'Privacy Settings',
                        'إعدادات الخصوصية',
                      ),
                      'Control your privacy',
                      () {},
                    ),

                    const SizedBox(height: 30),

                    // ===== قسم حول التطبيق =====
                    _sectionHeader(
                      settings.getLocalizedText('About', 'حول التطبيق'),
                    ),
                    const SizedBox(height: 12),
                    _profileMenuTile(
                      Icons.info_outline_rounded,
                      settings.getLocalizedText('App Version', 'إصدار التطبيق'),
                      'Version 1.0.0',
                      () {},
                      isInfo: true,
                    ),
                    const SizedBox(height: 10),
                    _profileMenuTile(
                      Icons.description_outlined,
                      settings.getLocalizedText(
                        'Terms & Conditions',
                        'الشروط والأحكام',
                      ),
                      'Read our terms',
                      () {},
                    ),
                    const SizedBox(height: 10),
                    _profileMenuTile(
                      Icons.shield_outlined,
                      settings.getLocalizedText(
                        'Privacy Policy',
                        'سياسة الخصوصية',
                      ),
                      'Read our privacy policy',
                      () {},
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kCoral,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _profileMenuTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    bool isExit = false,
    bool isInfo = false,
  }) {
    final iconColor = isExit ? Colors.red : kCoral;
    final backgroundColor = isExit
        ? Colors.red.withOpacity(0.08)
        : isInfo
        ? kLimeCream.withOpacity(0.5)
        : Colors.white;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor,
        border: Border.all(
          color: isExit ? Colors.red.withOpacity(0.2) : kMint.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isExit ? Colors.red.withOpacity(0.1) : kLimeCream,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isExit ? Colors.red : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isInfo)
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: isExit ? Colors.red.withOpacity(0.5) : Colors.grey,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
