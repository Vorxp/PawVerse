import 'dart:math';

class Pet {
  String name;
  final String breed;
  int happiness;
  int hunger;
  int energy;
  int health;
  int experience;
  int level;
  DateTime lastUpdated;

  Pet({
    required this.name,
    required this.breed,
    this.happiness = 100,
    this.hunger = 0,
    this.energy = 100,
    this.health = 100,
    this.experience = 0,
    this.level = 1,
  }) : lastUpdated = DateTime.now();

  // คำนวณสถานะโดยรวม
  int get overallStatus {
    return ((happiness + (100 - hunger) + energy + health) / 4).round();
  }

  // เพิ่มประสบการณ์และตรวจสอบการเลเวลอัพ
  void addExperience(int amount) {
    experience += amount;
    
    // ตรวจสอบการเลเวลอัพ
    if (experience >= 100) {
      level++;
      experience = experience - 100;
      
      // โบนัสเลเวลอัพ
      happiness = min(100, happiness + 20);
      health = min(100, health + 10);
    }
  }
  
  // อัปเดตสถานะตามเวลาที่ผ่านไป
  void updateStatusByTime() {
    DateTime now = DateTime.now();
    Duration difference = now.difference(lastUpdated);
    
    // ทุกๆ 1 ชั่วโมงที่ไม่ได้เล่น
    int hoursElapsed = difference.inHours;
    
    if (hoursElapsed > 0) {
      // ลดความสุขและพลังงานลง และเพิ่มความหิว
      happiness = max(0, happiness - (hoursElapsed * 5));
      energy = max(0, energy - (hoursElapsed * 10));
      hunger = min(100, hunger + (hoursElapsed * 15));
      
      // ถ้าหิวมาก จะส่งผลต่อสุขภาพ
      if (hunger > 80) {
        health = max(0, health - (hoursElapsed * 3));
      }
      
      lastUpdated = now;
    }
  }
  
  // แปลงเป็น Map เพื่อบันทึกลง Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'breed': breed,
      'happiness': happiness,
      'hunger': hunger,
      'energy': energy,
      'health': health,
      'experience': experience,
      'level': level,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
    };
  }
  
  // สร้าง Pet จาก Map ที่ได้จาก Firebase
  factory Pet.fromMap(Map<String, dynamic> map) {
    Pet pet = Pet(
      name: map['name'] ?? 'Unknown',
      breed: map['breed'] ?? 'Unknown',
    );
    
    pet.happiness = map['happiness'] ?? 100;
    pet.hunger = map['hunger'] ?? 0;
    pet.energy = map['energy'] ?? 100;
    pet.health = map['health'] ?? 100;
    pet.experience = map['experience'] ?? 0;
    pet.level = map['level'] ?? 1;
    
    // แปลง timestamp จาก Firebase เป็น DateTime
    if (map['lastUpdated'] != null) {
      if (map['lastUpdated'] is int) {
        pet.lastUpdated = DateTime.fromMillisecondsSinceEpoch(map['lastUpdated']);
      } else {
        // สำหรับ Firestore Timestamp
        pet.lastUpdated = (map['lastUpdated'] as DateTime);
      }
    }
    
    return pet;
  }
}