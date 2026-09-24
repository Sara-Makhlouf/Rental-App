import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/admin_manage.dart';
import 'package:rentalapp_admin/screens/login_screen.dart';

class UsersManagementPage extends StatelessWidget {
  const UsersManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementPage(
      title: "Users Management",
      subtitle: "Manage registered users",
      icon: Icons.people_alt_rounded,
      addButtonText: "Add User",
      items: [
        ManagementItem(
          title: "Sara Makhlouf",
          subtitle: "sara@example.com • Active",
          icon: Icons.person,
          color: kMint,
        ),
        ManagementItem(
          title: "Ahmad Ali",
          subtitle: "ahmad@example.com • Active",
          icon: Icons.person,
          color: kPeach,
        ),
        ManagementItem(
          title: "Lamar Hassan",
          subtitle: "lamar@example.com • Blocked",
          icon: Icons.person,
          color: kCoral,
        ),
      ],
    );
  }
}
