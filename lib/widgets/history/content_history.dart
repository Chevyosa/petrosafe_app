import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_history_data.dart';

class HistoryContent extends StatelessWidget {
  const HistoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> historyData = [
      {
        "urlPhoto": "lib/assets/images/Truk.png",
        "platenumber": "BP 8897 HJ",
        "inspector": "Toni",
        "capacity": "8000",
        "category": "8",
        "date": "24 Oktober 2025",
      },
      {
        "urlPhoto": "lib/assets/images/Truk.png",
        "platenumber": "BP 1172 FA",
        "inspector": "Rudi",
        "capacity": "5000",
        "category": "5",
        "date": "22 Oktober 2025",
      },
      {
        "urlPhoto": "lib/assets/images/Truk.png",
        "platenumber": "BP 2278 DJ",
        "inspector": "Agus",
        "capacity": "6000",
        "category": "6",
        "date": "18 Oktober 2025",
      },
      {
        "urlPhoto": "lib/assets/images/Truk.png",
        "platenumber": "BP 8897 HJ",
        "inspector": "Toni",
        "capacity": "8000",
        "category": "8",
        "date": "24 Oktober 2025",
      },
      {
        "urlPhoto": "lib/assets/images/Truk.png",
        "platenumber": "BP 1172 FA",
        "inspector": "Rudi",
        "capacity": "5000",
        "category": "5",
        "date": "22 Oktober 2025",
      },
      {
        "urlPhoto": "lib/assets/images/Truk.png",
        "platenumber": "BP 2278 DJ",
        "inspector": "Agus",
        "capacity": "6000",
        "category": "6",
        "date": "18 Oktober 2025",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Riwayat Inspeksi", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Bagian atas tetap di tempat
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Data inspeksi di bawah adalah data keseluruhan inspeksi. "
                "Scroll untuk melihat data yang lainnya. Untuk rekap, klik tombol ekspor di bawah.",
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // 🔽 Bagian tengah scrollable
            Expanded(
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      for (var item in historyData)
                        HistoryDataCard(
                          urlPhoto: item["urlPhoto"]!,
                          platenumber: item["platenumber"]!,
                          inspector: item["inspector"]!,
                          capacity: item["capacity"]!,
                          category: item["category"]!,
                          date: item["date"]!,
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      // aksi ekspor
                    },
                    child: const Text(
                      "Ekspor ke Excel",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
