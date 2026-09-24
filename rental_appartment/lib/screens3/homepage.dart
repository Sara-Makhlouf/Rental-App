import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:rental_appartment/Agenscreens/addpage.dart';
import 'package:rental_appartment/Agenscreens/payement.dart';
import 'package:rental_appartment/controllers/apartment_controller.dart';
import 'package:rental_appartment/ownerscreens/bookings.dart';
import 'package:rental_appartment/ownerscreens/manager.dart';
import 'package:rental_appartment/ownerscreens/more.dart';
import 'package:rental_appartment/screens3/messagebox.dart';
import 'package:rental_appartment/screens3/ownerdetails.dart';
import 'package:rental_appartment/data/models/apartment.dart';

// ============================================================
// 🎨 APP COLORS
// ============================================================

const kCoral = Color(0xFFFF9D9D);
const kPeach = Color(0xFFFFC5AA);
const kLimeCream = Color(0xFFEEF8CD);
const kMint = Color(0xFFBBF1D2);

const kDarkText = Color(0xFF3B3634);
const kSecondaryText = Color(0xFF8B8378);
const kBgColor = Color(0xFFFFFCF7);

// ============================================================
// OWNER HOME
// ============================================================

class OwnerHome extends StatelessWidget {
  OwnerHome({super.key});

