import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog/AddEditDel/Edit.dart';
import 'package:dog/LogRegForgot/CheckLogin.dart';
import 'package:dog/InGameScreen/PetScreen.dart';
import 'package:flutter/material.dart';
import 'package:dog/AddEditDel/AddDogScreen.dart';
import 'IDCard.dart';

class DogBreedScreen extends StatefulWidget {
  @override
  _DogBreedScreenState createState() => _DogBreedScreenState();
}

class _DogBreedScreenState extends State<DogBreedScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ระบบบัตรประจำตัวสัตว์เลี้ยง",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('dogs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('ไม่พบข้อมูลสัตว์เลี้ยง'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              // ตรวจสอบ null และกำหนดค่าเริ่มต้น
              final dateOfBirth =
                  data['dateOfBirth'] != null
                      ? (data['dateOfBirth'] as Timestamp).toDate()
                      : DateTime(2000);

              final dateOfIssue =
                  data['dateOfIssue'] != null
                      ? (data['dateOfIssue'] as Timestamp).toDate()
                      : DateTime.now();

              return BreedCard(
                idNumber: data['idNumber'] ?? '-',
                thaiName: data['thaiName'] ?? 'ไม่มีข้อมูล',
                englishName: data['englishName'] ?? 'No Data',
                dateOfBirth: dateOfBirth,
                breed: data['breed'] ?? 'ไม่ระบุสายพันธุ์',
                address: data['address'] ?? 'ไม่ระบุที่อยู่',
                dateOfIssue: dateOfIssue,
                imageUrl: data['imageUrl'] ?? '',
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Edit(docId: docs[index].id, data: data),
                    ),
                  );
                },
                onDelete: () {
                  _confirmDelete(docs[index].id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddDogScreen()),
            ),
        child: Icon(Icons.add, size: 30),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
        onTap: (index) {
          if (index == 1) {
            // นำทางไปยัง FavoritesScreen เมื่อกดที่ Favorites
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => petsScreen()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CheckLogin()),
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

  void _confirmDelete(String docId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('ยืนยันการลบ'),
            content: Text('คุณแน่ใจหรือไม่ว่าต้องการลบข้อมูลนี้?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก'),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('dogs')
                      .doc(docId)
                      .delete();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('ลบข้อมูลสำเร็จ'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                child: Text('ลบ', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
