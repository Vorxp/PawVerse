import 'package:dog/Dogbreed.dart';
import 'package:dog/LogRegForgot/ForgotPass.dart';
import 'package:dog/LogRegForgot/ProfileScreen.dart';
import 'package:dog/LogRegForgot/Regis.dart';
import 'package:dog/InGameScreen/PetScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dog/Service/AuthService.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _authService.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';
        
        if (e.code == 'user-not-found') {
          errorMessage = 'ไม่พบอีเมลนี้ในระบบ';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'รหัสผ่านไม่ถูกต้อง';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'รูปแบบอีเมลไม่ถูกต้อง';
        } else if (e.code == 'user-disabled') {
          errorMessage = 'บัญชีนี้ถูกระงับการใช้งาน';
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('เกิดข้อผิดพลาด: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
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
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Welcome",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.favorite, color: Colors.red,),
          ],
        ),
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.pinkAccent.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                const Text(
                  'ยินดีต้อนรับ!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'กรุณาเข้าสู่ระบบเพื่อใช้งาน',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'รหัสผ่าน',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText 
                                ? Icons.visibility_off_outlined 
                                : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน';
                          }
                          if (value.length < 6) {
                            return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPass()));
                          },
                          child: const Text('ลืมรหัสผ่าน?'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'เข้าสู่ระบบ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('ยังไม่มีบัญชีใช่ไหม?'),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                            },
                            child: const Text('สมัครสมาชิก'),
                          ),
                        ],
                      ),
                    ],
                  ),
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