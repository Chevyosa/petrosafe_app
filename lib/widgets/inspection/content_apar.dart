import 'package:flutter/material.dart';

class AparContent extends StatelessWidget {
  const AparContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cek APAR", style: TextStyle(fontSize: 20))),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: <Widget>[]),
        ),
      ),
    );
  }
}
