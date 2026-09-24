import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/admin_manage.dart';
import 'package:rentalapp_admin/screens/login_screen.dart';

class ReportsManagementPage extends StatelessWidget {
  const ReportsManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementPage(
      title: "Reports Management",
      subtitle: "Review reported users and properties",
      icon: Icons.report_problem_rounded,
      addButtonText: "Export Reports",
      items: [
        ManagementItem(
          title: "User Report #R-102",
          subtitle: "Reported user • Abuse",
          icon: Icons.person_off,
          color: kCoral,
        ),
        ManagementItem(
          title: "Property Report #R-103",
          subtitle: "Fake listing suspected",
          icon: Icons.home_work,
          color: kPeach,
        ),
      ],
    );
  }
}
