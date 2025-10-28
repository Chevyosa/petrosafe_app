import 'package:flutter/material.dart';

class EmergencyCutOffContent extends StatelessWidget {
  const EmergencyCutOffContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cek Emergency Cut Off", style: TextStyle(fontSize: 20)),
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
