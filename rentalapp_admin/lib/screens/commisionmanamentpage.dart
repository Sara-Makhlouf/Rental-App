import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/sidebar.dart';

class CommissionManagementPage extends StatefulWidget {
  const CommissionManagementPage({super.key});

  @override
  State<CommissionManagementPage> createState() =>
      _CommissionManagementPageState();
}

class _CommissionManagementPageState extends State<CommissionManagementPage> {
  double commission = 5;

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
                "Platform Commission",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),

              const SizedBox(height: 5),

              const Text(
                "Configure platform commission",
                style: TextStyle(color: kGreyText),
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
                      "Platform Commission",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "${commission.toInt()}%",
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    Slider(
                      value: commission,
                      min: 0,
                      max: 30,
                      divisions: 30,
                      activeColor: kCoral,
                      onChanged: (value) {
                        setState(() {
                          commission = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    const Divider(),

                    const SizedBox(height: 20),

                    _money("Gross Booking Revenue", "\$100,000"),

                    _money("Platform Revenue", "\$5,000"),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kCoral,
                          foregroundColor: kDarkText,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text("Save Commission"),
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

  Widget _money(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(color: kGreyText)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
