import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // เพิ่มข้อมูลสุนัขใน Firestore
  Future<DocumentReference> addDog(Map<String, dynamic> dogData) async {
    try {
      return await _firestore.collection('dogs').add(dogData);
    } catch (e) {
      throw Exception('ไม่สามารถเพิ่มข้อมูลสุนัขได้: $e');
    }
  }

  // ดึงข้อมูลสุนัขทั้งหมด
  Stream<QuerySnapshot> getDogs() {
    return _firestore.collection('dogs').snapshots();
  }

  // ดึงข้อมูลสุนัขตาม ID
  Future<DocumentSnapshot> getDogById(String id) {
    return _firestore.collection('dogs').doc(id).get();
  }

  // อัปเดตข้อมูลสุนัข
  Future<void> updateDog(String id, Map<String, dynamic> dogData) {
    return _firestore.collection('dogs').doc(id).update(dogData);
  }

  // ลบข้อมูลสุนัข
  Future<void> deleteDog(String id) {
    return _firestore.collection('dogs').doc(id).delete();
  }
}

