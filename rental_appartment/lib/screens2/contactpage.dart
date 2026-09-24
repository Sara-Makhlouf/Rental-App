import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_appartment/provider/setting_provuider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  final String ownerName;
  final String phone;
  final String email;
  final int ownerId;
  final int apartmentId;
  final int userId;

  const ContactPage({
    super.key,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.ownerId,
    required this.apartmentId,
    required this.userId,
  });

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _launchCall(String phone) async {
    final Uri callUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(callUri)) await launchUrl(callUri);
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Inquiry about your property',
    );
    if (await canLaunchUrl(emailUri)) await launchUrl(emailUri);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (BuildContext context, settingsProvider, Widget? child) {
        final isArabic = settingsProvider.locale.languageCode == 'ar';
        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A1A2E), Color(0xFF162447)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),

                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, __) {
                        return Opacity(
                          opacity: 0.2,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  Colors.deepPurpleAccent,
                                  Colors.transparent,
                                ],
                                radius: _pulseAnimation.value,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 30,
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.deepPurpleAccent.withOpacity(
                                    0.3,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.deepPurple
                                        .withOpacity(0.3),
                                    child: Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    widget.ownerName,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    settingsProvider.getLocalizedText(
                                      'Property Owner',
                                      'للتواصل',
                                    ),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 24),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _futuristicButton(
                                        icon: Icons.phone,
                                        label: settingsProvider
                                            .getLocalizedText('call', 'أتصال'),
                                        color: Colors.greenAccent,
                                        onTap: () => _launchCall(widget.phone),
                                      ),
                                      _futuristicButton(
                                        icon: Icons.email,
                                        label: settingsProvider
                                            .getLocalizedText(
                                              'email',
                                              'بريد إلكتروني',
                                            ),
                                        color: Colors.cyanAccent,
                                        onTap: () => _launchEmail(widget.email),
                                      ),
                                      _futuristicButton(
                                        icon: Icons.message,
                                        label: settingsProvider
                                            .getLocalizedText(
                                              'Message',
                                              'رسالة',
                                            ),
                                        color: Colors.purpleAccent,
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 40),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.deepPurpleAccent.withOpacity(0.3),
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                settingsProvider.getLocalizedText(
                                  'Owner Information',
                                  'معلومات المالك',
                                ),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                              SizedBox(height: 16),
                              _infoRow(Icons.phone, widget.phone),
                              SizedBox(height: 12),
                              _infoRow(Icons.email, widget.email),
                              SizedBox(height: 12),
                              _infoRow(Icons.person, widget.ownerName),
                            ],
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
      },
    );
  }

  Widget _futuristicButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ScaleTransition(
        scale: _pulseAnimation,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [color.withOpacity(0.7), Colors.transparent],
                  radius: 0.7,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.2),
                child: Icon(icon, size: 28, color: color),
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurpleAccent),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ),
      ],
    );
  }
}
