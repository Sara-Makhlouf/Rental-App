import 'package:flutter/material.dart';
import 'package:rental_appartment/core/colors.dart';
import 'package:rental_appartment/screens3/homepage.dart';

class Agentpage extends StatelessWidget {
  const Agentpage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 64),

                Text(
                  'List Your Property with Confidence',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),

                const SizedBox(height: 16),
                Text(
                  'Reach verified renters faster using a powerful dashboard designed to manage listings, inquiries, and performance — all in one place.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade700,
                    height: 1.65,
                  ),
                ),

                const SizedBox(height: 56),

                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/istockphoto-1440568749-2048x2048.jpg',
                      height: size.height * 0.34,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 64),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) =>  OwnerHome()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      backgroundColor: AppColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continue to Dashboard',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
