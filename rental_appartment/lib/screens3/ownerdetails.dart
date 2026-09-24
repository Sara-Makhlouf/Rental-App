import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_appartment/controllers/apartment_controller.dart';

// ============================================================
// OWNER APP COLOR PALETTE
// ============================================================

const kCoral = Color(0xFFFF9D9D);
const kPeach = Color(0xFFFFC5AA);
const kLimeCream = Color(0xFFEEF8CD);
const kMint = Color(0xFFBBF1D2);

class ApartmentOwnerEditPage extends StatefulWidget {
  final Map<String, dynamic> apartment;
  final int apartmentId;

  const ApartmentOwnerEditPage({
    super.key,
    required this.apartment,
    required this.apartmentId,
  });

  @override
  State<ApartmentOwnerEditPage> createState() => _ApartmentOwnerEditPageState();
}

class _ApartmentOwnerEditPageState extends State<ApartmentOwnerEditPage> {
  final ApartmentController _controller = Get.put(ApartmentController());

  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController descController;
  late TextEditingController priceController;
  late TextEditingController bedroomsController;
  late TextEditingController bathroomsController;

  String? selectedType;

  List<File> newImages = [];
  List<String> oldImages = [];

  // ==========================================================
  // INIT
  // ==========================================================

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.apartment["name"]?.toString() ?? "",
    );

    addressController = TextEditingController(
      text: widget.apartment["location"]?.toString() ?? "",
    );

    descController = TextEditingController(
      text: widget.apartment["description"]?.toString() ?? "",
    );

    priceController = TextEditingController(
      text: widget.apartment["price"]?.toString() ?? "",
    );

    bedroomsController = TextEditingController(
      text: widget.apartment["bedrooms"]?.toString() ?? "",
    );

    bathroomsController = TextEditingController(
      text: widget.apartment["bathrooms"]?.toString() ?? "",
    );

    selectedType = widget.apartment["type"]?.toString() ?? "Apartment";

    final images = widget.apartment["images"];

    if (images is List) {
      oldImages = images.whereType<String>().toList();
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
  // PICK IMAGES
  // ==========================================================

  Future<void> pickImages() async {
    final picker = ImagePicker();

    final picked = await picker.pickMultiImage(imageQuality: 85);

    if (picked.isEmpty) return;

    setState(() {
      newImages.addAll(picked.map((image) => File(image.path)));
    });
  }

  // ==========================================================
  // SAVE
  // ==========================================================

  Future<void> saveData() async {
    if (nameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty) {
      Get.snackbar(
        "Missing Information",
        "Please fill in the required fields.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kPeach,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );

      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: kCoral)),
        barrierDismissible: false,
      );

      await _controller.updateApartment(
        apartmentId: widget.apartmentId,
        title: nameController.text.trim(),
        address: addressController.text.trim(),
        description: descController.text.trim(),
        price: priceController.text.trim(),
        bedrooms: bedroomsController.text.trim(),
        bathrooms: bathroomsController.text.trim(),
        type: selectedType,
        newImages: newImages,
        oldImages: oldImages,
      );

      final apartmentController = Get.find<ApartmentController>();

      await apartmentController.fetchApartments();

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (!mounted) return;

      Get.snackbar(
        "Success",
        "Apartment updated successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kMint,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
        icon: const Icon(Icons.check_circle_rounded, color: Colors.green),
      );

      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) {
          Navigator.pop(context, true);
        }
      });
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (!mounted) return;

      Get.snackbar(
        "Update Failed",
        "Something went wrong while updating the apartment.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kPeach,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
        icon: const Icon(Icons.error_outline, color: Colors.deepOrange),
      );
    }
  }

  // ==========================================================
  // DELETE
  // ==========================================================

  Future<void> deleteApartment() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: kPeach.withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 32,
                    color: Colors.red,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  "Delete Apartment?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),

                const SizedBox(height: 10),

                Text(
                  "Are you sure you want to permanently delete this apartment?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirm != true) return;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: kCoral)),
        barrierDismissible: false,
      );

      await _controller.deleteApartment(widget.apartmentId);

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (!mounted) return;

      Get.snackbar(
        "Deleted",
        "Apartment deleted successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kMint,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );

      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          Navigator.pop(context, true);
        }
      });
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        "Error",
        "Failed to delete apartment.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kPeach,
        colorText: Colors.black87,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF8),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "Edit Apartment",
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
        ),

        actions: [
          IconButton(
            tooltip: "Delete",
            onPressed: deleteApartment,
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: kPeach.withOpacity(0.35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.red,
                size: 21,
              ),
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // HEADER
            // ==================================================
            _buildHeader(),

            const SizedBox(height: 28),

            // ==================================================
            // BASIC INFORMATION
            // ==================================================
            _sectionHeader(
              icon: Icons.home_work_outlined,
              title: "Basic Information",
              subtitle: "Update your apartment information.",
            ),

            const SizedBox(height: 15),

            _buildCard(
              child: Column(
                children: [
                  _field(
                    nameController,
                    "Property Name",
                    icon: Icons.home_outlined,
                  ),

                  const SizedBox(height: 14),

                  _field(
                    addressController,
                    "Address",
                    icon: Icons.location_on_outlined,
                  ),

                  const SizedBox(height: 14),

                  _dropdown(),

                  const SizedBox(height: 14),

                  _textarea(
                    descController,
                    "Description",
                    icon: Icons.description_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // PROPERTY DETAILS
            // ==================================================
            _sectionHeader(
              icon: Icons.tune_rounded,
              title: "Property Details",
              subtitle: "Manage price and apartment specifications.",
            ),

            const SizedBox(height: 15),

            _buildCard(
              child: Column(
                children: [
                  _field(
                    priceController,
                    "Price (USD)",
                    number: true,
                    icon: Icons.payments_outlined,
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _field(
                          bedroomsController,
                          "Bedrooms",
                          number: true,
                          icon: Icons.bed_outlined,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _field(
                          bathroomsController,
                          "Bathrooms",
                          number: true,
                          icon: Icons.bathtub_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // IMAGES
            // ==================================================
            _sectionHeader(
              icon: Icons.photo_library_outlined,
              title: "Property Images",
              subtitle: "Manage your apartment photos.",
            ),

            const SizedBox(height: 15),

            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Upload button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: pickImages,
                      icon: const Icon(Icons.add_photo_alternate_outlined),
                      label: const Text(
                        "Add New Images",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.deepOrange,
                        side: const BorderSide(color: kCoral),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (oldImages.isNotEmpty) ...[
                    _imageLabel("Current Images", oldImages.length),

                    const SizedBox(height: 10),

                    _buildOldImages(),

                    const SizedBox(height: 20),
                  ],

                  if (newImages.isNotEmpty) ...[
                    _imageLabel("New Images", newImages.length),

                    const SizedBox(height: 10),

                    _buildNewImages(),
                  ],

                  if (oldImages.isEmpty && newImages.isEmpty) _emptyImages(),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // SAVE BUTTON
            // ==================================================
            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kCoral,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 23),
                    SizedBox(width: 9),
                    Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Delete button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: TextButton.icon(
                onPressed: deleteApartment,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
                label: const Text(
                  "Delete Apartment",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kCoral, kPeach],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: kCoral.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.edit_road, color: Colors.white, size: 30),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit your property",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  nameController.text.isEmpty
                      ? "Update apartment details"
                      : nameController.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _sectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: kLimeCream,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: Colors.black87, size: 22),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CARD
  // ============================================================

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _field(
    TextEditingController controller,
    String label, {
    bool number = false,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),

        prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 21),

        filled: true,
        fillColor: const Color(0xFFFFFBF8),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: kCoral, width: 1.5),
        ),
      ),
    );
  }

  // ============================================================
  // TEXT AREA
  // ============================================================

  Widget _textarea(
    TextEditingController controller,
    String label, {
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      maxLines: 4,
      style: const TextStyle(fontSize: 14, height: 1.4),
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,

        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 55),
          child: Icon(icon, color: Colors.grey.shade600),
        ),

        filled: true,
        fillColor: const Color(0xFFFFFBF8),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: kCoral, width: 1.5),
        ),
      ),
    );
  }

  // ============================================================
  // DROPDOWN
  // ============================================================

  Widget _dropdown() {
    const types = ["Apartment", "Villa", "Studio", "Shop"];

    return DropdownButtonFormField<String>(
      value: types.contains(selectedType) ? selectedType : "Apartment",

      decoration: InputDecoration(
        labelText: "Property Type",

        prefixIcon: Icon(Icons.category_outlined, color: Colors.grey.shade600),

        filled: true,
        fillColor: const Color(0xFFFFFBF8),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: kCoral, width: 1.5),
        ),
      ),

      items: types
          .map(
            (type) => DropdownMenuItem<String>(value: type, child: Text(type)),
          )
          .toList(),

      onChanged: (value) {
        setState(() {
          selectedType = value;
        });
      },
    );
  }

  // ============================================================
  // IMAGE LABEL
  // ============================================================

  Widget _imageLabel(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),

        const SizedBox(width: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: kLimeCream,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "$count",
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // OLD IMAGES
  // ============================================================

  Widget _buildOldImages() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: oldImages.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final image = oldImages[index];

        return _imageItem(
          image: Image.network(
            image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                color: Colors.grey.shade100,
                child: const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.grey,
                ),
              );
            },
          ),
          isNew: false,
          onDelete: () {
            setState(() {
              oldImages.removeAt(index);
            });
          },
        );
      },
    );
  }

  // ============================================================
  // NEW IMAGES
  // ============================================================

  Widget _buildNewImages() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: newImages.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final image = newImages[index];

        return _imageItem(
          image: Image.file(image, fit: BoxFit.cover),
          isNew: true,
          onDelete: () {
            setState(() {
              newImages.removeAt(index);
            });
          },
        );
      },
    );
  }

  // ============================================================
  // IMAGE ITEM
  // ============================================================

  Widget _imageItem({
    required Widget image,
    required bool isNew,
    required VoidCallback onDelete,
  }) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.shade100,
            child: image,
          ),
        ),

        // New badge
        if (isNew)
          Positioned(
            left: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: kMint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "NEW",
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900),
              ),
            ),
          ),

        // Delete
        Positioned(
          right: 6,
          top: 6,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 29,
              height: 29,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 17,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY IMAGES
  // ============================================================

  Widget _emptyImages() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: kLimeCream.withOpacity(0.45),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.image_outlined, size: 45, color: Colors.grey.shade500),

          const SizedBox(height: 10),

          Text(
            "No images available",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "Add photos to make your property attractive.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
