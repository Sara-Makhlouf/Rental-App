import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_appartment/controllers/booking.dart';
import 'package:rental_appartment/screens2/events.dart';

class ApartmentBookingPage extends StatefulWidget {
  final dynamic apartment;

  const ApartmentBookingPage({super.key, required this.apartment});

  @override
  State<ApartmentBookingPage> createState() => _ApartmentBookingPageState();
}

class _ApartmentBookingPageState extends State<ApartmentBookingPage> {
  final BookingController _bookingController = Get.find<BookingController>();

  DateTimeRange? _dateRange;
  int _guests = 1;
  String _selectedPaymentMethod = "Credit Card"; 

  Future<void> _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFFCE266E)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  // حساب عدد الليالي
  int get _totalNights => _dateRange == null ? 0 : _dateRange!.duration.inDays;

  // حساب السعر الإجمالي
  double get _totalPrice =>
      _totalNights *
      (double.tryParse(widget.apartment.pricePerNight.toString()) ?? 0.0);

  Future<void> _processBooking() async {
    if (_dateRange == null) {
      Get.snackbar(
        "Warning",
        "Please select a date range first",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    String checkIn = _dateRange!.start.toIso8601String().split('T')[0];
    String checkOut = _dateRange!.end.toIso8601String().split('T')[0];

    bool success = await _bookingController.createBooking(
      widget.apartment.id!,
      checkIn,
      checkOut,
      _guests,
    );

    if (success) {
      Get.snackbar(
        "Success",
        "Your booking request has been sent",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await _bookingController.fetchBookings();
      Get.to(() => EventPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFCE266E);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.apartment.title ?? "Apartment Details"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Image.network(
                    (widget.apartment.photos != null &&
                            widget.apartment.photos.isNotEmpty)
                        ? widget.apartment.photos[0]
                        : 'https://img.icons8.com/?size=100&id=67366&format=png&color=000000',
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.apartment.title ?? "Luxury Stay",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 20,
                            ),
                            const Text(
                              " 4.8 (120 reviews)",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const Spacer(),
                            Text(
                              "\$${widget.apartment.pricePerNight} / night",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const _SectionTitle("Booking Details"),

                  _buildSelectionTile(
                    icon: Icons.calendar_month,
                    title: _dateRange == null
                        ? "Select check-in & check-out dates"
                        : "${_dateRange!.start.toLocal()}".split(' ')[0] +
                              "  →  " +
                              "${_dateRange!.end.toLocal()}".split(' ')[0],
                    onTap: _selectDateRange,
                  ),

                  _buildSectionCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Number of Guests",
                          style: TextStyle(fontSize: 16),
                        ),
                        Row(
                          children: [
                            _buildCircleButton(
                              Icons.remove,
                              () => setState(
                                () => _guests > 1 ? _guests-- : null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                "$_guests",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildCircleButton(
                              Icons.add,
                              () => setState(() => _guests++),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const _SectionTitle("Payment Method"),

                  Row(
                    children: [
                      _buildPaymentOption("Credit Card", Icons.credit_card),
                      const SizedBox(width: 12),
                      _buildPaymentOption("Cash", Icons.payments_outlined),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const _SectionTitle("Price Summary"),

                  _buildSectionCard(
                    child: Column(
                      children: [
                        _buildPriceRow(
                          "Daily Rate",
                          "\$${widget.apartment.pricePerNight}",
                        ),
                        _buildPriceRow("Nights", "$_totalNights"),
                        const Divider(height: 24),
                        _buildPriceRow(
                          "Total Amount",
                          "\$${_totalPrice.toStringAsFixed(2)}",
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        onPressed: _bookingController.isLoading.value
                            ? null
                            : _processBooking,
                        child: _bookingController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Confirm and Pay",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSectionCard({required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _buildSelectionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: _buildSectionCard(
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFCE266E)),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFFCE266E)),
      ),
    );
  }

  Widget _buildPaymentOption(String method, IconData icon) {
    bool isSelected = _selectedPaymentMethod == method;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedPaymentMethod = method),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFCE266E).withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFFCE266E) : Colors.grey[300]!,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFFCE266E) : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                method,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 20 : 15,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.bold,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
