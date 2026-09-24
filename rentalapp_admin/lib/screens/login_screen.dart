import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentalapp_admin/controllers/auth_controller.dart';
import 'package:rentalapp_admin/admin_dashboard.dart';

const kCoral = Color(0xFFFF9D9D);
const kPeach = Color(0xFFFFC5AA);
const kLimeCream = Color(0xFFEEF8CD);
const kMint = Color(0xFFBBF1D2);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController authController = Get.find<AuthController>();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await authController.login(
      _phoneController.text.trim(),
      _passwordController.text,
    );

    if (success) {
      Get.offAll(() => const AdminDashboard());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLimeCream,
      body: Stack(
        children: [
          // ================= Background =================
          Positioned(
            top: -100,
            right: -80,
            child: _decorativeCircle(
              size: 260,
              color: kCoral.withOpacity(0.35),
            ),
          ),

          Positioned(
            bottom: -120,
            left: -100,
            child: _decorativeCircle(
              size: 300,
              color: kPeach.withOpacity(0.35),
            ),
          ),

          Positioned(
            top: 180,
            left: -70,
            child: _decorativeCircle(size: 150, color: kMint.withOpacity(0.7)),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 30,
                ),
                child: Form(
                  key: _formKey,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 470),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.94),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: kCoral.withOpacity(0.16),
                          blurRadius: 35,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // ================= Logo =================
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [kCoral, kPeach],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: kCoral.withOpacity(0.30),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ================= Title =================
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF303030),
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Sign in to manage your rental platform',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ================= Phone =================
                        _buildInputField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          hint: 'Enter your phone number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your phone number';
                            }

                            if (value.trim().length < 7) {
                              return 'Please enter a valid phone number';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // ================= Password =================
                        _buildInputField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Enter your password',
                          icon: Icons.lock_outline_rounded,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.black45,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }

                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        // ================= Forgot Password =================
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: kCoral,
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // ================= Login Button =================
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: authController.isLoading.value
                                  ? null
                                  : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: kCoral,
                                disabledBackgroundColor: kCoral.withOpacity(
                                  0.55,
                                ),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17),
                                ),
                              ),
                              child: authController.isLoading.value
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 21,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ================= Security Info =================
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: kMint.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                size: 20,
                                color: Color(0xFF4E8062),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Your account and login information are protected.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF496452),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Rental Platform • Admin Portal',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black38,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
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
  // Input Field
  // ============================================================

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(
        color: Color(0xFF303030),
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
        prefixIcon: Container(
          margin: const EdgeInsets.only(left: 8, right: 8),
          child: Icon(icon, color: kCoral),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFFFFAF8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: kPeach.withOpacity(0.45)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: kPeach.withOpacity(0.45)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: kCoral, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  // ============================================================
  // Decorative Circle
  // ============================================================

  Widget _decorativeCircle({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
