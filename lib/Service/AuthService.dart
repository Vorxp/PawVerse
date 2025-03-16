
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // สร้างฟังก์ชันสำหรับ Login ด้วยอีเมลและรหัสผ่าน
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // สร้างฟังก์ชันสำหรับ Register ด้วยอีเมลและรหัสผ่าน
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // สร้างฟังก์ชันสำหรับ Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // สร้างฟังก์ชันสำหรับตรวจสอบสถานะการล็อกอิน
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // สร้างฟังก์ชันสำหรับ Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ดึงข้อมูลผู้ใช้ปัจจุบัน
  User? get currentUser => _auth.currentUser;

  // อัปเดตข้อมูลผู้ใช้
  Future<void> updateUserDisplayName(String displayName) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
    } catch (e) {
      rethrow;
    }
  }
}