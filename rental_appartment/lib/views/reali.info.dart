import 'package:flutter/material.dart';
import 'package:rental_appartment/core/colors.dart';
import 'package:rental_appartment/views/agent.dart';
import 'package:rental_appartment/views/user.dart';

class Realinfo extends StatefulWidget {
  final int role;

  const Realinfo({super.key, required this.role});

  @override
  State<Realinfo> createState() => _RealinfoState();
}

class _RealinfoState extends State<Realinfo>
    with SingleTickerProviderStateMixin {
  double _agentScale = 1.0;
  double _userScale = 1.0;

  Widget _buildGradientCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradientColors,
    required Widget targetPage,
    required ValueSetter<double> onScaleChange,
    required double currentScale,
  }) {
    final Color shadowColor = gradientColors.last.withOpacity(0.5);

    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => setState(() => onScaleChange(0.95)),
        onTapUp: (_) {
          setState(() => onScaleChange(1.0));
          Future.delayed(const Duration(milliseconds: 100), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => targetPage),
            );
          });
        },
        onTapCancel: () => setState(() => onScaleChange(1.0)),
        child: AnimatedScale(
          scale: currentScale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: Container(
            height: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: Icon(icon, color: Colors.white, size: 45),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> agentGradient = [
      AppColors.blue,
      const Color(0xFF1E88E5),
      const Color(0xFF0D47A1),
    ];
    final List<Color> userGradient = [
      Colors.orange.shade600,
      Colors.deepOrange.shade700,
      Colors.red.shade700,
    ];
    final Color primaryColor = AppColors.blue;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apartment_rounded, color: primaryColor, size: 38),
                  const SizedBox(width: 10),
                  Text(
                    'RealEstate Portal',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              Text(
                'How Would You Like To Enter?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Please select the role that best defines your access requirements.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 60),

              Row(
                children: [
                  _buildGradientCard(
                    title: 'Real Estate Agent',
                    subtitle:
                        'Manage listings, track commissions, and connect with clients.',
                    icon: Icons.business_center_rounded,
                    gradientColors: agentGradient,
                    targetPage: Agentpage(),
                    onScaleChange: (scale) =>
                        setState(() => _agentScale = scale),
                    currentScale: _agentScale,
                  ),

                  const SizedBox(width: 25),

                  _buildGradientCard(
                    title: 'Client/Tenant Access',
                    subtitle:
                        'Search for properties, manage rental contracts, and submit requests.',
                    icon: Icons.home_work_rounded,
                    gradientColors: userGradient,
                    targetPage: Userpage(),
                    onScaleChange: (scale) =>
                        setState(() => _userScale = scale),
                    currentScale: _userScale,
                  ),
                ],
              ),

              const SizedBox(height: 60),

              Column(
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.support_agent_rounded,
                      size: 20,
                      color: primaryColor,
                    ),
                    label: Text(
                      'Need Help? Contact Support',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '© 2025 RealEstate Portal. Secure Access.',
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
