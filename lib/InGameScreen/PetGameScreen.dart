import 'package:dog/Model/pet.dart';
import 'package:flutter/material.dart';

// เพิ่ม PlayGameScreen
class PlayGameScreen extends StatelessWidget {
  final Pet pet;
  final Function onGameComplete;

  PlayGameScreen({required this.pet, required this.onGameComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("Play with ${pet.name}"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Play game is under construction"),
      ),
    );
  }
}