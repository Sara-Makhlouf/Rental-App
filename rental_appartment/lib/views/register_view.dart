import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_appartment/controllers/authcontroller.dart';
import 'package:rental_appartment/data/models/role.dart';
import 'package:rental_appartment/views/login_view.dart';

/// Palette — keep in sync with login_view.dart
const Color kCoral = Color(0xFFFF9D9D);
const Color kPeach = Color(0xFFFFC5AA);
const Color kLime = Color(0xFFEEF8CD);
const Color kMint = Color(0xFFBBF1D2);
const Color kInk = Color(0xFF25313C);
const Color kInkMuted = Color(0xFF7C8A93);

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  Role? roleid;
  final List<String> countryCodes = ['+966', '+971', '+965', '+20', '+963'];
  String selectedCountryCode = '+963';
  final TextEditingController phonenum = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();
  final List<Role> roles = [
    Role(id: 1, name: 'User (Renter)'),
    Role(id: 2, name: 'Owner'),
  ];

  XFile? personalPhoto;
  XFile? idPhoto;

  bool _obscureText = true;
  bool _pressedDown = false;

  final AuthController auth = Get.find<AuthController>();

  // ---- Entrance animation (staggered, section by section) ----
  static const int _sectionCount = 9;
  late final AnimationController _controller;
  late final List<Animation<double>> _fadeAnims;
  late final List<Animation<Offset>> _slideAnims;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    const step = 0.7 / (_sectionCount - 1);
    _fadeAnims = List.generate(_sectionCount, (i) {
      final start = i * step;
      final end = (start + 0.3).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });
    _slideAnims = List.generate(_sectionCount, (i) {
      final start = i * step;
      final end = (start + 0.3).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.12),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _controller.forward();
  }

  Widget _animated(int index, Widget child) {
    return FadeTransition(
      opacity: _fadeAnims[index],
      child: SlideTransition(position: _slideAnims[index], child: child),
    );
  }

  @override
  void dispose() {
    phonenum.dispose();
    pass.dispose();
    firstName.dispose();
    lastName.dispose();
    dateOfBirth.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: kCoral,
            colorScheme: const ColorScheme.light(primary: kCoral),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dateOfBirth.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<XFile?> _pickImageSource(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_rounded,
                    color: kCoral,
                  ),
                  title: const Text(
                    'Choose from gallery',
                    style: TextStyle(color: kInk, fontWeight: FontWeight.w600),
                  ),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_rounded, color: kCoral),
                  title: const Text(
                    'Choose from camera',
                    style: TextStyle(color: kInk, fontWeight: FontWeight.w600),
                  ),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source != null) {
      try {
        final XFile? pickedFile = await picker.pickImage(source: source);
        return pickedFile;
      } catch (e) {
        if (mounted) {
          Get.snackbar(
            'Error',
            'Failed to pick image: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: kCoral,
            colorText: kInk,
          );
        }
        return null;
      }
    }
    return null;
  }

  void _pickPersonalPhoto() async {
    final picked = await _pickImageSource(context);
    if (picked != null) {
      setState(() {
        personalPhoto = picked;
      });
    }
  }

  void _pickIdPhoto() async {
    final picked = await _pickImageSource(context);
    if (picked != null) {
      setState(() {
        idPhoto = picked;
      });
    }
  }

  InputDecoration _fieldDecoration({
    required String hint,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: kInkMuted, fontSize: 15),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
      filled: true,
      fillColor: const Color(0xFFF6F7F8),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: const BorderSide(color: kCoral, width: 1.6),
      ),
      errorBorder: border.copyWith(
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
    );
  }

  Widget _buildUploadCard({
    required String label,
    required String subtitle,
    required IconData icon,
    required XFile? file,
    required VoidCallback onPressed,
    required String errorMessage,
  }) {
    final hasFile = file != null;
    final hasError = !hasFile && errorMessage.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7F8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasError ? Colors.redAccent : Colors.transparent,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: hasFile
                        ? kMint.withOpacity(0.6)
                        : kPeach.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    hasFile ? Icons.check_rounded : icon,
                    color: kInk,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: kInk,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasFile ? file.name : subtitle,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: hasFile ? kInk.withOpacity(0.7) : kInkMuted,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: kInkMuted.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
      ],
    );
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (personalPhoto == null || idPhoto == null) {
      setState(() {}); // refresh to show upload-card error states
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: kCoral,
          content: Text(
            'Please upload all required photos',
            style: TextStyle(color: kInk),
          ),
        ),
      );
      return;
    }

    String roleString = roleid!.id == 1 ? 'tenant' : 'owner';

    String fullPhoneNumber = selectedCountryCode + phonenum.text.trim();

    final ok = await auth.register(
      firstName.text.trim(),
      lastName.text.trim(),
      fullPhoneNumber,
      pass.text,
      dateOfBirth.text,
      roleString,
      personalPhoto,
      idPhoto,
    );
    if (ok) {
      Get.offAll(() => const LoginView());
      Get.snackbar(
        'Registration Successful',
        'Your account is pending admin approval',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kMint,
        colorText: kInk,
        icon: const Icon(Icons.check_circle_outline, color: kInk),
        borderRadius: 14,
        margin: const EdgeInsets.all(16),
      );
    } else {
      Get.snackbar(
        'Registration Failed',
        auth.message.value ?? 'Unknown error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: kCoral,
        colorText: kInk,
        icon: const Icon(Icons.error_outline, color: kInk),
        borderRadius: 14,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String personalPhotoError = personalPhoto == null
        ? 'Please upload your personal photo'
        : '';
    String idPhotoError = idPhoto == null ? 'Please upload your ID photo' : '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Decorative background blobs — same language as the login screen
          Positioned(
            top: -140,
            right: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kLime.withOpacity(0.6), kLime.withOpacity(0.0)],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -180,
            left: -140,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kMint.withOpacity(0.5), kMint.withOpacity(0.0)],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),

                    // Header
                    _animated(
                      0,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [kCoral, kPeach],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: kCoral.withOpacity(0.3),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person_add_alt_1_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Welcome!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: kInk,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Create your account to get started',
                            style: TextStyle(fontSize: 14.5, color: kInkMuted),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 34),

                    // First + last name
                    _animated(
                      1,
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: firstName,
                              style: const TextStyle(color: kInk),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Required'
                                  : null,
                              decoration: _fieldDecoration(hint: 'First Name'),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: TextFormField(
                              controller: lastName,
                              style: const TextStyle(color: kInk),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Required'
                                  : null,
                              decoration: _fieldDecoration(hint: 'Last Name'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Phone number
                    _animated(
                      2,
                      TextFormField(
                        controller: phonenum,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: kInk),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter your phone number'
                            : null,
                        decoration: _fieldDecoration(
                          hint: 'Enter Your Phone Number',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedCountryCode,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: kInkMuted,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                onChanged: (val) {
                                  setState(() {
                                    selectedCountryCode = val!;
                                  });
                                },
                                items: countryCodes
                                    .map(
                                      (code) => DropdownMenuItem(
                                        value: code,
                                        child: Text(
                                          code,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: kInk,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Date of birth + role
                    _animated(
                      3,
                      Column(
                        children: [
                          TextFormField(
                            controller: dateOfBirth,
                            readOnly: true,
                            style: const TextStyle(color: kInk),
                            onTap: () => _selectDate(context),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please select your date of birth'
                                : null,
                            decoration: _fieldDecoration(
                              hint: 'Select Date of Birth',
                              suffixIcon: const Icon(
                                Icons.calendar_today_rounded,
                                color: kInkMuted,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<Role>(
                            value: roleid,
                            style: const TextStyle(color: kInk, fontSize: 15),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: kInkMuted,
                            ),
                            validator: (value) => value == null
                                ? 'Please select account type'
                                : null,
                            decoration: _fieldDecoration(
                              hint: 'Select Account Type',
                            ),
                            items: roles.map((role) {
                              return DropdownMenuItem<Role>(
                                value: role,
                                child: Text(role.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                roleid = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Personal photo upload
                    _animated(
                      4,
                      _buildUploadCard(
                        label: 'Personal Photo',
                        subtitle: 'A clear photo of your face',
                        icon: Icons.person_outline_rounded,
                        file: personalPhoto,
                        onPressed: _pickPersonalPhoto,
                        errorMessage: personalPhotoError,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ID photo upload
                    _animated(
                      5,
                      _buildUploadCard(
                        label: 'ID Photo',
                        subtitle: 'Front side of your national ID',
                        icon: Icons.badge_outlined,
                        file: idPhoto,
                        onPressed: _pickIdPhoto,
                        errorMessage: idPhotoError,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Password
                    _animated(
                      6,
                      TextFormField(
                        controller: pass,
                        obscureText: _obscureText,
                        style: const TextStyle(color: kInk),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        decoration: _fieldDecoration(
                          hint: 'Enter Your Password',
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                            color: kInkMuted,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                              color: kInkMuted,
                            ),
                            onPressed: () =>
                                setState(() => _obscureText = !_obscureText),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Register button
                    _animated(
                      7,
                      Obx(
                        () => GestureDetector(
                          onTapDown: (_) => setState(() => _pressedDown = true),
                          onTapUp: (_) => setState(() => _pressedDown = false),
                          onTapCancel: () =>
                              setState(() => _pressedDown = false),
                          child: AnimatedScale(
                            scale: _pressedDown ? 0.97 : 1.0,
                            duration: const Duration(milliseconds: 120),
                            curve: Curves.easeOut,
                            child: Container(
                              width: double.infinity,
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [kCoral, kPeach],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: kCoral.withOpacity(0.35),
                                    blurRadius: 18,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: auth.loading.value
                                      ? null
                                      : _handleRegister,
                                  child: Center(
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      child: auth.loading.value
                                          ? const SizedBox(
                                              key: ValueKey('loading'),
                                              height: 22,
                                              width: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.4,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Text(
                                              'Register And Agree',
                                              key: ValueKey('label'),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.2,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Divider + social + footer
                    _animated(
                      8,
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: Colors.grey.shade300),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    color: kInkMuted,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: Colors.grey.shade300),
                              ),
                            ],
                          ),
                          const SizedBox(height: 26),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _socialIcon(FontAwesomeIcons.google),
                              const SizedBox(width: 18),
                              _socialIcon(FontAwesomeIcons.facebookF),
                              const SizedBox(width: 18),
                              _socialIcon(FontAwesomeIcons.apple),
                            ],
                          ),
                          const SizedBox(height: 36),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Have An Account? ',
                                style: TextStyle(
                                  color: kInkMuted,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.offAll(() => const LoginView());
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: kCoral,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(FaIconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F8),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: FaIcon(icon, color: kInk, size: 19),
    );
  }
}
