import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:rental_appartment/controllers/profilecontroller.dart';
import 'package:rental_appartment/provider/setting_provuider.dart';

// ============================================================
// OWNER PROFILE - COLOR PALETTE
// ============================================================

const kCoral = Color(0xFFFF9D9D);
const kPeach = Color(0xFFFFC5AA);
const kLimeCream = Color(0xFFEEF8CD);
const kMint = Color(0xFFBBF1D2);

const kDarkText = Color(0xFF3B3634);
const kSecondaryText = Color(0xFF8B8378);
const kBgColor = Color(0xFFFFFCF7);

class OwnerProfilePage extends StatelessWidget {
  const OwnerProfilePage({super.key});

  // ============================================================
  // IMAGE PICKER
  // ============================================================

  Future<void> _showImagePicker(
    BuildContext context,
    UserController controller,
  ) async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      backgroundColor: kBgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: kLimeCream,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Change Profile Picture",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: kDarkText,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Choose an image source",
                  style: TextStyle(fontSize: 13, color: kSecondaryText),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: _imageSourceCard(
                        icon: Icons.camera_alt_rounded,
                        title: "Camera",
                        color: kCoral,
                        onTap: () async {
                          final photo = await picker.pickImage(
                            source: ImageSource.camera,
                          );

                          if (photo != null) {
                            controller.userData['image'] = photo.path;
                            controller.userData.refresh();
                          }

                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _imageSourceCard(
                        icon: Icons.photo_library_rounded,
                        title: "Gallery",
                        color: kPeach,
                        onTap: () async {
                          final photo = await picker.pickImage(
                            source: ImageSource.gallery,
                          );

                          if (photo != null) {
                            controller.userData['image'] = photo.path;
                            controller.userData.refresh();
                          }

                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    final userController = Get.put(UserController());

    final isArabic = settings.locale.languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: kBgColor,

        body: Obx(() {
          if (userController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: kCoral),
            );
          }

          final name = userController.userData['first_name'] ?? 'Owner';

          final phone = userController.userData['phone'] ?? '---';

          final image = userController.userData['images_urls'];

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ==================================================
              // HEADER
              // ==================================================
              SliverAppBar(
                expandedHeight: 310,
                pinned: true,
                elevation: 0,
                backgroundColor: kCoral,
                foregroundColor: kDarkText,

                title: Text(
                  settings.getLocalizedText('Owner Profile', 'حساب المالك'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: kDarkText,
                  ),
                ),

                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [kCoral, kPeach],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // PROFILE IMAGE
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: kDarkText.withOpacity(0.12),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 52,
                                  backgroundColor: kLimeCream,
                                  backgroundImage:
                                      image != null &&
                                          image.toString().isNotEmpty
                                      ? (image.toString().contains('http')
                                            ? NetworkImage(image.toString())
                                            : FileImage(File(image.toString()))
                                                  as ImageProvider)
                                      : null,
                                  child:
                                      image == null || image.toString().isEmpty
                                      ? const Icon(
                                          Icons.business_rounded,
                                          size: 52,
                                          color: kCoral,
                                        )
                                      : null,
                                ),
                              ),

                              Positioned(
                                right: -2,
                                bottom: 2,
                                child: GestureDetector(
                                  onTap: () =>
                                      _showImagePicker(context, userController),
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: kCoral,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.edit_rounded,
                                      size: 18,
                                      color: kCoral,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // NAME
                          Text(
                            name.toString(),
                            style: const TextStyle(
                              fontSize: 22,
                              color: kDarkText,
                              fontWeight: FontWeight.w900,
                            ),
                          ),

                          const SizedBox(height: 7),

                          // ROLE
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 15,
                                  color: kDarkText,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  settings.getLocalizedText(
                                    'Property Owner',
                                    'مالك عقارات',
                                  ),
                                  style: const TextStyle(
                                    color: kDarkText,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ==================================================
              // CONTENT
              // ==================================================
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ==================================================
                      // QUICK STATS
                      // ==================================================
                      Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              icon: Icons.home_work_rounded,
                              value: "0",
                              label: settings.getLocalizedText(
                                'Properties',
                                'العقارات',
                              ),
                              color: kCoral,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statCard(
                              icon: Icons.event_available_rounded,
                              value: "0",
                              label: settings.getLocalizedText(
                                'Bookings',
                                'الحجوزات',
                              ),
                              color: kPeach,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statCard(
                              icon: Icons.star_rounded,
                              value: "5.0",
                              label: settings.getLocalizedText(
                                'Rating',
                                'التقييم',
                              ),
                              color: kMint,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ==================================================
                      // CONTACT INFORMATION
                      // ==================================================
                      _sectionTitle(
                        settings.getLocalizedText(
                          'Contact Information',
                          'معلومات التواصل',
                        ),
                      ),

                      const SizedBox(height: 8),

                      _infoCard(
                        icon: Icons.phone_rounded,
                        title: settings.getLocalizedText(
                          'Phone Number',
                          'رقم الهاتف',
                        ),
                        value: phone.toString(),
                        color: kMint,
                      ),

                      const SizedBox(height: 24),

                      // ==================================================
                      // OWNER ACTIONS
                      // ==================================================
                      _sectionTitle(
                        settings.getLocalizedText(
                          'Owner Actions',
                          'خيارات المالك',
                        ),
                      ),

                      const SizedBox(height: 8),

                      _menuTile(
                        icon: Icons.home_work_outlined,
                        title: settings.getLocalizedText(
                          'My Apartments',
                          'شققـي',
                        ),
                        subtitle: settings.getLocalizedText(
                          'Manage your properties',
                          'إدارة العقارات الخاصة بك',
                        ),
                        color: kCoral,
                        onTap: () {},
                      ),

                      _menuTile(
                        icon: Icons.add_business_rounded,
                        title: settings.getLocalizedText(
                          'Add Apartment',
                          'إضافة شقة',
                        ),
                        subtitle: settings.getLocalizedText(
                          'List a new property',
                          'إضافة عقار جديد',
                        ),
                        color: kPeach,
                        onTap: () {},
                      ),

                      _menuTile(
                        icon: Icons.bar_chart_rounded,
                        title: settings.getLocalizedText(
                          'Statistics',
                          'الإحصائيات',
                        ),
                        subtitle: settings.getLocalizedText(
                          'View your property performance',
                          'عرض أداء عقاراتك',
                        ),
                        color: kMint,
                        onTap: () {},
                      ),

                      _menuTile(
                        icon: Icons.edit_rounded,
                        title: settings.getLocalizedText(
                          'Edit Profile',
                          'تعديل الحساب',
                        ),
                        subtitle: settings.getLocalizedText(
                          'Update your personal information',
                          'تعديل معلوماتك الشخصية',
                        ),
                        color: kLimeCream,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.22)),
        boxShadow: [
          BoxShadow(
            color: kDarkText.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: kDarkText, size: 21),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: kDarkText,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: kSecondaryText,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w900,
        color: kDarkText,
      ),
    );
  }

  // ============================================================
  // INFO CARD
  // ============================================================

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: kDarkText.withOpacity(0.045),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.25),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: kDarkText, size: 22),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: kSecondaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: kDarkText,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: kLimeCream,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check_rounded, size: 17, color: kDarkText),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MENU TILE
  // ============================================================

  Widget _menuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.20)),
        boxShadow: [
          BoxShadow(
            color: kDarkText.withOpacity(0.04),
            blurRadius: 12,
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
                    color: color.withOpacity(0.22),
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
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: kDarkText,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: kSecondaryText,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: kLimeCream,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: kDarkText,
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
  // IMAGE SOURCE CARD
  // ============================================================

  Widget _imageSourceCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withOpacity(0.18),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: kDarkText, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: kDarkText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
