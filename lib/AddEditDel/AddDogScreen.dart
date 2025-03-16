import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddDogScreen extends StatefulWidget {
  @override
  _AddDogScreenState createState() => _AddDogScreenState();
}

class _AddDogScreenState extends State<AddDogScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _thaiNameController = TextEditingController();
  final TextEditingController _otherBreedController = TextEditingController();
  final TextEditingController _englishNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _imageUrlController =
      TextEditingController(); // 🆕 เพิ่มช่องกรอก URL
  DateTime? _dateOfBirth;
  DateTime? _dateOfIssue;
  String _idNumber = '';
  String _selectedBreed = 'Golden Retriever';

  final List<String> _breeds = [
    'Golden Retriever',
    'Labrador Retriever',
    'Pomeranian',
    'Poodle',
    'Chihuahua',
    'Shih Tzu',
    'French Bulldog',
    'Corgi',
    'Beagle',
    'Dachshund',
    'German Shepherd',
    'Rottweiler',
    'Doberman Pinscher',
    'ไทยหลังอาน',
    'Siberian Husky',
    'Samoyed',
    'Cavalier King Charles Spaniel',
    'Maltese',
    'Bichon Frise',
    'Border Collie',
  ];

  @override
  void initState() {
    super.initState();
    _dateOfIssue = DateTime.now();
    _generateID();
  }

  String _generateID() {
    final random = Random().nextInt(999999999);
    final now = DateTime.now();
    setState(() {
      _idNumber =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${random.toString().padLeft(9, '0')}';
    });
    return _idNumber;
  }

  Future<void> _selectDate(BuildContext context, bool isBirthDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        if (isBirthDate) {
          _dateOfBirth = picked;
          _generateID();
        } else {
          _dateOfIssue = picked;
        }
      });
    }
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('dogs').add({
          'thaiName': _thaiNameController.text,
          'englishName': _englishNameController.text,
          'dateOfBirth': Timestamp.fromDate(_dateOfBirth!),
          'dateOfIssue': Timestamp.fromDate(_dateOfIssue!),
          'idNumber': _idNumber,
          'breed':
              _selectedBreed == 'อื่นๆ'
                  ? _otherBreedController.text
                  : _selectedBreed,

          'address': _addressController.text,
          'imageUrl': _imageUrlController.text, // 🆕 บันทึก URL ของรูป
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('บันทึกข้อมูลสัตว์เลี้ยงเรียบร้อยแล้ว'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาด: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ออกบัตรประจำตัวสัตว์เลี้ยง',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pinkAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ส่วนรูปภาพจาก URL
              _imageUrlController.text.isNotEmpty
                  ? CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.pinkAccent.shade100,
                    backgroundImage: NetworkImage(_imageUrlController.text),
                  )
                  : CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.pinkAccent.shade100,
                    child: Icon(Icons.pets, size: 40, color: Colors.white),
                  ),
              SizedBox(height: 20),

              // ช่องกรอก URL รูป
              _buildTextField(
                label: 'URL รูปภาพ',
                controller: _imageUrlController,
                icon: Icons.image,
              ),

              // ชื่อไทย
              _buildTextField(
                label: 'ชื่อไทย',
                controller: _thaiNameController,
                icon: Icons.person,
              ),

              // ชื่ออังกฤษ
              _buildTextField(
                label: 'ชื่ออังกฤษ',
                controller: _englishNameController,
                icon: Icons.translate,
              ),

              // วันเกิด
              _buildDateField(
                label: 'วันเกิด',
                date: _dateOfBirth,
                onTap: () => _selectDate(context, true),
              ),

              // วันออกบัตร
              _buildDateField(
                label: 'วันออกบัตร',
                date: _dateOfIssue,
                onTap: () => _selectDate(context, false),
              ),

              // เลขประจำตัว
              _buildReadOnlyField(
                label: 'เลขประจำตัว',
                value: _idNumber,
                icon: Icons.numbers,
              ),

              // ที่อยู่
              _buildTextField(
                label: 'ที่อยู่',
                controller: _addressController,
                icon: Icons.location_on,
                maxLines: 3,
              ),

              // สายพันธุ์
              DropdownButtonFormField<String>(
                value: _selectedBreed,
                decoration: InputDecoration(
                  labelText: 'สายพันธุ์',
                  prefixIcon: Icon(Icons.pets),
                  border: OutlineInputBorder(),
                ),

                items: [
                  ..._breeds.map((breed) {
                    return DropdownMenuItem(value: breed, child: Text(breed));
                  }).toList(),
                  DropdownMenuItem(value: 'อื่นๆ', child: Text('อื่นๆ')),
                ],
                onChanged: (value) => setState(() => _selectedBreed = value!),
              ),

              SizedBox(height: 30),
              if (_selectedBreed == 'อื่นๆ')
                _buildTextField(
                  label: 'กรอกสายพันธุ์เอง',
                  controller: _otherBreedController,
                  icon: Icons.pets,
                ),
              // QR Code Preview
              if (_idNumber.isNotEmpty)
                Column(
                  children: [
                    Text(
                      'ตัวอย่าง QR Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    QrImageView(
                      data: 'PET-ID:$_idNumber',
                      version: QrVersions.auto,
                      size: 150,
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),

              SizedBox(height: 30),

              // ปุ่มบันทึก
              ElevatedButton.icon(
                onPressed: _saveData,
                icon: Icon(Icons.save),
                label: Text('บันทึกข้อมูล'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTextField({
  required String label,
  required TextEditingController controller,
  required IconData icon,
  int maxLines = 1,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 15),
    child: TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pinkAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'กรุณากรอกข้อมูล';
        }
        return null;
      },
    ),
  );
}

Widget _buildDateField({
  required String label,
  required DateTime? date,
  required VoidCallback onTap,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 15),
    child: InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.calendar_today, color: Colors.pinkAccent),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Row(
          children: [
            Text(
              date != null
                  ? DateFormat('dd/MM/yyyy').format(date)
                  : 'เลือกวันที่',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildReadOnlyField({
  required String label,
  required String value,
  required IconData icon,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 15),
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pinkAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        children: [
          Text(
            value.isEmpty ? 'รอการสร้างอัตโนมัติ' : value,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    ),
  );
}
