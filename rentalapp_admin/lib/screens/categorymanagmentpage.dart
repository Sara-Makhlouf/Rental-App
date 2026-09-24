import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/admin_manage.dart';
import 'package:rentalapp_admin/screens/login_screen.dart';

class CategoriesManagementPage extends StatelessWidget {
  const CategoriesManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminManagementPage(
      title: "Categories",
      subtitle: "Manage property categories",
      icon: Icons.category_rounded,
      addButtonText: "Add Category",
      items: [
        ManagementItem(
          title: "Apartment",
          subtitle: "124 properties",
          icon: Icons.apartment,
          color: kPeach,
        ),
        ManagementItem(
          title: "Villa",
          subtitle: "82 properties",
          icon: Icons.villa,
          color: kMint,
        ),
        ManagementItem(
          title: "Studio",
          subtitle: "61 properties",
          icon: Icons.home,
          color: kCoral,
        ),
        ManagementItem(
          title: "Shop",
          subtitle: "43 properties",
          icon: Icons.store,
          color: kPeach,
        ),
      ],
    );
  }
}
