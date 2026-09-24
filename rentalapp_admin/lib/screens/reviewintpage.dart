import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/sidebar.dart';
import 'package:rentalapp_admin/screens/login_screen.dart'
    hide kLimeCream, kPeach, kCoral, kMint;

class ReviewsIntelligencePage extends StatelessWidget {
  const ReviewsIntelligencePage({super.key});

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
                "Reviews Intelligence",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),

              const SizedBox(height: 5),

              const Text(
                "AI-powered review analysis",
                style: TextStyle(color: kGreyText),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  _sentiment("Positive", "82%", kMint),
                  _sentiment("Neutral", "11%", kPeach),
                  _sentiment("Negative", "7%", kCoral),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _keywords("Most Mentioned", [
                      "Location",
                      "Cleanliness",
                      "Price",
                    ]),
                  ),
                  const SizedBox(width: 20),
                  Expanded(child: _keywords("Problems", ["WiFi", "Noise"])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sentiment(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: color.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _keywords(String title, List<String> values) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values
                .map(
                  (e) => Chip(
                    label: Text(e),
                    backgroundColor: kLimeCream,
                    side: BorderSide.none,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
