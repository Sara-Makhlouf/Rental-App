import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/sidebar.dart';
import 'package:rentalapp_admin/screens/login_screen.dart'
    hide kLimeCream, kMint, kPeach, kCoral;

class SubscriptionsManagementPage extends StatelessWidget {
  const SubscriptionsManagementPage({super.key});

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
                "Subscription Management",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),

              const SizedBox(height: 5),

              const Text(
                "Manage owner subscription plans",
                style: TextStyle(color: kGreyText),
              ),

              const SizedBox(height: 25),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _plan("Free", "\$0", [
                    "Basic Properties",
                    "Basic Booking",
                  ], kMint),
                  _plan("Pro", "\$19", [
                    "Unlimited Properties",
                    "Advanced Analytics",
                    "Priority Support",
                  ], kPeach),
                  _plan("Business", "\$49", [
                    "Unlimited Properties",
                    "Advanced Analytics",
                    "AI Insights",
                    "Priority Support",
                  ], kCoral),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _plan(String name, String price, List<String> features, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: color.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),

            const SizedBox(height: 18),

            Text(
              price,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),

            const SizedBox(height: 18),

            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 18,
                      color: Color(0xFF39865B),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(feature)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text("Edit Plan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
