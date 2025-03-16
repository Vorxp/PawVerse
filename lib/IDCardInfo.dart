import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DogIDCard extends StatelessWidget {
  final Map<String, dynamic> dogData;

  const DogIDCard({required this.dogData});

  @override
  Widget build(BuildContext context) {
    // จัดการกับวันที่ให้ถูกต้อง
    final DateTime birthDate = dogData['dateOfBirth'] is Timestamp 
        ? dogData['dateOfBirth'].toDate() 
        : dogData['dateOfBirth'];
    
    final DateTime issueDate = dogData['dateOfIssue'] is Timestamp 
        ? dogData['dateOfIssue'].toDate() 
        : dogData['dateOfIssue'];

    return Scaffold(
      appBar: AppBar(
        title: Text('บัตรประจำตัวสัตว์เลี้ยง'),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
              ),
            ],
          ),
          child: Column(
            children: [
              // ส่วนหัว
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pinkAccent, Colors.purpleAccent],
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                padding: EdgeInsets.all(15),
                child: Row(
                  children: [
                    Icon(Icons.pets, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'บัตรประจำตัวสัตว์เลี้ยง',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // รูปสัตว์เลี้ยง (ถ้ามี)
              if (dogData['imageUrl'] != null && dogData['imageUrl'].isNotEmpty)
                Padding(
                  padding: EdgeInsets.all(15),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(dogData['imageUrl']),

                  ),
                ),

              // เนื้อหา
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('เลขประจำตัวสัตว์เลี้ยง', dogData['idNumber']),
                    _buildInfoRow('ชื่อไทย', dogData['thaiName']),
                    _buildInfoRow('ชื่ออังกฤษ', dogData['englishName']),
                    
                    Table(
                      columnWidths: {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
                      children: [
                        _buildTableRow('วันเกิด', DateFormat('dd/MM/yyyy').format(birthDate)),
                        _buildTableRow('สายพันธุ์', dogData['breed']),
                        _buildTableRow('ที่อยู่', dogData['address']),
                      ],
                    ),

                    SizedBox(height: 20),
                    Divider(),
                    
                    // ส่วน QR Code
                    Center(
                      child: QrImageView(
                        data: 'https://petdy.jaytnw.com/${dogData['idNumber']}',
                        version: QrVersions.auto,
                        size: 150,
                      ),
                    ),

                    SizedBox(height: 10),
                    _buildInfoRow('ออกเมื่อ', DateFormat('dd/MM/yyyy').format(issueDate)),
                    _buildInfoRow('หมดอายุ', 'ตลอดชีพ'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(label),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(value),
        ),
      ],
    );
  }
}