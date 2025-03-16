import 'package:dog/Dogbreed.dart';
import 'package:dog/LogRegForgot/Login.dart';
import 'package:dog/InGameScreen/PetScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dog/Service/AuthService.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isSubmitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _authService.sendPasswordResetEmail(_emailController.text.trim());
        
        if (mounted) {
          setState(() {
            _isSubmitted = true;
            _isLoading = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('ส่งอีเมลรีเซ็ตรหัสผ่านเรียบร้อยแล้ว'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'เกิดข้อผิดพลาดในการส่งอีเมล';
        
        if (e.code == 'user-not-found') {
          errorMessage = 'ไม่พบอีเมลนี้ในระบบ';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'รูปแบบอีเมลไม่ถูกต้อง';
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('เกิดข้อผิดพลาด: $e'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('ลืมรหัสผ่าน'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.lock_reset_outlined,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                const Text(
                  'ลืมรหัสผ่าน?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'กรุณากรอกอีเมลที่ใช้ลงทะเบียน เราจะส่งลิงก์สำหรับรีเซ็ตรหัสผ่านให้คุณ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (!_isSubmitted)
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'อีเมล',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'กรุณากรอกอีเมล';
                            }
                            if (!value.contains('@')) {
                              return 'กรุณากรอกอีเมลให้ถูกต้อง';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _resetPassword,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'ส่งลิงก์รีเซ็ตรหัสผ่าน',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 80,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'ส่งลิงก์ไปยังอีเมล ${_emailController.text} แล้ว',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'กรุณาตรวจสอบกล่องจดหมายของคุณและทำตามคำแนะนำในอีเมล',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        child: const Text(
                          'กลับไปยังหน้าเข้าสู่ระบบ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                if (!_isSubmitted)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('จำรหัสผ่านได้แล้ว?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                        },
                        child: const Text('เข้าสู่ระบบ'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
        onTap: (index) {
          if (index == 0) {
            // นำทางไปยัง FavoritesScreen เมื่อกดที่ Favorites
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DogBreedScreen(),
              ),
            );
          }
          if (index == 1) {
            // นำทางไปยัง FavoritesScreen เมื่อกดที่ Favorites
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => petsScreen(),
              ),
            );
          }
        },
        items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home_filled),
        label: 'หน้าหลัก',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.pets_outlined),
        activeIcon: Icon(Icons.pets),
        label: 'สัตว์เลี้ยง',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outlined),
        activeIcon: Icon(Icons.person),
        label: 'โปรไฟล์',
      ),
    ],
      ),
    );
  }
}
