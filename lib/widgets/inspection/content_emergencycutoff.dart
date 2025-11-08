import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_conformity.dart';
import 'package:petrosafe_app/widgets/cards/card_functionality.dart';
import 'package:petrosafe_app/widgets/forms/form_inspection.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyCutOffContent extends StatefulWidget {
  const EmergencyCutOffContent({super.key});

  @override
  State<EmergencyCutOffContent> createState() => _EmergencyCutOffState();
}

class _EmergencyCutOffState extends State<EmergencyCutOffContent> {
  final totalController = TextEditingController();

  Map<String, dynamic>? functionalityData;
  Map<String, dynamic>? conformityData;

  @override
  void initState() {
    super.initState();
    totalController.addListener(() {
      setState(() {});
    });
  }

  Future<void> saveEmergencyCutOffData() async {
    final missingFields = <String>[];

    if (totalController.text.trim().isEmpty) {
      missingFields.add("Jumlah Emergency Cut Off");
    }

    if (functionalityData == null || functionalityData?['status'] == null) {
      missingFields.add("Hasil pemeriksaan fungsi Emergency Cut Off");
    }
    if (conformityData == null || conformityData?['status'] == null) {
      missingFields.add("Hasil kesesuaian Emergency Cut Off");
    }

    if (missingFields.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Harap lengkapi data berikut:\n• ${missingFields.join('\n• ')}",
          ),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final emergencyCutOffData = {
      "total": totalController.text,
      "functionality": functionalityData,
      "conformity": conformityData,
      "timestamp": DateTime.now().toIso8601String(),
    };

    await prefs.setString(
      'emergency_cutoff_inspection',
      jsonEncode(emergencyCutOffData),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data Emergency Cut Off berhasil disimpan!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

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
            children: [
              const Text("Jumlah Emergency Cut Off"),
              PetroForm(
                hintText: "Masukkan Jumlah",
                controller: totalController,
              ),

              const SizedBox(height: 16),

              const Text("Fungsi Emergency Cut Off"),
              const SizedBox(height: 8),
              FunctionalityCard(
                title: "Apakah Emergency Cut Off Berfungsi?",
                onChanged: (data) => setState(() => functionalityData = data),
              ),

              const SizedBox(height: 24),

              const Text("Kesesuaian"),
              const SizedBox(height: 8),
              ConformityCard(
                title: "Apakah Emergency Cut Off Sesuai?",
                onChanged: (data) => setState(() => conformityData = data),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: saveEmergencyCutOffData,
                  child: const Text(
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
