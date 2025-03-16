import 'dart:async';
import 'dart:math';

import 'package:dog/Model/Food.dart';
import 'package:dog/Model/pet.dart';
import 'package:flutter/material.dart';

// เกมให้อาหารที่ปรับปรุงแล้ว
class EnhancedFeedingGameScreen extends StatefulWidget {
  final Pet pet;
  final Function onGameComplete;

  EnhancedFeedingGameScreen({required this.pet, required this.onGameComplete});

  @override
  _EnhancedFeedingGameScreenState createState() =>
      _EnhancedFeedingGameScreenState();
}

class _EnhancedFeedingGameScreenState extends State<EnhancedFeedingGameScreen> {
  int foodEaten = 0;
  int score = 0;
  int timeLeft = 30;
  bool isGameActive = false;
  List<Food> foods = [];
  Timer? gameTimer;

  // รายการอาหาร
  final List<Map<String, dynamic>> foodItems = [
    {"name": "Bone", "points": 10, "color": Colors.brown},
    {"name": "Meat", "points": 15, "color": Colors.redAccent},
    {"name": "Kibble", "points": 5, "color": Colors.orange},
    {"name": "Treat", "points": 20, "color": Colors.amber},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void startGame() {
    setState(() {
      isGameActive = true;
      foodEaten = 0;
      score = 0;
      timeLeft = 30;
      foods = [];
    });

    // เริ่มนับเวลาถอยหลัง
    gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
          // สร้างอาหารใหม่ทุกๆ 2 วินาที
          if (timeLeft % 2 == 0) {
            _spawnFood();
          }
        } else {
          timer.cancel();
          _endGame();
        }
      });
    });
  }

  void _spawnFood() {
    final random = Random();
  final foodItem = foodItems[random.nextInt(foodItems.length)];
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

    setState(() {
    foods.add(
      Food(
        name: foodItem["name"],
        points: foodItem["points"],
        color: foodItem["color"],
        position: Offset(
          20.0 + random.nextDouble() * (screenWidth - 120),
          // เริ่มจากความสูง 100px ถึง 70% ของหน้าจอ
          100 + random.nextDouble() * (screenHeight * 0.7 - 100),
        ),
      ),
    );
  });
  }

  void _collectFood(Food food) {
    setState(() {
      foods.remove(food);
      foodEaten++;
      score += food.points;
    });
  }

  void _endGame() {
    // คำนวณผลลัพธ์
    final hungerReduction = min(score ~/ 5, 100); // ลดความหิวตามคะแนน
    final happinessIncrease = min(score ~/ 10, 30); // เพิ่มความสุขตามคะแนน

    setState(() {
      isGameActive = false;
      // ปรับค่าสถานะสัตว์เลี้ยง
      widget.pet.hunger = max(0, widget.pet.hunger - hungerReduction);
      widget.pet.happiness = min(100, widget.pet.happiness + happinessIncrease);
      widget.pet.addExperience(
          min(score ~/ 5, 20)); // เพิ่ม XP ตามคะแนน แต่ไม่เกิน 20
    });

    // แสดงผลการเล่น
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("เกมจบแล้ว!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("คะแนน: $score"),
            Text("อาหารที่เก็บได้: $foodEaten ชิ้น"),
            SizedBox(height: 10),
            Text("ความหิวลดลง: $hungerReduction%"),
            Text("ความสุขเพิ่มขึ้น: $happinessIncrease%"),
            Text("ได้รับ XP: ${min(score ~/ 5, 20)}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onGameComplete();
            },
            child: Text("กลับ"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              startGame();
            },
            child: Text("เล่นอีกครั้ง"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text("ให้อาหาร ${widget.pet.name}"),
        centerTitle: true,
      ),
      body: isGameActive
          ? Stack(
              children: [
                // พื้นหลัง
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.lightBlue[100]!, Colors.white],
                    ),
                  ),
                ),
                // สัตว์เลี้ยงอยู่ด้านล่าง
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      "IMG/${widget.pet.breed}.png",
                      height: 120,
                    ),
                  ),
                ),
                // อาหารที่ลอยลงมา
                // แถบแสดงสถานะเกม (คะแนน, เวลา)
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("คะแนน",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("$score", style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("เวลา",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("$timeLeft วินาที",
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        Column(
                          children: [
                            Text("อาหาร",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("$foodEaten ชิ้น",
                                style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ...foods.map((food) {
                  return Positioned(
                      left: food.position.dx,
                      top: food.position.dy,
                      child: GestureDetector(
                        onTap: () => _collectFood(food),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: food.color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              food.name[0],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ));
                }).toList(),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("IMG/${widget.pet.breed}.png", height: 150),
                  SizedBox(height: 20),
                  Text(
                    "${widget.pet.name} กำลังรอรับอาหาร",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "วิธีเล่น: แตะที่อาหารที่กำลังตกลงมาให้ได้มากที่สุด\nภายในเวลา 30 วินาที",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    onPressed: startGame,
                    child: Text(
                      "เริ่มเกม",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}