  final ApartmentController apartmentController = Get.put(
    ApartmentController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 76,

        titleSpacing: 20,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "OWNER DASHBOARD",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
                color: kSecondaryText,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              "Welcome back 👋",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: kDarkText,
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: GestureDetector(
              onTap: () => apartmentController.fetchApartments(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: kDarkText.withOpacity(0.07),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: kDarkText,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),

      // ======================================================
      // BOTTOM NAVIGATION
      // ======================================================
      bottomNavigationBar: buildBottomNav(context),

      // ======================================================
      // BODY
      // ======================================================
      body: Obx(() {
        final apartments = apartmentController.apartments;

        return RefreshIndicator(
          color: kCoral,
          backgroundColor: Colors.white,
          onRefresh: () async {
            await apartmentController.fetchApartments();
          },

          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),

            children: [
              // ==================================================
              // HERO
              // ==================================================
              buildWelcomeCard(apartments.length),

              const SizedBox(height: 26),

              // ==================================================
              // OVERVIEW
              // ==================================================
              const Text(
                "Overview",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: kDarkText,
                ),
              ),

              const SizedBox(height: 14),

              buildStatsGrid(apartments),

              const SizedBox(height: 30),

              // ==================================================
              // QUICK ACTIONS
              // ==================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: kDarkText,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: kLimeCream,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "TOOLS",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: kDarkText,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: quickAction(
                      icon: Icons.add_home_rounded,
                      label: "Add Property",
                      color: kCoral,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddPropertyPage()),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: quickAction(
                      icon: Icons.payments_rounded,
                      label: "Record Payment",
                      color: kMint,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecordPaymentPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ==================================================
              // PROPERTIES HEADER
              // ==================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Properties",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: kDarkText,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: kPeach.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${apartments.length} Properties",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: kDarkText,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ==================================================
              // PROPERTIES
              // ==================================================
              apartments.isEmpty
                  ? buildEmptyProperties()
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: apartments.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.63,
                          ),
                      itemBuilder: (context, index) {
                        final apt = apartments[index];

                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ApartmentOwnerEditPage(
                                  apartment: {
                                    "id": apt.id,
                                    "name": apt.title ?? "",
                                    "location": apt.address ?? "",
                                    "price": apt.pricePerNight ?? 0,
                                    "image":
                                        apt.imagesUrls != null &&
                                            apt.imagesUrls!.isNotEmpty
                                        ? apt.imagesUrls![0]
                                        : "https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg",
                                    "bedrooms": apt.bedrooms ?? 0,
                                    "bathrooms": apt.bathrooms ?? 0,
                                    "area": 90,
                                    "type": "Apartment",
                                    "description": apt.description ?? "",
                                    "furnished": false,
                                    "parking": false,
                                    "balcony": false,
                                    "petFriendly": false,
                                  },
                                  apartmentId: apt.id,
                                ),
                              ),
                            );
                          },
                          child: propertyCard(apt: apt),
                        );
                      },
                    ),
            ],
          ),
        );
      }),
    );
  }

  // ============================================================
  // WELCOME CARD
  // ============================================================

  Widget buildWelcomeCard(int propertyCount) {
    return Container(
      height: 165,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kCoral, kPeach],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: kCoral.withOpacity(0.28),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "YOUR PROPERTY SPACE",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: kDarkText,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Manage your\nproperties easily.",
                style: TextStyle(
                  fontSize: 24,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                  color: kDarkText,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "$propertyCount active properties",
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: kDarkText,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            right: -8,
            bottom: -12,
            child: Transform.rotate(
              angle: -0.15,
              child: Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.75),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.apartment_rounded,
                    size: 42,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATS GRID
  // ============================================================

  Widget buildStatsGrid(List<Apartment> apartments) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: [
        statCard(
          Icons.apartment_rounded,
          "Properties",
          apartments.length.toString(),
          kCoral,
        ),

        statCard(Icons.people_alt_rounded, "Tenants", "9", kMint),

        statCard(Icons.home_work_rounded, "Vacant", "3", kPeach),

        statCard(Icons.payments_rounded, "Income", "\$4500", kLimeCream),
      ],
    );
  }

  // ============================================================
  // BOTTOM NAV
  // ============================================================

  Widget buildBottomNav(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 82,
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: kDarkText.withOpacity(0.10),
              blurRadius: 22,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(Icons.home_rounded, "Home", true, () {}),

            navItem(Icons.business_center_rounded, "Manager", false, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ManagePage()),
              );
            }),

            navItem(Icons.event_note_rounded, "Booking", false, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookingPage()),
              );
            }),

            navItem(Icons.chat_bubble_rounded, "Message", false, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => OwnerInboxPage()),
              );
            }),

            navItem(Icons.more_horiz_rounded, "More", false, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MorePage()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget navItem(
    IconData icon,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: selected ? kCoral : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 21,
                color: selected ? Colors.white : kSecondaryText,
              ),

              const SizedBox(height: 3),

              Text(
                label,
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : kSecondaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget statCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withOpacity(0.16)),
        boxShadow: [
          BoxShadow(
            color: kDarkText.withOpacity(0.055),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.20),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: kDarkText, size: 23),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: kSecondaryText,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: kDarkText,
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
  // QUICK ACTION
  // ============================================================

  Widget quickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          height: 105,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: color.withOpacity(0.18)),
            boxShadow: [
              BoxShadow(
                color: kDarkText.withOpacity(0.05),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: kDarkText, size: 25),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: kDarkText,
                  ),
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: kSecondaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PROPERTY CARD
  // ============================================================

  Widget propertyCard({required Apartment apt}) {
    final imageUrl = apt.imagesUrls != null && apt.imagesUrls!.isNotEmpty
        ? apt.imagesUrls![0]
        : "https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: kDarkText.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // IMAGE
            // ==================================================
            Stack(
              children: [
                Image.network(
                  imageUrl,
                  height: 125,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 125,
                      color: kLimeCream,
                      child: const Center(
                        child: Icon(
                          Icons.broken_image_rounded,
                          size: 38,
                          color: kSecondaryText,
                        ),
                      ),
                    );
                  },
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_rounded, size: 12, color: kCoral),
                        SizedBox(width: 4),
                        Text(
                          "ACTIVE",
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            color: kDarkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ==================================================
            // CONTENT
            // ==================================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apt.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: kDarkText,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: kSecondaryText,
                        ),
                        const SizedBox(width: 3),

                        Expanded(
                          child: Text(
                            apt.address ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: kSecondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 9),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: kMint.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "\$${apt.pricePerNight ?? 0} / month",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: kDarkText,
                        ),
                      ),
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        infoIconText(Icons.bed_rounded, "${apt.bedrooms ?? 0}"),
                        infoIconText(
                          Icons.bathtub_rounded,
                          "${apt.bathrooms ?? 0}",
                        ),
                        infoIconText(Icons.square_foot_rounded, "90m²"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget buildEmptyProperties() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kLimeCream, width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: kLimeCream,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.home_work_outlined,
              size: 32,
              color: kDarkText,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            "No properties yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: kDarkText,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Add your first property\nto start managing your rentals.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, height: 1.5, color: kSecondaryText),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO
  // ============================================================

  Widget infoIconText(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: kCoral),

        const SizedBox(width: 3),

        Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: kSecondaryText,
          ),
        ),
      ],
    );
  }
}
