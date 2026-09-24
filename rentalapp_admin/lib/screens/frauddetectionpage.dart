import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/sidebar.dart';
import 'package:rentalapp_admin/screens/login_screen.dart'
    hide kCoral, kLimeCream;

class FraudDetectionPage extends StatelessWidget {
  const FraudDetectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLimeCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Fraud Detection",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: kDarkText,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Monitor suspicious activity",
                style: TextStyle(color: kGreyText),
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        color: kCoral.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "91",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: kDarkText,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 30),

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Risk Score",
                          style: TextStyle(fontSize: 15, color: kGreyText),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "91 / 100",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFB54A4A),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Suspicious activity detected",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB54A4A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    _item("Multiple Accounts", Icons.people, "Detected", true),
                    _item(
                      "Suspicious Bookings",
                      Icons.calendar_month,
                      "Detected",
                      true,
                    ),
                    _item(
                      "Repeated Cancellations",
                      Icons.cancel,
                      "Detected",
                      true,
                    ),
                    _item(
                      "Suspicious Payments",
                      Icons.payment,
                      "Normal",
                      false,
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

  Widget _item(String title, IconData icon, String status, bool danger) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 30,
            color: danger ? Colors.orange : const Color(0xFF39865B),
          ),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(
            status,
            style: TextStyle(
              color: danger ? Colors.orange : const Color(0xFF39865B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
