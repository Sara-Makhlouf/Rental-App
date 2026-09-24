import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/admin_manage.dart';
import 'package:rentalapp_admin/screens/login_screen.dart';

class BookingsManagementPage extends StatelessWidget {
  const BookingsManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementPage(
      title: "Bookings Management",
      subtitle: "Monitor and manage bookings",
      icon: Icons.calendar_month_rounded,
      addButtonText: "Refresh",
      items: [
        ManagementItem(
          title: "Booking #BK-1024",
          subtitle: "Sara • Luxury Apartment • \$500",
          icon: Icons.event_available,
          color: kMint,
        ),
        ManagementItem(
          title: "Booking #BK-1025",
          subtitle: "Ahmad • Sea View Villa • \$900",
          icon: Icons.pending,
          color: kPeach,
        ),
        ManagementItem(
          title: "Booking #BK-1026",
          subtitle: "Lamar • Studio • Cancelled",
          icon: Icons.cancel,
          color: kCoral,
        ),
      ],
    );
  }
}
