// สร้าง Model สำหรับเก็บข้อมูลสัตว์เลี้ยง
class Pet {
  String name;
  String breed;
  int happiness;
  int hunger;
  int health;
  int energy;
  int level;
  int experience;

  Pet({
    required this.name,
    required this.breed,
    this.happiness = 50,
    this.hunger = 50,
    this.health = 80,
    this.energy = 100,
    this.level = 1,
    this.experience = 0,
  });

  // คำนวณสถานะโดยรวม
  int get overallStatus {
    return (happiness + (100 - hunger) + health + energy) ~/ 4;
  }

  // เพิ่ม experience และขึ้นเลเวลถ้าถึงเกณฑ์
  void addExperience(int amount) {
    experience += amount;
    if (experience >= 100) {
      level++;
      experience = experience - 100;
    }
  }
}