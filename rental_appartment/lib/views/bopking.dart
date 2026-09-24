import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_appartment/controllers/authcontroller.dart';
import 'package:rental_appartment/controllers/booking.dart';
import 'package:rental_appartment/ownerscreens/chat.dart';
import 'package:rental_appartment/screens2/events.dart';

// =====================================================
// 🎨 App Color Palette
// =====================================================

const kCoral = Color(0xFFFF9D9D); // Primary
const kPeach = Color(0xFFFFC5AA); // Secondary
const kLimeCream = Color(0xFFEEF8CD); // Light background
const kMint = Color(0xFFBBF1D2); // Price / confirmation
const kBgColor = Color(0xFFFFFCF7);

const kDarkText = Color(0xFF25313C);
const kSecondaryText = Color(0xFF7C8A93);

class ApartmentBookingPage extends StatefulWidget {
  final dynamic apartment;

  const ApartmentBookingPage({super.key, required this.apartment});

  @override
  State<ApartmentBookingPage> createState() => _ApartmentBookingPageState();
}

class _ApartmentBookingPageState extends State<ApartmentBookingPage> {
  final BookingController _bookingController = Get.put(BookingController());

  final AuthController _authController = Get.put(AuthController());

  DateTimeRange? _dateRange;

  int _guests = 1;

  String _selectedPaymentMethod = "Credit Card";

