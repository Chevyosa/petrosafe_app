import 'package:flutter/material.dart';

class PetroForm extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;

  const PetroForm({
    super.key,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
        side: BorderSide(color: Colors.blue),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
