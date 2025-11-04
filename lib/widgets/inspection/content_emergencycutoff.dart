import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_conformity.dart';
import 'package:petrosafe_app/widgets/cards/card_functionality.dart';
import 'package:petrosafe_app/widgets/forms/form_inspection.dart';

class EmergencyCutOffContent extends StatefulWidget {
  const EmergencyCutOffContent({super.key});

  @override
  State<EmergencyCutOffContent> createState() => _EmergencyCutOffState();
}

class _EmergencyCutOffState extends State<EmergencyCutOffContent> {
  final totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cek Emergency Cut Off",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("Jumlah"),
              PetroForm(
                hintText: "Masukkan Jumlah",
                controller: totalController,
              ),
              const SizedBox(height: 8),
              FunctionalityCard(),
              const SizedBox(height: 8),
              const ConformityCard(),

              Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () => {Navigator.pop(context)},
                  child: Text(
                    "Simpan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
