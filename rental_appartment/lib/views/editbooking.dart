import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_appartment/controllers/booking.dart';
import 'package:rental_appartment/data/models/booking.dart';

class EditBookingPage extends StatefulWidget {
  final Booking booking;
  const EditBookingPage({super.key, required this.booking});

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  final BookingController _controller = Get.find<BookingController>();
  late TextEditingController _dateController;
  final Color primaryColor = const Color.fromARGB(255, 206, 38, 110);

  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.booking.date);
  }

  Future<void> _selectDate() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.light(primary: primaryColor)),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedRange = picked;
        _dateController.text =
            "${picked.start.toLocal()}".split(' ')[0] +
            " to " +
            "${picked.end.toLocal()}".split(' ')[0];
      });
    }
  }

  void _confirmUpdate() {
    if (_selectedRange == null) {
      Get.snackbar(
        "تنبيه",
        "يرجى اختيار تاريخ جديد أولاً",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    int edits = widget.booking.rescheduleCount ?? 0;
    bool hasFine = edits > 0;

    Get.defaultDialog(
      title: hasFine ? " Edit with fine " : " Edit Free",
      middleText: hasFine
          ? "  This booking has  a previous edit, a fine of \$20 will be applied. Do you want to continue?"
          : "This is your first edit, it's free of charge. Do you want to continue?",
      textConfirm: "confirm",
      textCancel: "cancel",
      confirmTextColor: Colors.white,
      buttonColor: primaryColor,
      onConfirm: () async {
        Get.back();

        String start = _selectedRange!.start.toIso8601String().split('T')[0];
        String end = _selectedRange!.end.toIso8601String().split('T')[0];

        bool success = await _controller.updateBookingDate(
          widget.booking.id!,
          start,
          end,
          hasFine,
        );

        if (success) {
          Get.back();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "  Edit Booking Date",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "  Choice new date:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: _selectDate,
              decoration: InputDecoration(
                labelText: " new Date",
                prefixIcon: const Icon(Icons.calendar_month),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: (widget.booking.rescheduleCount ?? 0) > 0
                    ? Colors.orange[50]
                    : Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    (widget.booking.rescheduleCount ?? 0) > 0
                        ? Icons.warning_amber
                        : Icons.info_outline,
                    color: (widget.booking.rescheduleCount ?? 0) > 0
                        ? Colors.orange
                        : Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      (widget.booking.rescheduleCount ?? 0) > 0
                          ? "Notice: you have edited before, a fine of \$20 will be applied."
                          : "Notice: its your first edit, it's free of charge.",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
            Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: _controller.isLoading.value ? null : _confirmUpdate,
                child: _controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Update Booking Date Now",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
