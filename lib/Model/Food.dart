// สร้าง class Food สำหรับเกมให้อาหาร
import 'package:flutter/material.dart';

class Food {
  final String name;
  final int points;
  final Color color;
  final Offset position;

  Food({
    required this.name,
    required this.points,
    required this.color,
    required this.position,
  });
}