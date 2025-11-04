import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/buttons/buttons_inspection.dart';
import 'package:petrosafe_app/widgets/inspection/content_apar.dart';
import 'package:petrosafe_app/widgets/inspection/content_emergencycutoff.dart';
import 'package:petrosafe_app/widgets/inspection/content_ganjalroda.dart';
import 'package:petrosafe_app/widgets/inspection/content_grounding.dart';
import 'package:petrosafe_app/widgets/inspection/content_p3k.dart';
import 'package:petrosafe_app/widgets/inspection/content_safetycone.dart';
import 'package:petrosafe_app/widgets/inspection/content_safetyswitch.dart';
import 'package:petrosafe_app/widgets/inspection/content_spillkit.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class InspectContent extends StatefulWidget {
  const InspectContent({super.key});

  @override
  State<InspectContent> createState() => _InspectContentState();
}

class _InspectContentState extends State<InspectContent> {
  final inspections = [
    {
      "key": "apar_inspection",
      "title": "Cek APAR",
      "page": const AparContent(),
    },
    {
      "key": "spillkit_inspection",
      "title": "Cek Spill Kit",
      "page": const SpillkitContent(),
    },
    {
      "key": "ganjal_roda_inspection",
      "title": "Cek Ganjal Roda",
      "page": const GanjalRodaContent(),
    },
    {
      "key": "safety_cone_inspection",
      "title": "Cek Safety Cone",
      "page": const SafetyConeContent(),
    },
    {
      "key": "safety_switch_inspection",
      "title": "Cek Safety Switch",
      "page": const SafetySwitchContent(),
    },
    {
      "key": "emergency_cutoff_inspection",
      "title": "Cek Emergency Cut Off",
      "page": const EmergencyCutOffContent(),
    },
    {
      "key": "p3k_inspection",
      "title": "Cek Perlengkapan P3K",
      "page": const P3KContent(),
    },
    {
      "key": "grounding_inspection",
      "title": "Cek Grounding",
      "page": const GroundingContent(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _clearOldInspectionData();
  }

  @override
  void dispose() {
    _clearOldInspectionData();
    super.dispose();
  }

  Future<void> _clearOldInspectionData() async {
    final prefs = await SharedPreferences.getInstance();
    for (final item in inspections) {
      await prefs.remove(item["key"] as String);
    }
    debugPrint(
      "Semua data inspeksi lokal dihapus saat keluar/masuk halaman InspectContent",
    );
  }

  Future<void> _validateAllInspections(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final missing = <String>[];

    for (final item in inspections) {
      final rawData = prefs.getString(item["key"] as String);
      if (rawData == null) {
        missing.add(item["title"] as String);
        continue;
      }

      final decoded = jsonDecode(rawData);
      if (decoded is Map && decoded.isEmpty) {
        missing.add(item["title"] as String);
      }
    }

    if (missing.isNotEmpty) {
      _showWarningDialog(context, missing);
    } else {
      _showConfirmDialog(context);
    }
  }

  void _showWarningDialog(BuildContext context, List<String> missing) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Data Belum Lengkap",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Beberapa inspeksi berikut belum diisi:\n\n• ${missing.join('\n• ')}\n\n"
          "Silakan lengkapi terlebih dahulu sebelum mengirim.",
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Konfirmasi Pengiriman",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Semua data inspeksi sudah lengkap dan siap dikirim.\n\n"
          "Setelah dikirim, data tidak dapat diubah. Apakah Anda yakin ingin melanjutkan?",
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Semua data lengkap! Siap dikirim ke server."),
                  backgroundColor: Colors.green,
                ),
              );
              // TODO: lanjut ke API integrasi di sini
            },
            child: const Text("Kirim", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inspeksi Kendaraan", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              for (var item in inspections) ...[
                PetroButton(
                  title: item["title"] as String,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => item["page"] as Widget),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () => _validateAllInspections(context),
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
            ],
          ),
        ),
      ),
    );
  }
}
