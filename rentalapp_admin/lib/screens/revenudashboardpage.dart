import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/sidebar.dart';
import 'package:rentalapp_admin/screens/login_screen.dart'
    hide kPeach, kMint, kCoral, kLimeCream;

class RevenueDashboardPage extends StatelessWidget {
  const RevenueDashboardPage({super.key});

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
              const Text(
                "Revenue Dashboard",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: kDarkText,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Monitor platform financial performance",
                style: TextStyle(color: kGreyText),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  _metric(
                    "Gross Booking Revenue",
                    "\$100,000",
                    Icons.account_balance_wallet,
                    kPeach,
                  ),
                  const SizedBox(width: 15),
                  _metric(
                    "Platform Revenue",
                    "\$5,000",
                    Icons.attach_money,
                    kMint,
                  ),
                  const SizedBox(width: 15),
                  _metric("Commission", "5%", Icons.percent, kCoral),
                ],
              ),

              const SizedBox(height: 25),

              Container(
                height: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Revenue Growth",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 25),

                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _bar("May", 0.40),
                          _bar("Jun", 0.55),
                          _bar("Jul", 0.72),
                          _bar("Aug", 0.90),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metric(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 11, color: kGreyText),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
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

  Widget _bar(String month, double value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 45,
          height: 180 * value,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [kCoral, kPeach]),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 8),
        Text(month),
      ],
    );
  }
}
