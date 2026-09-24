import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/admin_manage.dart';
import 'package:rentalapp_admin/screens/login_screen.dart';

class PropertyApprovalPage extends StatelessWidget {
  const PropertyApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementPage(
      title: "Property Approval",
      subtitle: "Review properties before publishing",
      icon: Icons.approval_rounded,
      addButtonText: "Refresh",
      items: [
        ManagementItem(
          title: "Luxury Apartment",
          subtitle: "Owner: Ahmad Hassan • Pending",
          icon: Icons.pending_actions,
          color: kCoral,
        ),
        ManagementItem(
          title: "Sea View Villa",
          subtitle: "Owner: Omar Ali • Pending",
          icon: Icons.pending_actions,
          color: kPeach,
        ),
      ],
    );
  }
}
