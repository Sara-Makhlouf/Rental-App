import 'package:flutter/material.dart';
import 'package:rentalapp_admin/features/widgets/sidebar.dart';

class OwnerVerificationPage extends StatelessWidget {
  const OwnerVerificationPage({super.key});

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
              const Text(
                "Owner Verification",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  color: kDarkText,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Review and approve property owners",
                style: TextStyle(color: kGreyText),
              ),

              const SizedBox(height: 25),

              Row(
                children: [
                  _status("Pending", "23", kCoral, Icons.pending_actions),
                  const SizedBox(width: 15),
                  _status("Approved", "160", kMint, Icons.check_circle),
                  const SizedBox(width: 15),
                  _status("Rejected", "8", kPeach, Icons.cancel),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(15),
                    children: [
                      _owner("Ahmad Hassan", "0999123456"),
                      _owner("Omar Ali", "0988123456"),
                      _owner("Mohammad Saleh", "0944123456"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _status(String title, String number, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: kGreyText)),
                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _owner(String name, String phone) {
    return Card(
      elevation: 0,
      color: kLimeCream.withOpacity(0.5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: kPeach,
          child: const Icon(Icons.person, color: kDarkText),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(phone),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(onPressed: () {}, child: const Text("View")),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kMint,
                foregroundColor: kDarkText,
                elevation: 0,
              ),
              child: const Text("Approve"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kCoral,
                foregroundColor: kDarkText,
                elevation: 0,
              ),
              child: const Text("Reject"),
            ),
          ],
        ),
      ),
    );
  }
}
