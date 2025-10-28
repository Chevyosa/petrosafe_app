import 'package:flutter/material.dart';

class NoteForm extends StatelessWidget {
  final String hintText;

  const NoteForm({super.key, required this.hintText});

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
          maxLines: 3,
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
