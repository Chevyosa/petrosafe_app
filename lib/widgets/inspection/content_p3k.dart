import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_conformity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class P3KContent extends StatefulWidget {
  const P3KContent({super.key});

  @override
  State<P3KContent> createState() => _P3KContentState();
}

class _P3KContentState extends State<P3KContent> {
  Map<String, dynamic>? antiseptikData;
  Map<String, dynamic>? perbanData;
  Map<String, dynamic>? plesterData;
  Map<String, dynamic>? salepData;
  Map<String, dynamic>? obatMataData;

  Future<void> saveP3KData() async {
    final missingFields = <String>[];

    if (antiseptikData == null || antiseptikData?['status'] == null) {
      missingFields.add("Antiseptik");
    }
    if (perbanData == null || perbanData?['status'] == null) {
      missingFields.add("Perban");
    }
    if (plesterData == null || plesterData?['status'] == null) {
      missingFields.add("Plester");
    }
    if (salepData == null || salepData?['status'] == null) {
      missingFields.add("Salep Luka Bakar");
    }
    if (obatMataData == null || obatMataData?['status'] == null) {
      missingFields.add("Obat Cuci Mata");
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

    final p3kData = {
      "antiseptik": antiseptikData,
      "perban": perbanData,
      "plester": plesterData,
      "salep_luka_bakar": salepData,
      "obat_cuci_mata": obatMataData,
      "timestamp": DateTime.now().toIso8601String(),
    };

    await prefs.setString('p3k_inspection', jsonEncode(p3kData));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data P3K berhasil disimpan!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);

    debugPrint(jsonEncode(p3kData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cek Perlengkapan P3K",
          style: TextStyle(fontSize: 20),
        ),
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
              const Text("Antiseptik"),
              ConformityCard(
                title: "Antiseptik Sesuai?",
                onChanged: (data) => setState(() => antiseptikData = data),
              ),
              const SizedBox(height: 32),

              const Text("Perban"),
              ConformityCard(
                title: "Perban Sesuai?",
                onChanged: (data) => setState(() => perbanData = data),
              ),
              const SizedBox(height: 32),

              const Text("Plester"),
              ConformityCard(
                title: "Plester Sesuai?",
                onChanged: (data) => setState(() => plesterData = data),
              ),
              const SizedBox(height: 32),

              const Text("Salep Luka Bakar"),
              ConformityCard(
                title: "Salep Luka Bakar Sesuai?",
                onChanged: (data) => setState(() => salepData = data),
              ),
              const SizedBox(height: 32),

              const Text("Obat Cuci Mata"),
              ConformityCard(
                title: "Obat Cuci Mata Sesuai?",
                onChanged: (data) => setState(() => obatMataData = data),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: saveP3KData,
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
                "Antiseptik: $antiseptikData\n"
                "Perban: $perbanData\n"
                "Plester: $plesterData\n"
                "Salep: $salepData\n"
                "Obat Mata: $obatMataData",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
