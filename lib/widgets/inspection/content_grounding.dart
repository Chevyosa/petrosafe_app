import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_conformity.dart';
import 'package:petrosafe_app/widgets/forms/form_inspection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroundingContent extends StatefulWidget {
  const GroundingContent({super.key});

  @override
  State<GroundingContent> createState() => _GroundingContentState();
}

class _GroundingContentState extends State<GroundingContent> {
  final lengthController = TextEditingController();
  final ardeController = TextEditingController();

  Map<String, dynamic>? groundingData;
  Map<String, dynamic>? ardeData;

  Future<void> saveGroundingData() async {
    final missingFields = <String>[];

    if (lengthController.text.isEmpty) {
      missingFields.add("Panjang Grounding");
    }
    if (ardeController.text.isEmpty) {
      missingFields.add("Keterangan Arde");
    }

    if (groundingData == null || groundingData?['status'] == null) {
      missingFields.add("Hasil pemeriksaan Grounding");
    }
    if (ardeData == null || ardeData?['status'] == null) {
      missingFields.add("Hasil pemeriksaan Arde");
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
      "grounding": {
        "length": lengthController.text,
        "inspection": groundingData,
      },
      "arde": {"notes": ardeController.text, "inspection": ardeData},
      "timestamp": DateTime.now().toIso8601String(),
    };

    await prefs.setString('grounding_inspection', jsonEncode(data));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data Grounding berhasil disimpan!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cek Grounding", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("Grounding"),
              PetroForm(
                hintText: "Masukkan Panjang Grounding",
                controller: lengthController,
              ),
              const SizedBox(height: 8),
              ConformityCard(
                title: "Grounding Sesuai?",
                onChanged: (data) => setState(() => groundingData = data),
              ),

              const SizedBox(height: 32),

              const Text("Arde"),
              PetroForm(
                hintText: "Masukkan Keterangan Arde",
                controller: ardeController,
              ),
              const SizedBox(height: 8),
              ConformityCard(
                title: "Arde Sesuai?",
                onChanged: (data) => setState(() => ardeData = data),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: saveGroundingData,
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
