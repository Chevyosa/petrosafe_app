import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_conformity.dart';
import 'package:petrosafe_app/widgets/forms/form_inspection.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SafetyConeContent extends StatefulWidget {
  const SafetyConeContent({super.key});

  @override
  State<SafetyConeContent> createState() => _SafetyConeContentState();
}

class _SafetyConeContentState extends State<SafetyConeContent> {
  final totalConeController = TextEditingController();
  Map<String, dynamic>? coneInspectionData;

  Future<void> saveSafetyConeData() async {
    final missingFields = <String>[];

    if (totalConeController.text.isEmpty) {
      missingFields.add("Jumlah Tersedia");
    }

    if (coneInspectionData == null || coneInspectionData?['status'] == null) {
      missingFields.add("Hasil pemeriksaan Safety Cone");
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

    final data = {
      "jumlah": totalConeController.text,
      "inspection": coneInspectionData,
      "timestamp": DateTime.now().toIso8601String(),
    };

    await prefs.setString('safety_cone_inspection', jsonEncode(data));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data Safety Cone berhasil disimpan!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);

    debugPrint(jsonEncode(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cek Safety Cone", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("Jumlah Tersedia"),
              PetroForm(
                hintText: "Masukkan Jumlah Tersedia",
                controller: totalConeController,
              ),
              const SizedBox(height: 8),

              ConformityCard(
                title: "Safety Cone Sesuai?",
                onChanged: (data) => setState(() => coneInspectionData = data),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: saveSafetyConeData,
                  child: const Text(
                    "Selesaikan Inspeksi",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "Debug Data:\n${coneInspectionData ?? "-"}",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
