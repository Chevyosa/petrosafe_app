import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_condition.dart';
import 'package:petrosafe_app/widgets/cards/card_conformity.dart';
import 'package:petrosafe_app/widgets/cards/card_pressure.dart';
import 'package:petrosafe_app/widgets/forms/form_inspection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AparContent extends StatefulWidget {
  const AparContent({super.key});

  @override
  State<AparContent> createState() => _AparContentState();
}

class _AparContentState extends State<AparContent> {
  final rightSize = TextEditingController();
  final leftSize = TextEditingController();
  final rightBrand = TextEditingController();
  final leftBrand = TextEditingController();
  final cabinSize = TextEditingController();
  final cabinBrand = TextEditingController();

  Map<String, dynamic>? rightAparData;
  Map<String, dynamic>? rightAparPressure;
  Map<String, dynamic>? rightAparCondition;
  Map<String, dynamic>? leftAparData;
  Map<String, dynamic>? leftAparPressure;
  Map<String, dynamic>? leftAparCondition;
  Map<String, dynamic>? cabinAparData;
  Map<String, dynamic>? cabinAparPressure;
  Map<String, dynamic>? cabinAparCondition;

  Future<void> saveAparData() async {
    final missingFields = <String>[];

    if (rightSize.text.isEmpty || rightBrand.text.isEmpty) {
      missingFields.add("Belakang Kanan (Ukuran/Merk)");
    }
    if (leftSize.text.isEmpty || leftBrand.text.isEmpty) {
      missingFields.add("Belakang Kiri (Ukuran/Merk)");
    }
    if (cabinSize.text.isEmpty || cabinBrand.text.isEmpty) {
      missingFields.add("Kabin (Ukuran/Merk)");
    }

    if (rightAparData == null || rightAparData?['status'] == null) {
      missingFields.add("Hasil pemeriksaan APAR Kanan");
    }
    if (leftAparData == null || leftAparData?['status'] == null) {
      missingFields.add("Hasil pemeriksaan APAR Kiri");
    }
    if (cabinAparData == null || cabinAparData?['status'] == null) {
      missingFields.add("Hasil pemeriksaan APAR Kabin");
    }

    if (rightAparPressure == null || rightAparPressure?['value'] == null) {
      missingFields.add("Hasil Pressure APAR Kanan");
    }
    if (leftAparPressure == null || leftAparPressure?['value'] == null) {
      missingFields.add("Hasil Pressure APAR Kiri");
    }
    if (cabinAparPressure == null || cabinAparPressure?['value'] == null) {
      missingFields.add("Hasil Pressure APAR Kabin");
    }

    if (rightAparCondition == null || rightAparCondition?['status'] == null) {
      missingFields.add("Hasil Kondisi APAR Kanan");
    }
    if (leftAparCondition == null || leftAparCondition?['status'] == null) {
      missingFields.add("Hasil Kondisi APAR Kiri");
    }
    if (cabinAparCondition == null || cabinAparCondition?['status'] == null) {
      missingFields.add("Hasil Kondisi APAR Kabin");
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

    final aparData = {
      "right": {
        "size": rightSize.text,
        "brand": rightBrand.text,
        "inspection": rightAparData,
        "condition": rightAparCondition,
        "pressure": rightAparPressure,
      },
      "left": {
        "size": leftSize.text,
        "brand": leftBrand.text,
        "inspection": leftAparData,
        "condition": leftAparCondition,
        "pressure": leftAparPressure,
      },
      "cabin": {
        "size": cabinSize.text,
        "brand": cabinBrand.text,
        "inspection": cabinAparData,
        "condition": cabinAparCondition,
        "pressure": cabinAparPressure,
      },
      "timestamp": DateTime.now().toIso8601String(),
    };

    await prefs.setString('apar_inspection', jsonEncode(aparData));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data APAR berhasil disimpan!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);

    debugPrint(jsonEncode(aparData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cek APAR", style: TextStyle(fontSize: 20)),
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
              const Text("Belakang Kanan"),
              PetroForm(hintText: "Masukkan Ukuran", controller: rightSize),
              const SizedBox(height: 8),
              PetroForm(hintText: "Masukkan Merk", controller: rightBrand),
              const SizedBox(height: 8),
              ConformityCard(
                title: "APAR Kanan Sesuai?",
                onChanged: (data) => setState(() => rightAparData = data),
              ),
              PressureCard(
                title: "Pressure Kanan",
                onChanged: (data) => setState(() => rightAparPressure = data),
              ),
              ConditionCard(
                title: "Kondisi",
                onChanged: (data) => setState(() => rightAparCondition = data),
              ),

              const SizedBox(height: 32),
              const Text("Belakang Kiri"),
              PetroForm(hintText: "Masukkan Ukuran", controller: leftSize),
              const SizedBox(height: 8),
              PetroForm(hintText: "Masukkan Merk", controller: leftBrand),
              const SizedBox(height: 8),
              ConformityCard(
                title: "APAR Kiri Sesuai?",
                onChanged: (data) => setState(() => leftAparData = data),
              ),
              PressureCard(
                title: "Pressure Kiri",
                onChanged: (data) => setState(() => leftAparPressure = data),
              ),
              ConditionCard(
                title: "Kondisi",
                onChanged: (data) => setState(() => leftAparCondition = data),
              ),

              const SizedBox(height: 32),
              const Text("Kabin"),
              PetroForm(hintText: "Masukkan Ukuran", controller: cabinSize),
              const SizedBox(height: 8),
              PetroForm(hintText: "Masukkan Merk", controller: cabinBrand),
              const SizedBox(height: 8),
              ConformityCard(
                title: "APAR Kabin Sesuai?",
                onChanged: (data) => setState(() => cabinAparData = data),
              ),
              PressureCard(
                title: "Pressure Kabin",
                onChanged: (data) => setState(() => cabinAparPressure = data),
              ),
              ConditionCard(
                title: "Kondisi",
                onChanged: (data) => setState(() => cabinAparCondition = data),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: saveAparData,
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

              const SizedBox(height: 16),
              Text(
                "Debug:\n"
                "Kanan: $rightAparData\n"
                "Pressure Kanan: $rightAparPressure\n"
                "Kondisi Kanan: $rightAparCondition\n"
                "Kiri: $leftAparData\n"
                "Pressure Kiri: $leftAparPressure\n"
                "Kondisi Kiri: $leftAparCondition\n"
                "Kabin: $cabinAparData"
                "Pressure Kabin: $cabinAparPressure\n"
                "Kondisi Kabin: $cabinAparCondition\n",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
