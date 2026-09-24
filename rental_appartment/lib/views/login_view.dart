import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_appartment/controllers/authcontroller.dart';
import 'package:rental_appartment/screens2/homepage.dart';
import 'package:rental_appartment/screens3/homepage.dart';
import 'register_view.dart';

/// Palette
const Color kCoral = Color(0xFFFF9D9D);
const Color kPeach = Color(0xFFFFC5AA);
const Color kLime = Color(0xFFEEF8CD);
const Color kMint = Color(0xFFBBF1D2);
const Color kInk = Color(0xFF25313C); // dark neutral for headings/text
const Color kInkMuted = Color(0xFF7C8A93); // muted body text

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController phonenum = TextEditingController();
  final TextEditingController pass = TextEditingController();
  bool _obscureText = true;

  final List<String> countryCodes = ['+966', '+971', '+965', '+20', '+963'];
  String selectedCountryCode = '+963';

  final AuthController auth = Get.put(AuthController());

  late final AnimationController _controller;
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _phoneFade;
  late final Animation<Offset> _phoneSlide;
  late final Animation<double> _passFade;
  late final Animation<Offset> _passSlide;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _footerFade;

  bool _pressedDown = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoFade = _fade(0.0, 0.5);
    _logoSlide = _slide(0.0, 0.5);

    _titleFade = _fade(0.15, 0.6);
    _titleSlide = _slide(0.15, 0.6);

    _phoneFade = _fade(0.3, 0.75);
    _phoneSlide = _slide(0.3, 0.75);

    _passFade = _fade(0.42, 0.85);
    _passSlide = _slide(0.42, 0.85);

    _buttonFade = _fade(0.55, 0.95);
    _buttonSlide = _slide(0.55, 0.95);

    _footerFade = _fade(0.7, 1.0);

    _controller.forward();
  }

  Animation<double> _fade(double start, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
  }

  Animation<Offset> _slide(double start, double end) {
    return Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    phonenum.dispose();
    pass.dispose();
    _controller.dispose();
    super.dispose();
  }

  void handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final fullPhoneNumber = selectedCountryCode + phonenum.text.trim();

    final ok = await auth.login(fullPhoneNumber, pass.text);

    if (ok) {
      String role = auth.user.value?['role'] ?? '';

      if (role.isEmpty || role == 'pending') {
        _showSnack(
          'Waiting Approval',
          'Your account is pending admin approval',
          kPeach,
          darkText: true,
        );
        return;
      }

      if (role == 'tenant') {
        Get.offAll(() => const HomePage());
        _showSnack('Success', 'Logged in as Tenant', kMint, darkText: true);
      } else if (role == 'owner') {
        Get.offAll(() => OwnerHome());
        _showSnack('Success', 'Logged in as Owner', kMint, darkText: true);
      } else {
        _showSnack('Error', 'Unknown role', kCoral, darkText: true);
      }
    } else {
      _showSnack(
        'Error',
        auth.errorMessage.value ?? 'Login failed',
        kCoral,
        darkText: true,
      );
    }
  }

  void _showSnack(
    String title,
    String message,
    Color color, {
    bool darkText = false,
  }) {
    final textColor = darkText ? kInk : Colors.white;
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: textColor,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
      duration: const Duration(seconds: 3),
      animationDuration: const Duration(milliseconds: 400),
      icon: Icon(
        title == 'Success'
            ? Icons.check_circle_outline
            : title == 'Error'
            ? Icons.error_outline
            : Icons.hourglass_bottom_rounded,
        color: textColor,
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Decorative animated background blobs — soft, low-opacity, professional
          Positioned(
            top: -size.width * 0.35,
            right: -size.width * 0.3,
            child: FadeTransition(
              opacity: _logoFade,
              child: Container(
                width: size.width * 0.8,
                height: size.width * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [kMint.withOpacity(0.55), kMint.withOpacity(0.0)],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -size.width * 0.4,
            left: -size.width * 0.35,
            child: FadeTransition(
              opacity: _logoFade,
              child: Container(
                width: size.width * 0.9,
                height: size.width * 0.9,
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
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),

                    // Logo / brand mark
                    FadeTransition(
                      opacity: _logoFade,
                      child: SlideTransition(
                        position: _logoSlide,
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [kCoral, kPeach],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: kCoral.withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.home_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    FadeTransition(
                      opacity: _titleFade,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello Again!',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: kInk,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Login to continue exploring apartments',
                              style: TextStyle(fontSize: 15, color: kInkMuted),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 44),

                    // Phone field
                    FadeTransition(
                      opacity: _phoneFade,
                      child: SlideTransition(
                        position: _phoneSlide,
                        child: TextFormField(
                          controller: phonenum,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: kInk),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter your phone number'
                              : null,
                          decoration: _fieldDecoration(
                            hint: 'Enter Your Phone Number',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
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
                    ),

                    const SizedBox(height: 18),

                    // Password field
                    FadeTransition(
                      opacity: _passFade,
                      child: SlideTransition(
                        position: _passSlide,
                        child: TextFormField(
                          controller: pass,
                          obscureText: _obscureText,
                          style: const TextStyle(color: kInk),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Please enter your password'
                              : null,
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
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Get.to(() => const ForgotView());
                        },
                        style: TextButton.styleFrom(foregroundColor: kInk),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Login button
                    FadeTransition(
                      opacity: _buttonFade,
                      child: SlideTransition(
                        position: _buttonSlide,
                        child: Obx(
                          () => GestureDetector(
                            onTapDown: (_) =>
                                setState(() => _pressedDown = true),
                            onTapUp: (_) =>
                                setState(() => _pressedDown = false),
                            onTapCancel: () =>
                                setState(() => _pressedDown = false),
                            child: AnimatedScale(
                              scale: _pressedDown ? 0.97 : 1.0,
                              duration: const Duration(milliseconds: 120),
                              curve: Curves.easeOut,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
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
                                        : handleLogin,
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
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2.4,
                                                      color: Colors.white,
                                                    ),
                                              )
                                            : const Text(
                                                'Login',
                                                key: ValueKey('label'),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.3,
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
                    ),

                    const SizedBox(height: 36),

                    FadeTransition(
                      opacity: _footerFade,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't Have An Account? ",
                            style: TextStyle(color: kInkMuted),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.off(() => const RegisterView());
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: kCoral,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
}
