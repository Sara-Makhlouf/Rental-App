import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/sidebar.dart';
import 'package:rentalapp_admin/screens/bookingmanagmentpage.dart';
import 'package:rentalapp_admin/screens/buissnisintpage.dart';
import 'package:rentalapp_admin/screens/categorymanagmentpage.dart';
import 'package:rentalapp_admin/screens/commisionmanamentpage.dart';
import 'package:rentalapp_admin/screens/disputesmanagmentpage.dart';
import 'package:rentalapp_admin/screens/frauddetectionpage.dart';
import 'package:rentalapp_admin/screens/notificationpage.dart';
import 'package:rentalapp_admin/screens/ownermanagmentpage.dart';
import 'package:rentalapp_admin/screens/ownerverfication.dart';
import 'package:rentalapp_admin/screens/propertiesmanamentpage.dart';
import 'package:rentalapp_admin/screens/propertyapprovelpage.dart';
import 'package:rentalapp_admin/screens/reportmanamgentpage.dart';
import 'package:rentalapp_admin/screens/revenudashboardpage.dart';
import 'package:rentalapp_admin/screens/reviewintpage.dart';
import 'package:rentalapp_admin/screens/reviewmanagmentpage.dart';
import 'package:rentalapp_admin/screens/subscription.dart';
import 'package:rentalapp_admin/screens/usermanagmentpage.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    DashboardHome(),
    UsersManagementPage(),
    OwnersManagementPage(),
    OwnerVerificationPage(),
    PropertiesManagementPage(),
    PropertyApprovalPage(),
    BookingsManagementPage(),
    CategoriesManagementPage(),
    ReviewsManagementPage(),
    NotificationsManagementPage(),
    DisputesManagementPage(),
    ReportsManagementPage(),
    RevenueDashboardPage(),
    BusinessIntelligencePage(),
    FraudDetectionPage(),
    ReviewsIntelligencePage(),
    CommissionManagementPage(),
    SubscriptionsManagementPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLimeCream,
      body: Row(
        children: [
          AdminSidebar(
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: pages[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLimeCream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),

              const SizedBox(height: 25),

              _stats(),

              const SizedBox(height: 25),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _revenueCard()),

                  const SizedBox(width: 20),

                  Expanded(child: _verificationCard()),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _fraudCard()),

                  const SizedBox(width: 20),

                  Expanded(child: _sentimentCard()),
                ],
              ),

              const SizedBox(height: 20),

              _forecastCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good morning, Admin 👋",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: kDarkText,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Here's what's happening on your platform.",
              style: TextStyle(color: kGreyText, fontSize: 14),
            ),
          ],
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 17, color: kGreyText),
              SizedBox(width: 8),
              Text(
                "August 2026",
                style: TextStyle(fontWeight: FontWeight.w600, color: kDarkText),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stats() {
    return GridView.count(
      crossAxisCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.55,
      children: [
        _stat("Total Users", "1,248", Icons.people_alt_rounded, kPeach),
        _stat("Total Owners", "183", Icons.home_work_rounded, kMint),
        _stat("Properties", "426", Icons.apartment_rounded, kCoral),
        _stat(
          "Bookings",
          "2,891",
          Icons.calendar_month_rounded,
          const Color(0xFFDCD4FF),
        ),
        _stat(
          "Revenue",
          "\$128,450",
          Icons.attach_money_rounded,
          const Color(0xFFFFE6A7),
        ),
      ],
    );
  }

  Widget _stat(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.45),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: kDarkText),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, color: kGreyText),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
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

  Widget _revenueCard() {
    return _card(
      title: "Revenue Overview",
      icon: Icons.trending_up_rounded,
      child: SizedBox(
        height: 220,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "\$128,450",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                    color: kDarkText,
                  ),
                ),
                Text(
                  "+18.4%",
                  style: TextStyle(
                    color: Color(0xFF39865B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _bar("May", 0.45),
                  _bar("Jun", 0.60),
                  _bar("Jul", 0.72),
                  _bar("Aug", 0.90),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar(String month, double height) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 35,
          height: 130 * height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [kCoral, kPeach],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 8),
        Text(month, style: const TextStyle(fontSize: 11, color: kGreyText)),
      ],
    );
  }

  Widget _verificationCard() {
    return _card(
      title: "Owner Verification",
      icon: Icons.verified_user_rounded,
      child: Column(
        children: [
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kCoral.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: const Text(
              "23",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: kDarkText,
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            "Pending verification requests",
            style: TextStyle(color: kGreyText),
          ),

          const SizedBox(height: 18),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kCoral,
              foregroundColor: kDarkText,
              elevation: 0,
            ),
            child: const Text("View Requests"),
          ),
        ],
      ),
    );
  }

  Widget _fraudCard() {
    return _card(
      title: "Fraud Detection",
      icon: Icons.security_rounded,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _riskItem("Multiple accounts", true)),
              Expanded(child: _riskItem("Suspicious bookings", true)),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(child: _riskItem("Repeated cancellations", true)),
              Expanded(child: _riskItem("Suspicious payments", false)),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              const Text(
                "Risk Score",
                style: TextStyle(fontWeight: FontWeight.bold, color: kDarkText),
              ),

              const Spacer(),

              const Text(
                "91 / 100",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFB54A4A),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          LinearProgressIndicator(
            value: 0.91,
            minHeight: 9,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: kLimeCream,
            color: kCoral,
          ),

          const SizedBox(height: 10),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Suspicious activity detected",
              style: TextStyle(
                color: Color(0xFFB54A4A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _riskItem(String title, bool warning) {
    return Row(
      children: [
        Icon(
          warning ? Icons.warning_amber_rounded : Icons.check_circle_outline,
          size: 18,
          color: warning ? Colors.orange : const Color(0xFF39865B),
        ),
        const SizedBox(width: 7),
        Flexible(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12, color: kGreyText),
          ),
        ),
      ],
    );
  }

  Widget _sentimentCard() {
    return _card(
      title: "Customer Sentiment",
      icon: Icons.psychology_rounded,
      child: Column(
        children: [
          _progress("Positive", 0.82, "82%", kMint),
          const SizedBox(height: 12),
          _progress("Neutral", 0.11, "11%", kPeach),
          const SizedBox(height: 12),
          _progress("Negative", 0.07, "7%", kCoral),

          const SizedBox(height: 22),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Most Mentioned",
              style: TextStyle(fontWeight: FontWeight.w800, color: kDarkText),
            ),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 7,
            children: [
              _tag("✓ Location"),
              _tag("✓ Cleanliness"),
              _tag("✓ Price"),
              _tag("⚠ WiFi"),
              _tag("⚠ Noise"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progress(String title, double value, String percentage, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            title,
            style: const TextStyle(fontSize: 12, color: kGreyText),
          ),
        ),

        Expanded(
          child: LinearProgressIndicator(
            value: value,
            minHeight: 9,
            borderRadius: BorderRadius.circular(10),
            backgroundColor: Colors.grey.withOpacity(0.08),
            color: color,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          percentage,
          style: const TextStyle(fontWeight: FontWeight.bold, color: kDarkText),
        ),
      ],
    );
  }

  Widget _tag(String text) {
    return Chip(
      label: Text(text, style: const TextStyle(fontSize: 11)),
      backgroundColor: kLimeCream,
      side: BorderSide.none,
    );
  }

  Widget _forecastCard() {
    return _card(
      title: "Business Intelligence",
      icon: Icons.auto_graph_rounded,
      child: Column(
        children: [
          _forecastRow("August", "\$28K", 0.60),
          _forecastRow("September", "\$32K", 0.75),
          _forecastRow("October", "\$36K", 0.90),
        ],
      ),
    );
  }

  Widget _forecastRow(String month, String revenue, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              month,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: kDarkText,
              ),
            ),
          ),

          Expanded(
            child: LinearProgressIndicator(
              value: value,
              minHeight: 12,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: kLimeCream,
              color: kPeach,
            ),
          ),

          const SizedBox(width: 15),

          Text(
            revenue,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: kDarkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: kCoral.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, size: 20, color: kDarkText),
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: kDarkText,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }
}
