import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/admin_manage.dart';
import 'package:rentalapp_admin/screens/login_screen.dart';

class PropertiesManagementPage extends StatelessWidget {
  const PropertiesManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementPage(
      title: "Properties Management",
      subtitle: "Manage all properties",
      icon: Icons.apartment_rounded,
      addButtonText: "Add Property",
      items: [
        ManagementItem(
          title: "Luxury Apartment",
          subtitle: "Damascus • \$500/month",
          icon: Icons.apartment,
          color: kMint,
        ),
        ManagementItem(
          title: "Modern Villa",
          subtitle: "Latakia • \$900/month",
          icon: Icons.villa,
          color: kPeach,
        ),
        ManagementItem(
          title: "Studio Apartment",
          subtitle: "Aleppo • \$250/month",
          icon: Icons.house,
          color: kCoral,
        ),
      ],
    );
  }
}
