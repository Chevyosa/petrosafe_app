import 'package:flutter/material.dart';

class SpillkitContent extends StatelessWidget {
  const SpillkitContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cek Spill Kit", style: TextStyle(fontSize: 20)),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: <Widget>[]),
        ),
      ),
    );
  }
}
