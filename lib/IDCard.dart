import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dog/IDCardInfo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BreedCard extends StatelessWidget {
  final String idNumber;
  final String thaiName;
  final String englishName;
  final DateTime dateOfBirth;
  final String breed;
  final String address;
  final DateTime dateOfIssue;
  final String imageUrl;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BreedCard({
    Key? key,
    required this.idNumber,
    required this.thaiName,
    required this.englishName,
    required this.dateOfBirth,
    required this.breed,
    required this.address,
    required this.dateOfIssue,
    required this.imageUrl,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
          child: imageUrl.isEmpty ? Icon(Icons.pets) : null,
        ),
        title: Text('$thaiName ($englishName)'),
        subtitle: Text('สายพันธุ์: $breed\nเลขประจำตัว: $idNumber'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DogIDCard(
                dogData: {
                  'idNumber': idNumber,
                  'thaiName': thaiName,
                  'englishName': englishName,
                  'dateOfBirth': Timestamp.fromDate(dateOfBirth), // แปลงเป็น Timestamp
                  'breed': breed,
                  'address': address,
                  'dateOfIssue': Timestamp.fromDate(dateOfIssue), // แปลงเป็น Timestamp
                  'imageUrl': imageUrl,
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
