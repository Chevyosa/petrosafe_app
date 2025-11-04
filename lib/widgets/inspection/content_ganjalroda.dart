import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_conformity.dart';
import 'package:petrosafe_app/widgets/forms/form_inspection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GanjalRodaContent extends StatefulWidget {
  const GanjalRodaContent({super.key});

  @override
  State<GanjalRodaContent> createState() => _GanjalRodaState();
}

class _GanjalRodaState extends State<GanjalRodaContent> {
  final totalController = TextEditingController();
  final materialController = TextEditingController();

  Map<String, dynamic>? wheelStopData;

  Future<void> saveGanjalRodaData() async {
    final missingFields = <String>[];

    if (totalController.text.isEmpty) {
      missingFields.add("Jumlah Tersedia");
    }
    if (materialController.text.isEmpty) {
      missingFields.add("Material");
    }
    if (wheelStopData == null || wheelStopData?['status'] == null) {
      missingFields.add("Hasil pemeriksaan Ganjal Roda");
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
      "jumlah": totalController.text,
      "material": materialController.text,
      "inspection": wheelStopData,
      "timestamp": DateTime.now().toIso8601String(),
    };

    await prefs.setString('ganjal_roda_inspection', jsonEncode(data));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data Ganjal Roda berhasil disimpan!"),
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
        title: const Text("Cek Ganjal Roda", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("Jumlah Tersedia"),
              PetroForm(
                hintText: "Masukkan Jumlah Tersedia",
                controller: totalController,
              ),
              const SizedBox(height: 8),

              const Text("Material"),
              PetroForm(
                hintText: "Masukkan Material",
                controller: materialController,
              ),
              const SizedBox(height: 8),

              ConformityCard(
                title: "Ganjal Roda Sesuai?",
                onChanged: (data) => setState(() => wheelStopData = data),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: saveGanjalRodaData,
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
                "Debug Data:\n${wheelStopData ?? "-"}",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
