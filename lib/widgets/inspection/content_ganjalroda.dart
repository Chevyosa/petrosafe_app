import 'package:flutter/material.dart';

class GanjalRodaContent extends StatelessWidget {
  const GanjalRodaContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cek Ganjal Roda", style: TextStyle(fontSize: 20)),
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
