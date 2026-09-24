import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/admin_manage.dart';
import 'package:rentalapp_admin/screens/login_screen.dart';

class DisputesManagementPage extends StatelessWidget {
  const DisputesManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementPage(
      title: "Dispute Management",
      subtitle: "Resolve customer and owner disputes",
      icon: Icons.warning_amber_rounded,
      addButtonText: "Refresh",
      items: [
        ManagementItem(
          title: "Dispute #D-1001",
          subtitle: "Booking #BK-1024 • Open",
          icon: Icons.report_problem,
          color: kCoral,
        ),
        ManagementItem(
          title: "Dispute #D-1002",
          subtitle: "Booking #BK-1009 • Under Review",
          icon: Icons.pending,
          color: kPeach,
        ),
      ],
    );
  }
}