  // =====================================================
  // Date Picker
  // =====================================================

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kCoral,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: kDarkText,
            ),
            datePickerTheme: DatePickerThemeData(
              rangeSelectionBackgroundColor: kCoral.withOpacity(0.25),
              rangeSelectionOverlayColor: WidgetStatePropertyAll(
                kCoral.withOpacity(0.12),
              ),
              todayForegroundColor: const WidgetStatePropertyAll(kCoral),
              todayBackgroundColor: const WidgetStatePropertyAll(
                Colors.transparent,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  // =====================================================
  // Calculations
  // =====================================================

  int get _totalNights {
    if (_dateRange == null) return 0;

    return _dateRange!.duration.inDays;
  }

  double get _totalPrice {
    return _totalNights *
        (double.tryParse(widget.apartment.pricePerNight.toString()) ?? 0.0);
  }

  // =====================================================
  // Booking
  // =====================================================

  Future<void> _processBooking() async {
    if (_dateRange == null) {
      Get.snackbar(
        "Warning",
        "Please select a date range first",
        backgroundColor: kPeach,
        colorText: kDarkText,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
      );

      return;
    }

    final String checkIn = _dateRange!.start.toIso8601String().split('T')[0];

    final String checkOut = _dateRange!.end.toIso8601String().split('T')[0];

    final bool success = await _bookingController.createBooking(
      widget.apartment.id!,
      checkIn,
      checkOut,
      _guests,
    );

    if (success) {
      Get.snackbar(
        "Success",
        "Your booking request has been sent",
        backgroundColor: kMint,
        colorText: kDarkText,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        icon: const Icon(Icons.check_circle_rounded, color: kDarkText),
      );

      await _bookingController.fetchBookings();

      Get.to(() => EventPage());
    }
  }

  // =====================================================
  // Build
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,

      // ===================================================
      // App Bar
      // ===================================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: kDarkText,

        title: Text(
          widget.apartment.title ?? "Apartment Details",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w900,
            color: kDarkText,
          ),
        ),

        centerTitle: true,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kDarkText.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 20,
                  color: kDarkText,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ChatScreen(
                          bookingId: widget.apartment.id!,
                          currentUserId:
                              int.tryParse(
                                _authController.user.value?['id']?.toString() ??
                                    "0",
                              ) ??
                              0,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // ===================================================
      // Body
      // ===================================================
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // =================================================
            // Apartment Image
            // =================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 270,
                      width: double.infinity,
                      child: Image.network(
                        (widget.apartment.imagesUrls != null &&
                                widget.apartment.imagesUrls!.isNotEmpty)
                            ? widget.apartment.imagesUrls![0]
                            : 'https://images.unsplash.com/photo-1484154218962-a197022b5858?q=80&w=1000&auto=format&fit=crop',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: kLimeCream,
                            child: const Center(
                              child: Icon(
                                Icons.home_work_rounded,
                                size: 55,
                                color: kCoral,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Image overlay
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.05),
                                Colors.transparent,
                                Colors.black.withOpacity(0.25),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Price badge
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: kMint,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 12,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "\$${widget.apartment.pricePerNight ?? 0}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: kDarkText,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              "/ night",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: kSecondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // =================================================
            // Content
            // =================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =================================================
                  // Apartment Info
                  // =================================================
                  _buildSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.apartment.title ?? "Luxury Stay",
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                            color: kDarkText,
                            letterSpacing: -0.4,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: kPeach.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.star_rounded,
                                size: 18,
                                color: kCoral,
                              ),
                            ),

                            const SizedBox(width: 8),

                            const Text(
                              "4.8",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: kDarkText,
                              ),
                            ),

                            const SizedBox(width: 4),

                            const Text(
                              "(120 reviews)",
                              style: TextStyle(
                                color: kSecondaryText,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const Spacer(),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: kLimeCream,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "Available",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: kDarkText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =================================================
                  // Booking Details
                  // =================================================
                  const _SectionTitle(
                    title: "Booking Details",
                    icon: Icons.calendar_month_rounded,
                  ),

                  const SizedBox(height: 8),

                  _buildSelectionTile(
                    icon: Icons.date_range_rounded,
                    title: _dateRange == null
                        ? "Select check-in & check-out dates"
                        : "${_dateRange!.start.toLocal()}".split(' ')[0] +
                              "  →  " +
                              "${_dateRange!.end.toLocal()}".split(' ')[0],
                    onTap: _selectDateRange,
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // Guests
                  // =================================================
                  _buildSectionCard(
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: kPeach.withOpacity(0.28),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(
                            Icons.people_alt_outlined,
                            color: kCoral,
                            size: 21,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Number of Guests",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: kDarkText,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Select the number of guests",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: kSecondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),

                        _buildCircleButton(Icons.remove_rounded, () {
                          if (_guests > 1) {
                            setState(() {
                              _guests--;
                            });
                          }
                        }),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: Text(
                            "$_guests",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: kDarkText,
                            ),
                          ),
                        ),

                        _buildCircleButton(Icons.add_rounded, () {
                          setState(() {
                            _guests++;
                          });
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =================================================
                  // Payment Method
                  // =================================================
                  const _SectionTitle(
                    title: "Payment Method",
                    icon: Icons.account_balance_wallet_outlined,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      _buildPaymentOption(
                        "Credit Card",
                        Icons.credit_card_rounded,
                      ),
                      const SizedBox(width: 12),
                      _buildPaymentOption("Cash", Icons.payments_outlined),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // =================================================
                  // Price Summary
                  // =================================================
                  const _SectionTitle(
                    title: "Price Summary",
                    icon: Icons.receipt_long_outlined,
                  ),

                  const SizedBox(height: 8),

                  _buildSectionCard(
                    child: Column(
                      children: [
                        _buildPriceRow(
                          "Daily Rate",
                          "\$${widget.apartment.pricePerNight ?? 0}",
                        ),

                        const SizedBox(height: 10),

                        _buildPriceRow("Nights", "$_totalNights"),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Container(height: 1, color: kLimeCream),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: kMint,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: _buildPriceRow(
                            "Total Amount",
                            "\$${_totalPrice.toStringAsFixed(2)}",
                            isTotal: true,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =================================================
                  // Confirm Button
                  // =================================================
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kCoral,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          disabledBackgroundColor: kCoral.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        onPressed: _bookingController.isLoading.value
                            ? null
                            : _processBooking,
                        child: _bookingController.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 21,
                                  ),
                                  const SizedBox(width: 9),
                                  const Text(
                                    "Confirm and Pay",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Center(
                    child: Text(
                      "Your booking request will be sent for confirmation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kSecondaryText,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // Section Card
  // =====================================================

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: kDarkText.withOpacity(0.055),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  // =====================================================
  // Date Selection
  // =====================================================

  Widget _buildSelectionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kDarkText.withOpacity(0.055),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: kPeach.withOpacity(0.28),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                color: kCoral,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kDarkText,
                ),
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 15,
              color: kSecondaryText,
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // Circle Buttons
  // =====================================================

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: kLimeCream,
          shape: BoxShape.circle,
          border: Border.all(color: kMint.withOpacity(0.9)),
        ),
        child: Icon(icon, size: 18, color: kDarkText),
      ),
    );
  }

  // =====================================================
  // Payment Option
  // =====================================================

  Widget _buildPaymentOption(String method, IconData icon) {
    final bool isSelected = _selectedPaymentMethod == method;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          setState(() {
            _selectedPaymentMethod = method;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? kCoral.withOpacity(0.12) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? kCoral : kLimeCream,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isSelected ? kCoral : kLimeCream,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : kDarkText,
                  size: 21,
                ),
              ),

              const SizedBox(height: 9),

              Text(
                method,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? kDarkText : kSecondaryText,
                ),
              ),

              if (isSelected) ...[
                const SizedBox(height: 5),
                const Icon(Icons.check_circle_rounded, color: kCoral, size: 15),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // Price Row
  // =====================================================

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15 : 14,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
            color: isTotal ? kDarkText : kSecondaryText,
          ),
        ),

        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 21 : 15,
            fontWeight: FontWeight.w900,
            color: isTotal ? kDarkText : kDarkText,
          ),
        ),
      ],
    );
  }
}

// =====================================================
// Section Title
// =====================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: kPeach.withOpacity(0.28),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: kCoral, size: 17),
        ),

        const SizedBox(width: 9),

        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: kDarkText,
          ),
        ),
      ],
    );
  }
}
