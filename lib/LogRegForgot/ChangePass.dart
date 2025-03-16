import 'package:dog/LogRegForgot/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dog/Service/AuthService.dart';


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _authService.currentUser;
      
      if (user != null && user.email != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text.trim(),
        );
        
        await user.reauthenticateWithCredential(credential);
        
        await user.updatePassword(_newPasswordController.text.trim());
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('เปลี่ยนรหัสผ่านสำเร็จ'),
              backgroundColor: Colors.green,
            ),
          );
          
          await _authService.signOut();
          Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'เกิดข้อผิดพลาดในการเปลี่ยนรหัสผ่าน';
      
      if (e.code == 'wrong-password') {
        errorMessage = 'รหัสผ่านปัจจุบันไม่ถูกต้อง';
      } else if (e.code == 'weak-password') {
        errorMessage = 'รหัสผ่านใหม่ไม่รัดกุมเพียงพอ';
      } else if (e.code == 'requires-recent-login') {
        errorMessage = 'กรุณาเข้าสู่ระบบใหม่อีกครั้งก่อนดำเนินการนี้';
        await _authService.signOut();
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
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
        title: const Text(
          "เปลี่ยนรหัสผ่าน",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.pinkAccent.withOpacity(0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
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
                  color: Colors.pinkAccent,
                ),
                const SizedBox(height: 16),
                const Text(
                  'เปลี่ยนรหัสผ่าน',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'กรุณากรอกรหัสผ่านปัจจุบันและรหัสผ่านใหม่ที่ต้องการเปลี่ยน',
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
        controller: _currentPasswordController,
        obscureText: _obscureCurrentPassword,
        decoration: InputDecoration(
          hintText: 'รหัสผ่านปัจจุบัน',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureCurrentPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            ),
            onPressed: () {
              setState(() {
                _obscureCurrentPassword = !_obscureCurrentPassword;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณากรอกรหัสผ่านปัจจุบัน';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      
      TextFormField(
        controller: _newPasswordController,
        obscureText: _obscureNewPassword,
        decoration: InputDecoration(
          hintText: 'รหัสผ่านใหม่',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureNewPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            ),
            onPressed: () {
              setState(() {
                _obscureNewPassword = !_obscureNewPassword;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณากรอกรหัสผ่านใหม่';
          }
          if (value.length < 6) {
            return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
          }
          if (value == _currentPasswordController.text) {
            return 'รหัสผ่านใหม่ต้องไม่ซ้ำกับรหัสผ่านปัจจุบัน';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      
      TextFormField(
        controller: _confirmPasswordController,
        obscureText: _obscureConfirmPassword,
        decoration: InputDecoration(
          hintText: 'ยืนยันรหัสผ่านใหม่',
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'กรุณายืนยันรหัสผ่านใหม่';
          }
          if (value != _newPasswordController.text) {
            return 'รหัสผ่านไม่ตรงกัน';
          }
          return null;
        },
      ),
      const SizedBox(height: 32),
      
      ElevatedButton(
        onPressed: _isLoading ? null : _changePassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'เปลี่ยนรหัสผ่าน',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    ],
  ),
),
              ],
            ),
          ),
        ),
      ),
    );
  }
}