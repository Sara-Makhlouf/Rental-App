import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/sidebar.dart';
import 'package:rentalapp_admin/screens/login_screen.dart'
    hide kCoral, kPeach, kLimeCream;

class AdminManagementPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String addButtonText;
  final List<ManagementItem> items;

  const AdminManagementPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.items,
    this.addButtonText = "Add New",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLimeCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: kCoral.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(icon, color: kDarkText, size: 25),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: kDarkText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(color: kGreyText),
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: Text(addButtonText),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kCoral,
                      foregroundColor: kDarkText,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return _item(items[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(ManagementItem item) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: item.color.withOpacity(0.25),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(item.icon, color: kDarkText),
      ),
      title: Text(
        item.title,
        style: const TextStyle(fontWeight: FontWeight.w800, color: kDarkText),
      ),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.visibility_outlined, color: kGreyText),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, color: kDarkText),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}

class ManagementItem {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;

  ManagementItem({
    required this.title,
    this.subtitle,
    required this.icon,
    this.color = kPeach,
  });
}
