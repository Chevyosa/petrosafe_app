import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;

  const LoginForm({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
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
