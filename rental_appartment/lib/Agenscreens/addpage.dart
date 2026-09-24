import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:rental_appartment/controllers/apartment_controller.dart';
import 'package:rental_appartment/screens3/homepage.dart';

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
// ADD PROPERTY PAGE
// ============================================================

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({super.key});

  @override
  State<AddPropertyPage> createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  final ApartmentController apartmentController = Get.find();

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final bedroomsController = TextEditingController();
  final bathroomsController = TextEditingController();

  String? selectedType;
  List<File> images = [];

  bool isSaving = false;

  // ==========================================================
  // PICK IMAGES
  // ==========================================================

  Future<void> pickImages() async {
    final picker = ImagePicker();

    final picked = await picker.pickMultiImage();

    if (picked.isNotEmpty) {
      setState(() {
        images.addAll(picked.map((e) => File(e.path)));
      });
    }
  }

  // ==========================================================
  // SAVE PROPERTY
  // ==========================================================

  Future<void> saveProperty() async {
    if (nameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        images.isEmpty) {
      Get.snackbar(
        "Missing information",
        "Please fill the required fields and add at least one image.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kPeach,
        colorText: kDarkText,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
        icon: const Icon(Icons.warning_amber_rounded, color: kDarkText),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    final success = await apartmentController.addNewApartment(
      title: nameController.text.trim(),
      description: descController.text.trim(),
      address: addressController.text.trim(),
      price: priceController.text.trim(),
      bedrooms: bedroomsController.text.trim(),
      bathrooms: bathroomsController.text.trim(),
      images: images,
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      Get.snackbar(
        "Property added!",
        "Your property has been added successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kMint,
        colorText: kDarkText,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.check_circle_rounded, color: kDarkText),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Get.off(() => OwnerHome());
        }
      });
    } else {
      Get.snackbar(
        "Something went wrong",
        "Failed to add property. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kPeach,
        colorText: kDarkText,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
        icon: const Icon(Icons.error_outline_rounded, color: kDarkText),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    descController.dispose();
    priceController.dispose();
    bedroomsController.dispose();
    bathroomsController.dispose();

    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,

      // ======================================================
      // APP BAR
      // ======================================================
      appBar: AppBar(
        backgroundColor: kBgColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        toolbarHeight: 76,

        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: kDarkText.withOpacity(0.07),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: kDarkText,
                size: 21,
              ),
            ),
          ),
        ),

        titleSpacing: 8,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "PROPERTY",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: kSecondaryText,
              ),
            ),
            SizedBox(height: 3),
            Text(
              "Add New Property",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                color: kDarkText,
              ),
            ),
          ],
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.fromLTRB(20, 4, 20, 35),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // HERO
            // ==================================================
            buildHeaderCard(),

            const SizedBox(height: 24),

            // ==================================================
            // BASIC INFORMATION
            // ==================================================
            sectionTitle(
              "Basic Information",
              "Tell us about your property",
              Icons.home_work_rounded,
              kCoral,
            ),

            const SizedBox(height: 12),

            formCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appField(
                    controller: nameController,
                    label: "Property Name",
                    hint: "e.g. Modern City Apartment",
                    icon: Icons.home_outlined,
                  ),

                  appField(
                    controller: addressController,
                    label: "Address",
                    hint: "e.g. Damascus, Syria",
                    icon: Icons.location_on_outlined,
                  ),

                  appDropdown(),

                  appTextarea(
                    controller: descController,
                    label: "Description",
                    hint: "Describe your property...",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // ==================================================
            // PROPERTY DETAILS
            // ==================================================
            sectionTitle(
              "Property Details",
              "Set the important information",
              Icons.tune_rounded,
              kPeach,
            ),

            const SizedBox(height: 12),

            formCard(
              child: Column(
                children: [
                  appField(
                    controller: priceController,
                    label: "Price",
                    hint: "e.g. 500",
                    icon: Icons.payments_outlined,
                    number: true,
                    suffix: "USD",
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: appField(
                          controller: bedroomsController,
                          label: "Bedrooms",
                          hint: "0",
                          icon: Icons.bed_outlined,
                          number: true,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: appField(
                          controller: bathroomsController,
                          label: "Bathrooms",
                          hint: "0",
                          icon: Icons.bathtub_outlined,
                          number: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // ==================================================
            // IMAGES
            // ==================================================
            sectionTitle(
              "Property Photos",
              "Add beautiful photos of your property",
              Icons.photo_library_rounded,
              kMint,
            ),

            const SizedBox(height: 12),

            formCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildImageUploadButton(),

                  if (images.isNotEmpty) ...[
                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Selected Photos",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: kDarkText,
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: kLimeCream,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${images.length} photos",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: kDarkText,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    GridView.builder(
                      itemCount: images.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 9,
                            crossAxisSpacing: 9,
                            childAspectRatio: 1,
                          ),

                      itemBuilder: (_, i) {
                        return buildImageItem(images[i], i);
                      },
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ==================================================
            // SAVE BUTTON
            // ==================================================
            buildSaveButton(),

            const SizedBox(height: 12),

            const Center(
              child: Text(
                "Make sure all information is correct before saving.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.5, color: kSecondaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER CARD
  // ==========================================================

  Widget buildHeaderCard() {
    return Container(
      height: 145,
      width: double.infinity,
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
            color: kCoral.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),

      child: Stack(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "NEW LISTING",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: kDarkText,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "Create a place\npeople will love.",
                style: TextStyle(
                  fontSize: 23,
                  height: 1.08,
                  fontWeight: FontWeight.w900,
                  color: kDarkText,
                ),
              ),
            ],
          ),

          Positioned(
            right: -12,
            bottom: -22,
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
              child: const Icon(
                Icons.add_home_rounded,
                color: Colors.white,
                size: 42,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SECTION TITLE
  // ==========================================================

  Widget sectionTitle(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.20),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: kDarkText, size: 21),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: kDarkText,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                style: const TextStyle(fontSize: 10.5, color: kSecondaryText),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // FORM CARD
  // ==========================================================

  Widget formCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kLimeCream, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: kDarkText.withOpacity(0.045),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  // ==========================================================
  // TEXT FIELD
  // ==========================================================

  Widget appField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool number = false,
    String? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,

        keyboardType: number
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,

        style: const TextStyle(
          color: kDarkText,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),

        decoration: InputDecoration(
          labelText: label,
          hintText: hint,

          labelStyle: const TextStyle(color: kSecondaryText, fontSize: 12),

          hintStyle: const TextStyle(color: Color(0xFFB9B1A8), fontSize: 12),

          prefixIcon: Icon(icon, color: kCoral, size: 20),

          suffixText: suffix,

          suffixStyle: const TextStyle(
            color: kSecondaryText,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),

          filled: true,
          fillColor: kBgColor,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 16,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: kLimeCream, width: 1),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: kCoral, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // TEXT AREA
  // ==========================================================

  Widget appTextarea({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: TextField(
        controller: controller,
        maxLines: 4,

        style: const TextStyle(
          color: kDarkText,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),

        decoration: InputDecoration(
          labelText: label,
          hintText: hint,

          alignLabelWithHint: true,

          labelStyle: const TextStyle(color: kSecondaryText, fontSize: 12),

          hintStyle: const TextStyle(color: Color(0xFFB9B1A8), fontSize: 12),

          prefixIcon: const Padding(
            padding: EdgeInsets.only(bottom: 55),
            child: Icon(Icons.description_outlined, color: kCoral, size: 20),
          ),

          filled: true,
          fillColor: kBgColor,

          contentPadding: const EdgeInsets.all(16),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: kLimeCream),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: kCoral, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DROPDOWN
  // ==========================================================

  Widget appDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: selectedType,

        decoration: InputDecoration(
          labelText: "Property Type",

          labelStyle: const TextStyle(color: kSecondaryText, fontSize: 12),

          prefixIcon: const Icon(
            Icons.category_outlined,
            color: kCoral,
            size: 20,
          ),

          filled: true,
          fillColor: kBgColor,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: kLimeCream),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: kCoral, width: 1.5),
          ),
        ),

        dropdownColor: Colors.white,

        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: kSecondaryText,
        ),

        style: const TextStyle(
          color: kDarkText,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),

        items: const [
          DropdownMenuItem(value: "Apartment", child: Text("Apartment")),
          DropdownMenuItem(value: "Villa", child: Text("Villa")),
          DropdownMenuItem(value: "Studio", child: Text("Studio")),
          DropdownMenuItem(value: "Shop", child: Text("Shop")),
        ],

        onChanged: (value) {
          setState(() {
            selectedType = value;
          });
        },
      ),
    );
  }

  // ==========================================================
  // IMAGE UPLOAD BUTTON
  // ==========================================================

  Widget buildImageUploadButton() {
    return GestureDetector(
      onTap: pickImages,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
        decoration: BoxDecoration(
          color: kLimeCream.withOpacity(0.55),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kMint, width: 1.3),
        ),
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: const BoxDecoration(
                color: kMint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_upload_rounded,
                color: kDarkText,
                size: 27,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Upload Property Photos",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: kDarkText,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              "Tap here to select multiple images",
              style: TextStyle(fontSize: 10.5, color: kSecondaryText),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // IMAGE ITEM
  // ==========================================================

  Widget buildImageItem(File image, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: () {
              setState(() {
                images.removeAt(index);
              });
            },
            child: Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: kDarkText,
              ),
            ),
          ),
        ),

        if (index == 0)
          Positioned(
            left: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: kCoral,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "COVER",
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ==========================================================
  // SAVE BUTTON
  // ==========================================================

  Widget buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: isSaving ? null : saveProperty,

        style: ElevatedButton.styleFrom(
          backgroundColor: kCoral,
          disabledBackgroundColor: kPeach.withOpacity(0.65),
          foregroundColor: Colors.white,

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19),
          ),
        ),

        child: isSaving
            ? const SizedBox(
                width: 23,
                height: 23,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: 21),

                  SizedBox(width: 9),

                  Text(
                    "Save Property",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
      ),
    );
  }
}
