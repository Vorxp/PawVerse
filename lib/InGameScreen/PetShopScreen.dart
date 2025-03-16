import 'package:dog/Model/pet.dart';
import 'package:flutter/material.dart';

// เพิ่ม PetShopScreen
class PetShopScreen extends StatelessWidget {
  final Pet pet;
  final Function updatePet;

  PetShopScreen({required this.pet, required this.updatePet});

  // ข้อมูลหมวดหมู่และรายการอาหาร
  final List<Map<String, dynamic>> categories = [
    {
      "name": "Doggy",
      "items": [
        {
          "name": "Doggy",
          "price": "120 บาท",
          "image": "IMG/doggy1.jpg",
          "description": "สูตรเนื้อแกะและข้าว สำหรับอายุ 1 ขึ้นขึ้นไป",
          "ingredients": ["เนื้อแกะ", "ข้าว", "วิตามิน", "เกลือแร่"],
        },
        {
          "name": "DOGGY Lyte",
          "price": "400 บาท",
          "image": "IMG/doggy_liver_01.jpg",
          "description":
              "ด๊อกกี้ ไลท์ กลิ่นตับ เกลือแร่ผสมวิตามิน ชนิดผงละลายน้ำ สำหรับ สุนัข (15g)",
          "ingredients": ["ตับ", "เกลือแร่", "วิตามิน", "สารละลายน้ำ"],
        },
      ],
    },
    {
      "name": "Ostech",
      "items": [
        {
          "name": "Ostech",
          "price": "400 บาท",
          "image": "IMG/Ostech.jpg",
          "description": "อาหารสุนัขสูตรพิเศษ",
          "ingredients": ["เนื้อไก่", "ข้าว", "แคลเซียม", "วิตามิน"],
        },
      ],
    },
     {
      "name": "ACANA",
      "items": [
        {
          "name": "ACANA-1",
          "price": "200 บาท",
          "image": "IMG/acana1.jpg",
          "description": "อาหารสุนัขสูตรพิเศษ",
          "ingredients": ["เนื้อไก่", "ข้าว", "แคลเซียม", "วิตามิน"],
        },
        {
          "name": "ACANA-2",
          "price": "300 บาท",
          "image": "IMG/acana2.png",
          "description": "อาหารสุนัขสูตรพิเศษ",
          "ingredients": ["เนื้อไก่", "ข้าว", "แคลเซียม", "วิตามิน"],
        },
      ],
      
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          "Pet Shop",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.pinkAccent.withOpacity(0.1),
              Colors.pinkAccent.withOpacity(0.05),
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            final category = categories[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // หัวข้อหมวดหมู่
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    category["name"],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                ),
                // รายการอาหารในหมวดหมู่
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: category["items"].length,
                  itemBuilder: (BuildContext context, int itemIndex) {
                    final item = category["items"][itemIndex];
                    return GestureDetector(
                      onTap: () {
                        _showIngredientsDialog(context, item);
                      },
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // รูปภาพอาหาร
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  item["image"],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 16),
                              // ชื่ออาหารและรายละเอียด
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["name"],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      item["description"],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      item["price"],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // ปุ่มซื้อ
                              ElevatedButton(
                                onPressed: () {
                                  _showPurchaseDialog(context, item["name"]);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text("ซื้อ"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showIngredientsDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ส่วนประกอบของ ${item["name"]}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ส่วนประกอบ:"),
              SizedBox(height: 8),
              ...item["ingredients"].map<Widget>((ingredient) {
                return Text("- $ingredient");
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("ปิด"),
            ),
          ],
        );
      },
    );
  }
}

// แสดง Dialog เมื่อกดซื้อ
void _showPurchaseDialog(BuildContext context, String itemName) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("ซื้อ $itemName"),
      content: Text("คุณต้องการซื้อ $itemName ใช่หรือไม่?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("ยกเลิก"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("ซื้อ $itemName สำเร็จ!"),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Text("ยืนยัน"),
        ),
      ],
    ),
  );
}