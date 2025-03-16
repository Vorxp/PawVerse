import 'package:dog/LogRegForgot/Login.dart';
import 'package:dog/LogRegForgot/ProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // ผู้ใช้ล็อกอินอยู่ -> ไปหน้า Profile
            return ProfileScreen();
          } else {
            // ยังไม่ได้ล็อกอิน -> ไปหน้า Login
            return LoginScreen();
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
