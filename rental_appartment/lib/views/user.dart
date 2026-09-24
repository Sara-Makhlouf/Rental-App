import 'package:flutter/material.dart';
import 'package:rental_appartment/core/colors.dart';
import 'package:rental_appartment/screens2/homepage.dart';

class Userpage extends StatelessWidget {
  const Userpage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),

                Text(
                  'Discover a Better Place to Live',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  'Explore thousands of rental options tailored to your needs. Compare prices, locations, and amenities — all in one simple experience.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade700,
                    height: 1.7,
                  ),
                ),

                const SizedBox(height: 50),

                Center(
                  child: Image.asset(
                    'assets/images/istockphoto-1225864170-2048x2048.jpg',
                    height: size.height * 0.36,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 60),

                Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.black45,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            'Start Exploring',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
