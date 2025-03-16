import 'package:flutter/material.dart';
import 'package:dog/dogbreed.dart';
import 'package:dog/logregforgot/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.pinkAccent, Colors.purpleAccent],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      40,
                    ), // กำหนดความโค้งของมุม
                    child: Image.asset(
                      'IMG/Logo.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover, // ปรับให้รูปเต็มพื้นที่
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    'PawVerse',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      foreground:
                          Paint()
                            ..shader = const LinearGradient(
                              colors: [Colors.white, Color.fromARGB(255, 222, 222, 221)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(
                              const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                            ),
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black45,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _navigateTo(context, const LoginScreen()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () => _navigateTo(context, DogBreedScreen()),
                    child: const Text(
                      'เข้าชมโดยไม่เข้าสู่ระบบ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
