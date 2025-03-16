import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dog/Service/AuthService.dart';
import 'package:dog/Dogbreed.dart';
import 'package:dog/LogRegForgot/ChangePass.dart';
import 'package:dog/LogRegForgot/Login.dart';
import 'package:dog/InGameScreen/PetScreen.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  User? user;
  bool _isLoading = false;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    user = _authService.currentUser;
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการออกจากระบบ: $e'),
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

  @override
  Widget build(BuildContext context) {
    Color primaryColor = _isDarkMode ? Colors.pink[300]! : Colors.pinkAccent;
    Color backgroundColor = _isDarkMode ? Color(0xFF121212) : Colors.white;
    Color cardColor = _isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    Color textColor = _isDarkMode ? Colors.white : Colors.black;
    Color subtitleColor = _isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isDarkMode = !_isDarkMode;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Hero(
                        tag: 'profile-image',
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _getInitials(user?.displayName ?? 'User'),
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        user?.displayName ?? 'ผู้ใช้',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 150, 106, 190),
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ข้อมูลส่วนตัว",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 15),
                    Card(
                      elevation: 4,
                      color: cardColor,
                      shadowColor: primaryColor.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildInfoItem(
                              Icons.email_outlined,
                              'Email',
                              user?.email ?? 'ไม่ระบุอีเมล',
                              textColor,
                              subtitleColor,
                              primaryColor,
                            ),
                            Divider(color: subtitleColor.withOpacity(0.3)),
                            _buildInfoItem(
                              Icons.calendar_today_outlined,
                              'สร้างเมื่อ (GMT+0)',
                              _formatDate(user?.metadata.creationTime),
                              textColor,
                              subtitleColor,
                              primaryColor,
                            ),
                            Divider(color: subtitleColor.withOpacity(0.3)),
                            _buildInfoItem(
                              Icons.login_outlined,
                              'เข้าสู่ระบบล่าสุด (GMT+0)',
                              _formatDate(user?.metadata.lastSignInTime),
                              textColor,
                              subtitleColor,
                              primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "การตั้งค่า",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 15),
                    Card(
                      elevation: 4,
                      color: cardColor,
                      shadowColor: primaryColor.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          _buildSettingItem(
                            Icons.lock_reset_outlined,
                            'เปลี่ยนรหัสผ่าน',
                            'ปรับปรุงความปลอดภัยของบัญชี',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const ChangePasswordScreen(),
                                ),
                              );
                            },
                            textColor,
                            subtitleColor,
                            primaryColor,
                          ),
                          Divider(
                            color: subtitleColor.withOpacity(0.3),
                            height: 1,
                          ),
                          _buildSettingItem(
                            Icons.notifications_outlined,
                            'การแจ้งเตือน',
                            'จัดการการแจ้งเตือนแอปพลิเคชัน',
                            () {
                              // Navigate to notification settings
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('จะมีเพิ่มในอนาคต'),
                                  backgroundColor: primaryColor,
                                ),
                              );
                            },
                            textColor,
                            subtitleColor,
                            primaryColor,
                          ),
                          Divider(
                            color: subtitleColor.withOpacity(0.3),
                            height: 1,
                          ),
                          _buildSettingItem(
                            Icons.language_outlined,
                            'ภาษา',
                            'Thai / English',
                            () {
                              // Navigate to language settings
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('จะมีเพิ่มในอนาคต'),
                                  backgroundColor: primaryColor,
                                ),
                              );
                            },
                            textColor,
                            subtitleColor,
                            primaryColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Card(
                      elevation: 4,
                      color: cardColor,
                      shadowColor: primaryColor.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: _buildSettingItem(
                        Icons.support_outlined,
                        'ความช่วยเหลือและการสนับสนุน',
                        'ติดต่อเราหรือเยี่ยมชมศูนย์ช่วยเหลือ',
                        () {
                          // Navigate to help center
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('จะมีเพิ่มในอนาคต'),
                              backgroundColor: primaryColor,
                            ),
                          );
                        },
                        textColor,
                        subtitleColor,
                        primaryColor,
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _signOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isDarkMode ? Colors.pink[800] : primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 15,
                        ),
                        minimumSize: Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon:
                          _isLoading
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Icon(Icons.logout, size: 24),
                      label: Text(
                        _isLoading ? 'กำลังออกจากระบบ...' : 'ออกจากระบบ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            selectedItemColor: primaryColor,
            unselectedItemColor: subtitleColor,
            currentIndex: 2,
            type: BottomNavigationBarType.fixed,
            backgroundColor: cardColor,
            elevation: 0,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(fontSize: 12),
            iconSize: 26,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DogBreedScreen()),
                );
              }
              if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => petsScreen()),
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
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    Color textColor,
    Color subtitleColor,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: subtitleColor),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
    Color textColor,
    Color subtitleColor,
    Color iconColor,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: subtitleColor),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: subtitleColor),
          ],
        ),
      ),
    );
  }

  String _getInitials(String fullName) {
    List<String> names = fullName.split(' ');
    String initials = '';

    if (names.isNotEmpty) {
      if (names.length > 1) {
        initials = names[0][0] + names[1][0];
      } else {
        initials = names[0][0];
      }
    }

    return initials.toUpperCase();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'ไม่พบข้อมูล';

    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    String hour = date.hour.toString().padLeft(2, '0');
    String minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }
}
