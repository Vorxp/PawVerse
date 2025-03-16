import 'package:dog/Dogbreed.dart';
import 'package:dog/LogRegForgot/CheckLogin.dart';
import 'package:dog/InGameScreen/PetDetailScreen.dart';
import 'package:flutter/material.dart';

class petsScreen extends StatelessWidget {
  final List<Map<String, String>> breeds = [
    {"name": "Corgi", "icon": "IMG/Corgi.png"},
    {"name": "Poodle", "icon": "IMG/Poodle.png"},
    {"name": "Pug", "icon": "IMG/Pug.png"},
    {"name": "SiberianHusky", "icon": "IMG/SiberianHusky.png"}, 
    {"name": "Bulldog", "icon": "IMG/Bulldog.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          "🐶 เลือกสายพันธุ์สุนัข",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.pinkAccent.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(0.1),
              Colors.black.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: breeds.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetDetailScreen(
                        breedName: breeds[index]["name"]!,
                        imagePath: breeds[index]["icon"]!,
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  shadowColor: Colors.pinkAccent.withOpacity(0.3),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.pinkAccent.withOpacity(0.1),
                          Colors.pinkAccent.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // รูปภาพสุนัข
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            breeds[index]["icon"]!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.error, color: Colors.red, size: 50);
                            },
                          ),
                        ),
                        SizedBox(height: 12),
                        // ชื่อสายพันธุ์
                        Text(
                          breeds[index]["name"]!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DogBreedScreen()),
            );
          }
          if (index == 1) {
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
}