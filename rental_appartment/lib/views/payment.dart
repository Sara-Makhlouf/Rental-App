import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_appartment/controllers/booking.dart';
import 'package:rental_appartment/data/models/apartment.dart';
import 'package:rental_appartment/screens2/events.dart';

class PremiumPaymentPage extends StatefulWidget {
  final Apartment apartment;

  const PremiumPaymentPage({super.key, required this.apartment});

  @override
  State<PremiumPaymentPage> createState() => _PremiumPaymentPageState();
}

class _PremiumPaymentPageState extends State<PremiumPaymentPage> {
  final BookingController bookingController = Get.put(BookingController());

  String selectedMethod = 'Credit / Mada Card';
  late String finalBookingDate;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    finalBookingDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    return double.tryParse(price.toString()) ?? 0.0;
  }

  Future<void> _handlePayment(double total, String title, String image) async {
    String startDate = finalBookingDate;

    DateTime endDateTime = DateTime.now().add(const Duration(days: 1));
    String endDate =
        "${endDateTime.year}-${endDateTime.month.toString().padLeft(2, '0')}-${endDateTime.day.toString().padLeft(2, '0')}";

    setState(() => isProcessing = true);

    bool success = await bookingController.createBooking(
      widget.apartment.id,
      startDate,
      endDate,
      1,
    );

    setState(() => isProcessing = false);

    if (success) {
      _showSuccessDialog(
        totalAmount: total,
        title: title,
        image: image,
        date: "$startDate to $endDate",
      );
    } else {
      print("فشلت عملية الحجز - تأكد من الـ Console لمعرفة السبب");
    }
  }

  void _showSuccessDialog({
    required double totalAmount,
    required String title,
    required String image,
    required String date,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 30),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Successfully rented\n$title',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => EventPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'View your Booking',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title = widget.apartment.title ?? 'Luxury Apartment';
    final String image =
        (widget.apartment.imagesUrls != null &&
            widget.apartment.imagesUrls!.isNotEmpty)
        ? widget.apartment.imagesUrls!.first
        : '';
    final double basePrice = _parsePrice(widget.apartment.pricePerNight ?? 0.0);
    final double tax = basePrice * 0.15;
    const double maintenance = 200.0;
    const double deposit = 1000.0;
    final double total = basePrice + tax + maintenance + deposit;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildApartmentHeader(title, image),
                      const SizedBox(height: 20),
                      _buildDateInfoCard(finalBookingDate),
                      const SizedBox(height: 30),
                      const _SectionTitle(title: 'Price Summary (Monthly)'),
                      _buildPriceSummary(basePrice, tax, total),
                      const SizedBox(height: 30),
                      const _SectionTitle(title: 'Choose Payment Method'),
                      _buildPaymentMethodsList(),
                      const SizedBox(height: 40),
                      _buildPayButton(total, title, image),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (isProcessing)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateInfoCard(String date) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 12),
          const Text(
            'Booking Date: ',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
          ),
          Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Payment Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF334155)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApartmentHeader(String title, String image) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: image.isNotEmpty && image.startsWith('http')
                ? Image.network(
                    image,
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const Text(
                  'Verified Luxury Unit',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    width: 85,
    height: 85,
    color: Colors.grey[200],
    child: const Icon(Icons.apartment, color: Colors.grey),
  );

  Widget _buildPriceSummary(double base, double tax, double total) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _priceRow('Monthly Rent', '${base.toStringAsFixed(2)} SAR'),
          _priceRow('Maintenance', '200.00 SAR'),
          _priceRow('Deposit', '1,000.00 SAR'),
          _priceRow('VAT (15%)', '${tax.toStringAsFixed(2)} SAR'),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Due Now',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${total.toStringAsFixed(2)} SAR',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsList() {
    return Column(
      children: [
        _paymentOption('Credit / Mada Card', 'Visa, Mastercard', Colors.blue),
        _paymentOption('Apple Pay', 'Instant Payment', Colors.black),
      ],
    );
  }

  Widget _paymentOption(String title, String subtitle, Color color) {
    bool isSelected = selectedMethod == title;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            width: 2,
          ),
        ),
        child: RadioListTile<String>(
          value: title,
          groupValue: selectedMethod,
          activeColor: const Color(0xFF2563EB),
          onChanged: (val) => setState(() => selectedMethod = val!),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }

  Widget _buildPayButton(double total, String title, String image) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: isProcessing
            ? null
            : () => _handlePayment(total, title, image),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          isProcessing
              ? 'Processing...'
              : 'Pay ${total.toStringAsFixed(0)} SAR Now',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
