import 'package:flutter/material.dart';

class GroundingContent extends StatelessWidget {
  const GroundingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cek Grounding", style: TextStyle(fontSize: 20)),
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
