import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_conformity.dart';
import 'package:petrosafe_app/widgets/cards/card_functionality.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SafetySwitchContent extends StatefulWidget {
  const SafetySwitchContent({super.key});

  @override
  State<SafetySwitchContent> createState() => _SafetySwitchContentState();
}

class _SafetySwitchContentState extends State<SafetySwitchContent> {
  Map<String, dynamic>? functionalityData;
  Map<String, dynamic>? conformityData;

  Future<void> saveSafetySwitchData() async {
    final missingFields = <String>[];

    if (functionalityData == null || functionalityData?['status'] == null) {
      missingFields.add("Hasil pemeriksaan fungsi Safety Switch");
    }
    if (conformityData == null || conformityData?['status'] == null) {
      missingFields.add("Hasil kesesuaian Safety Switch");
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

    final safetySwitchData = {
      "functionality": functionalityData,
      "conformity": conformityData,
      "timestamp": DateTime.now().toIso8601String(),
    };

    await prefs.setString(
      'safety_switch_inspection',
      jsonEncode(safetySwitchData),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data Safety Switch berhasil disimpan!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cek Safety Switch", style: TextStyle(fontSize: 20)),
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
              const Text("Fungsi Safety Switch"),
              const SizedBox(height: 8),
              FunctionalityCard(
                title: "Apakah Safety Switch Berfungsi?",
                onChanged: (data) => setState(() => functionalityData = data),
              ),

              const SizedBox(height: 24),

              const Text("Kesesuaian"),
              const SizedBox(height: 8),
              ConformityCard(
                title: "Apakah Safety Switch Terpasang Sesuai?",
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
                  onPressed: saveSafetySwitchData,
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
