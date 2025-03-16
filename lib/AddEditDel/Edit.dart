import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Edit extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const Edit({Key? key, required this.docId, required this.data}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _thaiNameController;
  late TextEditingController _englishNameController;
  late TextEditingController _addressController;
  late TextEditingController _imageUrlController;
  DateTime? _dateOfBirth;
  String _selectedBreed = 'อื่นๆ';

  @override
  void initState() {
    super.initState();
    _thaiNameController = TextEditingController(text: widget.data['thaiName']);
    _englishNameController = TextEditingController(text: widget.data['englishName']);
    _addressController = TextEditingController(text: widget.data['address']);
    _imageUrlController = TextEditingController(text: widget.data['imageUrl']);
    _dateOfBirth = (widget.data['dateOfBirth'] as Timestamp).toDate();
    _selectedBreed = widget.data['breed'];
  }

  Future<void> _updateData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('dogs').doc(widget.docId).update({
          'thaiName': _thaiNameController.text,
          'englishName': _englishNameController.text,
          'dateOfBirth': Timestamp.fromDate(_dateOfBirth!),
          'breed': _selectedBreed,
          'address': _addressController.text,
          'imageUrl': _imageUrlController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('อัปเดตข้อมูลสำเร็จ'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลสัตว์เลี้ยง'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('ชื่อไทย', _thaiNameController),
              _buildTextField('ชื่ออังกฤษ', _englishNameController),
              _buildTextField('ที่อยู่', _addressController, maxLines: 3),
              _buildTextField('URL รูปภาพ', _imageUrlController),
              _buildDateField('วันเกิด', _dateOfBirth, (date) {
                setState(() {
                  _dateOfBirth = date;
                });
              }),
              _buildReadOnlyField('วันออกบัตร', DateFormat('dd/MM/yyyy').format(widget.data['dateOfIssue'].toDate())),
              ElevatedButton(
                onPressed: _updateData,
                child: Text('บันทึกการแก้ไข'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกข้อมูล' : null,
      ),
    );
  }

  Widget _buildDateField(String label, DateTime? date, Function(DateTime) onPicked) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(context: context, initialDate: date ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
          if (picked != null) onPicked(picked);
        },
        child: InputDecorator(decoration: InputDecoration(labelText: label, border: OutlineInputBorder()), child: Text(date != null ? DateFormat('dd/MM/yyyy').format(date) : 'เลือกวันที่')),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(padding: EdgeInsets.only(bottom: 15), child: InputDecorator(decoration: InputDecoration(labelText: label, border: OutlineInputBorder()), child: Text(value)));
  }
}
