import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_appartment/controllers/booking.dart';
import 'package:rental_appartment/data/models/booking.dart';

// ============================================================
// COLOR PALETTE
// ============================================================

const kCoral = Color(0xFFFF9D9D);
const kPeach = Color(0xFFFFC5AA);
const kLimeCream = Color(0xFFEEF8CD);
const kMint = Color(0xFFBBF1D2);

const kDarkText = Color(0xFF25313C);
const kSecondaryText = Color(0xFF64748B);

// ============================================================
// EVENT PAGE
// ============================================================

class EventPage extends StatelessWidget {
  final BookingController bookingController = Get.put(
    BookingController(),
    permanent: false,
  );

  EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAF7),

        // ======================================================
        // APP BAR
        // ======================================================
        appBar: AppBar(
          title: const Text(
            "My Bookings",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          backgroundColor: kCoral,
          centerTitle: true,
          elevation: 0,

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Container(
              color: kCoral,
              child: const TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                tabs: [
                  Tab(text: "Active"),
                  Tab(text: "Past"),
                  Tab(text: "Cancelled"),
                  Tab(text: "All"),
                ],
              ),
            ),
          ),
        ),

        // ======================================================
        // BODY
        // ======================================================
        body: Obx(() {
          if (bookingController.isLoading.value &&
              bookingController.bookings.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(kCoral),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => bookingController.fetchBookings(),
            color: kCoral,
            child: TabBarView(
              children: [
                _buildBookingsList(['confirmed', 'pending']),
                _buildBookingsList(['completed']),
                _buildBookingsList(['cancelled']),
                _buildBookingsList([
                  'confirmed',
                  'pending',
                  'completed',
                  'cancelled',
                ]),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ============================================================
  // BOOKINGS LIST
  // ============================================================

  Widget _buildBookingsList(List<String> statusFilter) {
    final filteredBookings = bookingController.bookings.where((booking) {
      return statusFilter.contains(booking.status);
    }).toList();

    if (filteredBookings.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(context, filteredBookings[index]);
      },
    );
  }

  // ============================================================
  // BOOKING CARD
  // ============================================================

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    final canEdit =
        booking.status == 'confirmed' || booking.status == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: kDarkText.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),

        child: Column(
          children: [
            // ==================================================
            // IMAGE
            // ==================================================
            Stack(
              children: [
                Image.network(
                  booking.image,
                  height: 175,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 175,
                      width: double.infinity,
                      color: kLimeCream,

                      child: const Icon(
                        Icons.home_work_rounded,
                        size: 55,
                        color: kPeach,
                      ),
                    );
                  },
                ),

                // Image overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.25),
                        ],
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // STATUS
                // ==================================================
                Positioned(
                  top: 14,
                  right: 14,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 7,
                    ),

                    decoration: BoxDecoration(
                      color: _getStatusColor(booking.status),

                      borderRadius: BorderRadius.circular(20),

                      boxShadow: [
                        BoxShadow(
                          color: _getStatusColor(
                            booking.status,
                          ).withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Text(
                      _getStatusText(booking.status),

                      style: TextStyle(
                        color: booking.status == 'confirmed'
                            ? kDarkText
                            : Colors.white,

                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ==================================================
            // CONTENT
            // ==================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 17, 18, 18),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // ==================================================
                  // TITLE + PRICE
                  // ==================================================
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Text(
                          booking.title,

                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                            color: kDarkText,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),

                        decoration: BoxDecoration(
                          color: kMint.withOpacity(0.65),

                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Text(
                          "\$${booking.price}",

                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            color: kDarkText,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ==================================================
                  // DATE
                  // ==================================================
                  _infoRow(icon: Icons.date_range_rounded, text: booking.date),

                  const SizedBox(height: 8),

                  // ==================================================
                  // BOOKING ID
                  // ==================================================
                  _infoRow(
                    icon: Icons.confirmation_number_outlined,
                    text: "Booking #${booking.id}",
                  ),

                  // ==================================================
                  // BUTTONS
                  // ==================================================
                  if (canEdit) ...[
                    const SizedBox(height: 17),

                    const Divider(height: 1, color: Color(0xFFF0F0F0)),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        // View Details
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showBookingDetails(booking);
                            },

                            icon: const Icon(
                              Icons.visibility_outlined,
                              size: 17,
                            ),

                            label: const Text(
                              "Details",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),

                            style: OutlinedButton.styleFrom(
                              foregroundColor: kDarkText,

                              side: const BorderSide(color: kPeach, width: 1.3),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),

                              padding: const EdgeInsets.symmetric(vertical: 11),
                            ),
                          ),
                        ),

                        const SizedBox(width: 9),

                        // Cancel
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showCancelConfirmation(booking);
                            },

                            icon: const Icon(Icons.close_rounded, size: 17),

                            label: const Text(
                              "Cancel",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPeach.withOpacity(0.55),

                              foregroundColor: const Color(0xFFB94A4A),

                              elevation: 0,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),

                              padding: const EdgeInsets.symmetric(vertical: 11),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // ==================================================
                  // COMPLETED
                  // ==================================================
                  if (booking.status == 'completed') ...[
                    const SizedBox(height: 17),

                    const Divider(height: 1, color: Color(0xFFF0F0F0)),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showReviewDialog(booking);
                        },

                        icon: const Icon(Icons.star_outline_rounded, size: 19),

                        label: const Text(
                          "Leave a Review",
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: kLimeCream,

                          foregroundColor: kDarkText,

                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),

                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _infoRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Icon(icon, size: 17, color: kCoral),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            text,

            maxLines: 2,
            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              color: kSecondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOOKING DETAILS
  // ============================================================

  void _showBookingDetails(Booking booking) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.85),

          decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),

          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            padding: const EdgeInsets.fromLTRB(22, 12, 22, 25),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // Handle
                Center(
                  child: Container(
                    width: 42,
                    height: 5,

                    decoration: BoxDecoration(
                      color: kPeach,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Header
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,

                      decoration: BoxDecoration(
                        color: kLimeCream,
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: kCoral,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Text(
                        "Booking Details",

                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                          color: kDarkText,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                _buildDetailCard(
                  icon: Icons.home_work_outlined,
                  label: "Property",
                  value: booking.title,
                ),

                const SizedBox(height: 10),

                _buildDetailCard(
                  icon: Icons.attach_money_rounded,
                  label: "Price",
                  value: "\$${booking.price}",
                  valueBackground: kMint,
                ),

                const SizedBox(height: 10),

                _buildDetailCard(
                  icon: Icons.date_range_rounded,
                  label: "Booking Date",
                  value: booking.date,
                ),

                const SizedBox(height: 10),

                _buildDetailCard(
                  icon: Icons.confirmation_number_outlined,
                  label: "Booking ID",
                  value: "#${booking.id}",
                ),

                const SizedBox(height: 10),

                _buildDetailCard(
                  icon: Icons.info_outline_rounded,
                  label: "Status",
                  value: _getStatusText(booking.status),
                  valueBackground: _getStatusColor(
                    booking.status,
                  ).withOpacity(0.25),
                ),

                const SizedBox(height: 22),

                // ==================================================
                // EDIT BUTTON
                // ==================================================
                if (booking.status == 'pending' ||
                    booking.status == 'confirmed') ...[
                  SizedBox(
                    width: double.infinity,
                    height: 52,

                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.back();

                        Future.delayed(const Duration(milliseconds: 200), () {
                          _showEditBooking(booking);
                        });
                      },

                      icon: const Icon(Icons.edit_calendar_rounded, size: 20),

                      label: const Text(
                        "Edit Booking",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: kCoral,

                        foregroundColor: Colors.white,

                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],

                // Close
                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },

                    style: OutlinedButton.styleFrom(
                      foregroundColor: kDarkText,

                      side: const BorderSide(color: kPeach),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    child: const Text(
                      "Close",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      isScrollControlled: true,
    );
  }

  // ============================================================
  // DETAIL CARD
  // ============================================================

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
    Color? valueBackground,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: kLimeCream.withOpacity(0.35),
        borderRadius: BorderRadius.circular(17),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Container(
            width: 39,
            height: 39,

            decoration: BoxDecoration(
              color: kPeach.withOpacity(0.35),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: kCoral, size: 19),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  label,

                  style: const TextStyle(
                    fontSize: 11,
                    color: kSecondaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Container(
                  padding: valueBackground != null
                      ? const EdgeInsets.symmetric(horizontal: 7, vertical: 3)
                      : EdgeInsets.zero,

                  decoration: valueBackground != null
                      ? BoxDecoration(
                          color: valueBackground,
                          borderRadius: BorderRadius.circular(7),
                        )
                      : null,

                  child: Text(
                    value,

                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 14,
                      color: kDarkText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EDIT BOOKING
  // ============================================================

  void _showEditBooking(Booking booking) {
    DateTimeRange? selectedDateRange;

    Get.bottomSheet(
      SafeArea(
        child: Container(
          constraints: BoxConstraints(maxHeight: Get.height * 0.88),

          decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),

          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),

                padding: const EdgeInsets.fromLTRB(22, 12, 22, 25),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 42,
                        height: 5,

                        decoration: BoxDecoration(
                          color: kPeach,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Header
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,

                          decoration: BoxDecoration(
                            color: kLimeCream,
                            borderRadius: BorderRadius.circular(14),
                          ),

                          child: const Icon(
                            Icons.edit_calendar_rounded,
                            color: kCoral,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Text(
                            "Edit Booking",

                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w900,
                              color: kDarkText,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // Property
                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(15),

                      decoration: BoxDecoration(
                        color: kLimeCream.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(17),
                      ),

                      child: Row(
                        children: [
                          const Icon(Icons.home_work_outlined, color: kCoral),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              booking.title,

                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: kDarkText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      "Select New Dates",

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: kDarkText,
                      ),
                    ),

                    const SizedBox(height: 9),

                    // Date picker
                    InkWell(
                      borderRadius: BorderRadius.circular(17),

                      onTap: () async {
                        final picked = await showDateRangePicker(
                          context: context,

                          firstDate: DateTime.now(),

                          lastDate: DateTime(2028, 12, 31),

                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: kCoral,
                                  onPrimary: Colors.white,
                                  surface: Colors.white,
                                  onSurface: kDarkText,
                                ),
                              ),

                              child: child!,
                            );
                          },
                        );

                        if (picked != null) {
                          setModalState(() {
                            selectedDateRange = picked;
                          });
                        }
                      },

                      child: Container(
                        width: double.infinity,

                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: kLimeCream.withOpacity(0.45),

                          borderRadius: BorderRadius.circular(17),

                          border: Border.all(color: kPeach),
                        ),

                        child: Row(
                          children: [
                            const Icon(Icons.date_range_rounded, color: kCoral),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                selectedDateRange == null
                                    ? booking.date
                                    : _formatDateRange(selectedDateRange!),

                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: kDarkText,
                                ),
                              ),
                            ),

                            const Icon(
                              Icons.calendar_month_rounded,
                              size: 20,
                              color: kSecondaryText,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Current date hint
                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(13),

                      decoration: BoxDecoration(
                        color: kPeach.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 18,
                            color: kCoral,
                          ),

                          const SizedBox(width: 9),

                          const Expanded(
                            child: Text(
                              "Changing your booking may be subject to the cancellation and rescheduling policy.",

                              style: TextStyle(
                                fontSize: 12,
                                color: kSecondaryText,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ==================================================
                    // SAVE
                    // ==================================================
                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: ElevatedButton.icon(
                        onPressed: selectedDateRange == null
                            ? null
                            : () async {
                                final range = selectedDateRange!;

                                final checkIn = _formatApiDate(range.start);

                                final checkOut = _formatApiDate(range.end);

                                // أول تعديل مجاني.
                                // إذا كان عندك نظام غرامات
                                // بالـ backend غيّريها حسب منطقك.
                                const applyFine = false;

                                final success = await bookingController
                                    .updateBookingDate(
                                      booking.id!,
                                      checkIn,
                                      checkOut,
                                      applyFine,
                                    );

                                if (success) {
                                  Get.back();
                                }
                              },

                        icon: const Icon(Icons.save_rounded, size: 19),

                        label: const Text(
                          "Save Changes",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: kCoral,

                          disabledBackgroundColor: kPeach.withOpacity(0.5),

                          foregroundColor: Colors.white,

                          disabledForegroundColor: Colors.white70,

                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 48,

                      child: TextButton(
                        onPressed: () {
                          Get.back();
                        },

                        child: const Text(
                          "Keep Current Booking",
                          style: TextStyle(
                            color: kSecondaryText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),

      isScrollControlled: true,
    );
  }

  // ============================================================
  // CANCEL CONFIRMATION
  // ============================================================

  void _showCancelConfirmation(Booking booking) {
    Get.defaultDialog(
      title: "Cancel Booking",

      titleStyle: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 20,
        color: kDarkText,
      ),

      content: Column(
        children: [
          Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(
              color: kPeach.withOpacity(0.35),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.warning_amber_rounded,
              color: kCoral,
              size: 30,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            "Are you sure you want to cancel this booking?",

            textAlign: TextAlign.center,

            style: TextStyle(color: kSecondaryText, fontSize: 14, height: 1.4),
          ),
        ],
      ),

      textConfirm: "Yes, Cancel",
      textCancel: "Keep It",

      confirmTextColor: Colors.white,

      buttonColor: kCoral,

      radius: 20,

      onConfirm: () async {
        Get.back();

        final success = await bookingController.cancelBooking(booking.id!);

        if (success) {
          Get.snackbar(
            "Cancelled",
            "The booking has been moved to cancelled list.",

            snackPosition: SnackPosition.BOTTOM,

            backgroundColor: kMint,

            colorText: kDarkText,

            duration: const Duration(seconds: 3),
          );
        }
      },
    );
  }

  // ============================================================
  // REVIEW
  // ============================================================

  void _showReviewDialog(Booking booking) {
    Get.defaultDialog(
      title: "Leave a Review",

      titleStyle: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 20,
        color: kDarkText,
      ),

      content: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),

            Text(
              "How was your stay at ${booking.title}?",

              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 14, color: kSecondaryText),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),

                  child: Icon(
                    Icons.star_outline_rounded,
                    color: kCoral,
                    size: 31,
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            TextField(
              maxLines: 3,

              decoration: InputDecoration(
                hintText: "Share your experience...",

                filled: true,

                fillColor: kLimeCream.withOpacity(0.35),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),

                  borderSide: BorderSide.none,
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),

                  borderSide: const BorderSide(color: kCoral, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),

      textConfirm: "Submit Review",
      textCancel: "Cancel",

      confirmTextColor: Colors.white,

      buttonColor: kCoral,

      radius: 20,
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),

      children: [
        SizedBox(
          height: Get.height * 0.55,

          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Container(
                    padding: const EdgeInsets.all(22),

                    decoration: BoxDecoration(
                      color: kLimeCream.withOpacity(0.65),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.event_busy_outlined,

                      size: 62,

                      color: kCoral,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "No bookings found",

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: kDarkText,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Start exploring apartments to make your first booking!",

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: kSecondaryText,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DATE HELPERS
  // ============================================================

  String _formatApiDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');

    final month = date.month.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  String _formatDateRange(DateTimeRange range) {
    return '${_formatApiDate(range.start)}'
        '  →  '
        '${_formatApiDate(range.end)}';
  }

  // ============================================================
  // STATUS COLORS
  // ============================================================

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return kMint;

      case 'pending':
        return kPeach;

      case 'cancelled':
        return const Color(0xFFE57373);

      case 'completed':
        return kCoral;

      default:
        return Colors.grey;
    }
  }

  // ============================================================
  // STATUS TEXT
  // ============================================================

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return "CONFIRMED";

      case 'pending':
        return "PENDING";

      case 'cancelled':
        return "CANCELLED";

      case 'completed':
        return "COMPLETED";

      default:
        return "UNKNOWN";
    }
  }
}
