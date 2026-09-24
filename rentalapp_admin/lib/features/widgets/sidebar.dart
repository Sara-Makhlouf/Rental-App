import 'package:flutter/material.dart';
import 'package:get/get.dart';

const kCoral = Color(0xFFFF9D9D);
const kPeach = Color(0xFFFFC5AA);
const kLimeCream = Color(0xFFEEF8CD);
const kMint = Color(0xFFBBF1D2);

const kDarkText = Color(0xFF343434);
const kGreyText = Color(0xFF777777);

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _sectionTitle("MAIN"),

                _item(0, Icons.dashboard_rounded, "Dashboard"),

                const SizedBox(height: 8),

                _sectionTitle("MANAGEMENT"),

                _item(1, Icons.people_alt_rounded, "Users Management"),

                _item(2, Icons.home_work_rounded, "Owners Management"),

                _item(3, Icons.verified_user_rounded, "Owner Verification"),

                _item(4, Icons.apartment_rounded, "Properties"),

                _item(5, Icons.approval_rounded, "Property Approval"),

                _item(6, Icons.calendar_month_rounded, "Bookings"),

                _item(7, Icons.category_rounded, "Categories"),

                _item(8, Icons.star_rounded, "Reviews"),

                _item(9, Icons.notifications_rounded, "Notifications"),

                const SizedBox(height: 8),

                _sectionTitle("SUPPORT"),

                _item(10, Icons.warning_amber_rounded, "Disputes"),

                _item(11, Icons.report_problem_rounded, "Reports"),

                const SizedBox(height: 8),

                _sectionTitle("ANALYTICS"),

                _item(12, Icons.attach_money_rounded, "Revenue Dashboard"),

                _item(13, Icons.analytics_rounded, "Business Intelligence"),

                _item(14, Icons.security_rounded, "Fraud Detection"),

                _item(15, Icons.psychology_rounded, "Reviews Intelligence"),

                _item(16, Icons.percent_rounded, "Platform Commission"),

                const SizedBox(height: 8),

                _sectionTitle("BUSINESS"),

                _item(17, Icons.workspace_premium_rounded, "Subscriptions"),
              ],
            ),
          ),

          _buildLogout(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [kCoral, kPeach]),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.admin_panel_settings_rounded,
              color: kDarkText,
              size: 27,
            ),
          ),

          const SizedBox(width: 12),

          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rental Admin",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: kDarkText,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Control Panel",
                style: TextStyle(fontSize: 12, color: kGreyText),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: kGreyText,
        ),
      ),
    );
  }

  Widget _item(int index, IconData icon, String title) {
    final selected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onItemSelected(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? kCoral.withOpacity(0.35) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, size: 21, color: selected ? kDarkText : kGreyText),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    color: selected ? kDarkText : kGreyText,
                  ),
                ),
              ),

              if (selected)
                Container(
                  width: 5,
                  height: 22,
                  decoration: BoxDecoration(
                    color: kCoral,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogout() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Get.dialog(
            AlertDialog(
              title: const Text("Logout"),
              content: const Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kCoral,
                    foregroundColor: kDarkText,
                  ),
                  onPressed: () {
                    Get.back();
                    Get.offAllNamed('/login');
                  },
                  child: const Text("Logout"),
                ),
              ],
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: kCoral.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            children: [
              Icon(Icons.logout_rounded, color: Color(0xFFB54A4A)),
              SizedBox(width: 12),
              Text(
                "Logout",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB54A4A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
