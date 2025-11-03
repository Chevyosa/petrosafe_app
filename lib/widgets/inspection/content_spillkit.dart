import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_conformity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpillkitContent extends StatefulWidget {
  const SpillkitContent({super.key});

  @override
  State<SpillkitContent> createState() => _SpillkitContentState();
}

class _SpillkitContentState extends State<SpillkitContent> {
  Map<String, dynamic>? sekopData;
  Map<String, dynamic>? padData;
  Map<String, dynamic>? plastikData;
  Map<String, dynamic>? sarungData;
  Map<String, dynamic>? glassData;

  Future<void> saveSpillkitData() async {
    final missingFields = <String>[];

    if (sekopData == null || sekopData?['status'] == null) {
      missingFields.add("Sekop Lipat");
    }
    if (padData == null || padData?['status'] == null) {
      missingFields.add("Absorbent Pad");
    }
    if (plastikData == null || plastikData?['status'] == null) {
      missingFields.add("Plastik / Terpal 4x4 Meter");
    }
    if (sarungData == null || sarungData?['status'] == null) {
      missingFields.add("Sarung Tangan Tahan Minyak");
    }
    if (glassData == null || glassData?['status'] == null) {
      missingFields.add("Safety Glass");
    }

    if (missingFields.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Harap lengkapi pemeriksaan berikut:\n• ${missingFields.join('\n• ')}",
          ),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final spillkitData = {
      "sekop_lipat": sekopData,
      "absorbent_pad": padData,
      "plastik_terpal": plastikData,
      "sarung_tangan": sarungData,
      "safety_glass": glassData,
      "timestamp": DateTime.now().toIso8601String(),
    };

    await prefs.setString('spillkit_inspection', jsonEncode(spillkitData));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data Spill Kit berhasil disimpan!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);

    debugPrint(jsonEncode(spillkitData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cek Spill Kit", style: TextStyle(fontSize: 20)),
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
            children: [
              const Text("Sekop Lipat"),
              ConformityCard(
                title: "Sekop Lipat Sesuai?",
                onChanged: (data) => setState(() => sekopData = data),
              ),
              const SizedBox(height: 32),

              const Text("Absorbent Pad"),
              ConformityCard(
                title: "Absorbent Pad Sesuai?",
                onChanged: (data) => setState(() => padData = data),
              ),
              const SizedBox(height: 32),

              const Text("Plastik / Terpal 4x4 Meter"),
              ConformityCard(
                title: "Plastik / Terpal 4x4 Sesuai?",
                onChanged: (data) => setState(() => plastikData = data),
              ),
              const SizedBox(height: 32),

              const Text("Sarung Tangan Tahan Minyak"),
              ConformityCard(
                title: "Sarung Tangan Tahan Minyak Sesuai?",
                onChanged: (data) => setState(() => sarungData = data),
              ),
              const SizedBox(height: 32),

              const Text("Safety Glass"),
              ConformityCard(
                title: "Safety Glass Sesuai?",
                onChanged: (data) => setState(() => glassData = data),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: saveSpillkitData,
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
                "Debug Data:\n"
                "Sekop: $sekopData\n"
                "Pad: $padData\n"
                "Plastik: $plastikData\n"
                "Sarung: $sarungData\n"
                "Glass: $glassData",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
