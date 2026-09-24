import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/admin_manage.dart';
import 'package:rentalapp_admin/screens/login_screen.dart';

class OwnersManagementPage extends StatelessWidget {
  const OwnersManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementPage(
      title: "Owners Management",
      subtitle: "Manage property owners",
      icon: Icons.home_work_rounded,
      addButtonText: "Add Owner",
      items: [
        ManagementItem(
          title: "Mohammad Ahmad",
          subtitle: "12 Properties • Verified",
          icon: Icons.home_work,
          color: kMint,
        ),
        ManagementItem(
          title: "Omar Hassan",
          subtitle: "5 Properties • Verified",
          icon: Icons.home_work,
          color: kPeach,
        ),
        ManagementItem(
          title: "Ali Khaled",
          subtitle: "Pending Verification",
          icon: Icons.pending,
          color: kCoral,
        ),
      ],
    );
  }
}
