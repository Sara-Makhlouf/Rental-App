import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/admin_manage.dart';
import 'package:rentalapp_admin/screens/login_screen.dart';

class NotificationsManagementPage extends StatelessWidget {
  const NotificationsManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementPage(
      title: "Notifications",
      subtitle: "Send notifications to users",
      icon: Icons.notifications_rounded,
      addButtonText: "Send Notification",
      items: [
        ManagementItem(
          title: "Booking Confirmed",
          subtitle: "Sent to 124 users",
          icon: Icons.notifications_active,
          color: kMint,
        ),
        ManagementItem(
          title: "New Property Available",
          subtitle: "Sent to 89 users",
          icon: Icons.campaign,
          color: kPeach,
        ),
      ],
    );
  }
}
