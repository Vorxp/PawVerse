// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dog/LogRegForgot/CheckLogin.dart';
// import 'package:dog/PetScreen.dart';
// import 'package:flutter/material.dart';
// import 'AddDogScreen.dart';
// import 'BreedCard.dart';

// class DogBreedScreen extends StatefulWidget {
//   @override
//   _DogBreedScreenState createState() => _DogBreedScreenState();
// }

// class _DogBreedScreenState extends State<DogBreedScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "ระบบบัตรประจำตัวสัตว์เลี้ยง",
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.pinkAccent,
//         elevation: 10,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//         ),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('dogs').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('ไม่พบข้อมูลสัตว์เลี้ยง'));
//           }

//           final docs = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: docs.length,
//             itemBuilder: (context, index) {
//               final data = docs[index].data() as Map<String, dynamic>;

//               // ตรวจสอบ null และกำหนดค่าเริ่มต้น
//               final dateOfBirth =
//                   data['dateOfBirth'] != null
//                       ? (data['dateOfBirth'] as Timestamp).toDate()
//                       : DateTime(2000);

//               final dateOfIssue =
//                   data['dateOfIssue'] != null
//                       ? (data['dateOfIssue'] as Timestamp).toDate()
//                       : DateTime.now();

//               return BreedCard(
//                 idNumber: data['idNumber'] ?? '-',
//                 thaiName: data['thaiName'] ?? 'ไม่มีข้อมูล',
//                 englishName: data['englishName'] ?? 'No Data',
//                 dateOfBirth: dateOfBirth,
//                 breed: data['breed'] ?? 'ไม่ระบุสายพันธุ์',
//                 address: data['address'] ?? 'ไม่ระบุที่อยู่',
//                 dateOfIssue: dateOfIssue,
//                 imageUrl: data['imageUrl'] ?? '',
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed:
//             () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AddDogScreen()),
//             ),
//         child: Icon(Icons.add, size: 30),
//         backgroundColor: Colors.pinkAccent,
//         foregroundColor: Colors.white,
//       ),
//       bottomNavigationBar: _buildBottomNavBar(),
//     );
//   }
// BottomNavigationBar _buildBottomNavBar() {
//   return BottomNavigationBar(
//     currentIndex: 0,
//     selectedItemColor: Colors.pinkAccent,
//     unselectedItemColor: Colors.grey,
//     showSelectedLabels: false,
//     showUnselectedLabels: false,
//     elevation: 10,
//     items: [
//       BottomNavigationBarItem(
//         icon: Icon(Icons.home_outlined),
//         activeIcon: Icon(Icons.home_filled),
//         label: 'หน้าหลัก',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.pets_outlined),
//         activeIcon: Icon(Icons.pets),
//         label: 'สัตว์เลี้ยง',
//       ),
//       BottomNavigationBarItem(
//         icon: Icon(Icons.person_outlined),
//         activeIcon: Icon(Icons.person),
//         label: 'โปรไฟล์',
//       ),
//     ],
//     onTap: (index) {
//       if (index == 1) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => petsScreen()),
//         );
//       }
//       if (index == 2) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => CheckLogin()),
//         );
//       }
//     },
//   );
// }
// }