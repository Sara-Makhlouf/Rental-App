import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/sidebar.dart';
import 'package:rentalapp_admin/screens/login_screen.dart'
    hide kCoral, kLimeCream, kMint, kPeach;

class BusinessIntelligencePage extends StatelessWidget {
  const BusinessIntelligencePage({super.key});

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
                "Business Intelligence",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: kDarkText,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Platform performance and future predictions",
                style: TextStyle(color: kGreyText),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  _stat("Revenue Growth", "+18.4%", kMint),
                  _stat("Booking Growth", "+12.7%", kPeach),
                  _stat("User Growth", "+21.3%", kCoral),
                  _stat("Cancellation Rate", "4.2%", kPeach),
                  _stat("Avg. Booking", "\$346", kMint),
                ],
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Revenue Forecast",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 20),

                    _forecast("August", "\$28K", 0.60),
                    _forecast("September", "\$32K", 0.75),
                    _forecast("October", "\$36K", 0.90),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stat(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 11, color: kGreyText)),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }

  Widget _forecast(String month, String revenue, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              month,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              minHeight: 13,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: kLimeCream,
              color: kCoral,
            ),
          ),
          const SizedBox(width: 15),
          Text(revenue, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
