import 'dart:async';
import 'dart:math';

import 'package:dog/InGameScreen/EnhancedFeedingGameScreen.dart';
import 'package:dog/InGameScreen/PetShopScreen.dart';
import 'package:dog/Model/pet.dart';
import 'package:flutter/material.dart';

// ปรับปรุงหน้า PetDetailScreen ให้ดีขึ้น
class PetDetailScreen extends StatefulWidget {
  final String breedName;
  final String imagePath;

  PetDetailScreen({required this.breedName, required this.imagePath});

  @override
  _PetDetailScreenState createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  late Pet pet;
  late Timer timer;
  bool showNameDialog = true;
  String petName = "";

  @override
  void initState() {
    super.initState();
    pet = Pet(name: "Unnamed", breed: widget.breedName);

    // Timer สำหรับลดค่าความหิวและพลังงานตามเวลา
    timer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        if (pet.hunger < 95) pet.hunger += 5;
        if (pet.energy > 5) pet.energy -= 5;
        if (pet.hunger > 80) pet.health -= 2;
        if (pet.hunger > 90) pet.happiness -= 5;
      });
    });

    // แสดงกล่องให้ตั้งชื่อสัตว์เลี้ยง
    Future.delayed(Duration.zero, () {
      _showNameInputDialog(context);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // กล่องให้ตั้งชื่อสัตว์เลี้ยง
  Future<void> _showNameInputDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ตั้งชื่อน้อง${widget.breedName} ของคุณ'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: "ชื่อสัตว์เลี้ยง"),
            onChanged: (value) {
              petName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ตกลง'),
              onPressed: () {
                setState(() {
                  pet.name = petName.isEmpty ? "Unknown Name" : petName;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text("Pet: ${pet.name}"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PetShopScreen(
                        pet: pet, updatePet: () => setState(() {}))),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.stars, color: Colors.amber),
                          SizedBox(width: 4),
                          Text("Level ${pet.level}",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet.name,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "สถานะโดยรวม: ${pet.overallStatus}%",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(pet.overallStatus),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "สายพันธุ์: ${pet.breed}",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 10),
                  // แสดง XP bar
                  Container(
                    width: double.infinity,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        FractionallySizedBox(
                          widthFactor: pet.experience / 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "XP: ${pet.experience}/100",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // ส่วนแสดงสถานะต่างๆ
                  Text("สถานะของ ${pet.name}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  // สร้าง Status bars
                  _buildStatusBar("ความสุข", pet.happiness, Colors.pink),
                  SizedBox(height: 8),
                  _buildStatusBar("ความหิว", pet.hunger, Colors.orange,
                      inverse: true),
                  SizedBox(height: 8),
                  _buildStatusBar("สุขภาพ", pet.health, Colors.green),
                  SizedBox(height: 8),
                  _buildStatusBar("พลังงาน", pet.energy, Colors.blue),
                  SizedBox(height: 20),
                  // ปุ่มกิจกรรมต่างๆ
                  Text("กิจกรรม",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActivityButton(
                        icon: Icons.restaurant,
                        label: "ให้อาหาร",
                        color: Colors.orange,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EnhancedFeedingGameScreen(
                                pet: pet,
                                onGameComplete: () {
                                  setState(() {});
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      _buildActivityButton(
                        icon: Icons.healing,
                        label: "รักษา",
                        color: Colors.red,
                        onPressed: () {
                          _healPet();
                        },
                      ),
                      _buildActivityButton(
                        icon: Icons.night_shelter,
                        label: "นอน",
                        color: Colors.indigo,
                        onPressed: () {
                          _sleepPet();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // แสดงประวัติกิจกรรม
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "เคล็ดลับการดูแล",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "• ให้อาหารเมื่อความหิวมากกว่า 50%\n"
                            "• ให้นอนเมื่อพลังงานต่ำกว่า 30%\n"
                            "• รักษาเมื่อสุขภาพต่ำกว่า 50%",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชั่นแสดงสีตามสถานะ
  Color _getStatusColor(int value) {
    if (value >= 80) return Colors.green;
    if (value >= 50) return Colors.orange;
    return Colors.red;
  }

  // สร้าง status bar สำหรับแสดงค่าต่างๆ
  Widget _buildStatusBar(String label, int value, Color color,
      {bool inverse = false}) {
    // ถ้า inverse=true จะแสดงค่ากลับด้าน (เช่น ความหิว ค่ามากคือไม่ดี)
    final displayValue = inverse ? 100 - value : value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            Text("$displayValue%"),
          ],
        ),
        SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: displayValue / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // สร้างปุ่มกิจกรรม
  Widget _buildActivityButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: CircleBorder(),
            padding: EdgeInsets.all(16),
          ),
          onPressed: onPressed,
          child: Icon(icon, size: 30),
        ),
        SizedBox(height: 4),
        Text(label),
      ],
    );
  }

  // ฟังก์ชันรักษา
  void _healPet() {
    if (pet.health >= 95) {
      _showMessage("${pet.name} มีสุขภาพดีอยู่แล้ว!");
      return;
    }

    setState(() {
      pet.health = min(100, pet.health + 20);
      pet.happiness = min(100, pet.happiness + 5);
      pet.addExperience(5);
    });

    _showMessage("คุณได้ดูแลสุขภาพของ ${pet.name} แล้ว!");
  }

  // ฟังก์ชันให้นอน
  void _sleepPet() {
    if (pet.energy >= 95) {
      _showMessage("${pet.name} ไม่ง่วงเลย!");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("${pet.name} กำลังนอน..."),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("IMG/${widget.breedName}.png", height: 100),
              SizedBox(height: 16),
              Text("Zzz... Zzz..."),
              SizedBox(height: 16),
              LinearProgressIndicator(),
            ],
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
      setState(() {
        pet.energy = 100;
        pet.health = min(100, pet.health + 10);
        pet.addExperience(5);
      });
      _showMessage("${pet.name} รู้สึกสดชื่นมาก!");
    });
  }

  // แสดงข้อความแจ้งเตือน
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}