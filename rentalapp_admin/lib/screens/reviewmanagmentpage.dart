import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/admin_manage.dart';
import 'package:rentalapp_admin/screens/login_screen.dart';

class ReviewsManagementPage extends StatelessWidget {
  const ReviewsManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementPage(
      title: "Reviews",
      subtitle: "Monitor customer reviews",
      icon: Icons.star_rounded,
      addButtonText: "Refresh",
      items: [
        ManagementItem(
          title: "★★★★★  Excellent apartment",
          subtitle: "Sara • Luxury Apartment",
          icon: Icons.star,
          color: kMint,
        ),
        ManagementItem(
          title: "★★★☆☆  Average",
          subtitle: "Ahmad • Studio",
          icon: Icons.star_half,
          color: kPeach,
        ),
        ManagementItem(
          title: "★☆☆☆☆  Poor WiFi",
          subtitle: "Lamar • Villa",
          icon: Icons.warning,
          color: kCoral,
        ),
      ],
    );
  }
}
