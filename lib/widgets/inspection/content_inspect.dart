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

class InspectContent extends StatelessWidget {
  const InspectContent({super.key});

  @override
  Widget build(BuildContext context) {
    final inspections = [
      {"title": "Cek APAR", "page": const AparContent()},
      {"title": "Cek Spill Kit", "page": const SpillkitContent()},
      {"title": "Cek Ganjal Roda", "page": const GanjalRodaContent()},
      {"title": "Cek Safety Cone", "page": const SafetyConeContent()},
      {"title": "Cek Safety Switch", "page": const SafetySwitchContent()},
      {
        "title": "Cek Emergency Cut Off",
        "page": const EmergencyCutOffContent(),
      },
      {"title": "Cek Perlengkapan P3K", "page": const P3KContent()},
      {"title": "Cek Grounding", "page": const GroundingContent()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inspeksi Kendaraan", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
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
                  onPressed: () => _showConfirmDialog(context),
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

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Pengiriman Data",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Data yang akan dikirimkan tidak bisa dirubah setelah selesai inspeksi.\n\nApakah anda sudah yakin?",
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context),
              child: const Text("Tidak", style: TextStyle(color: Colors.white)),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Data dikirim!")));
              },
              child: const Text("Ya", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
