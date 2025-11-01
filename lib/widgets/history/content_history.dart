import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:petrosafe_app/widgets/cards/card_history_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryContent extends StatefulWidget {
  const HistoryContent({super.key});

  @override
  State<HistoryContent> createState() => _HistoryContentState();
}

class _HistoryContentState extends State<HistoryContent> {
  bool isLoading = true;
  List<Map<String, dynamic>> historyData = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      fetchInspections();
    });
  }

  Future<void> fetchInspections() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception('Token tidak ditemukan, silakan login kembali.');
      }

      final url = Uri.parse('http://10.0.2.2:3000/api/inspections');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List inspections = data['data'] ?? [];

        final List<Map<String, dynamic>> mapped = inspections.map((item) {
          final DateTime date =
              DateTime.tryParse(item['inspection_date'] ?? '') ??
              DateTime.now();

          return {
            "urlPhoto": "lib/assets/images/Truk.png",
            "platenumber": item["nopol"] ?? "-",
            "inspector": item["inspector"] ?? "-",
            "capacity": item["kapasitas"] ?? "-",
            "category": item["kategori"] ?? "-",
            "date": DateFormat("d MMMM yyyy", "id_ID").format(date),
          };
        }).toList();

        setState(() {
          historyData = mapped;
          isLoading = false;
        });
      } else {
        throw Exception(
          'Gagal mengambil data inspeksi (${response.statusCode})',
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan saat memuat data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Riwayat Inspeksi", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Data inspeksi di bawah adalah data keseluruhan inspeksi. "
                "Scroll untuk melihat data yang lainnya. Untuk rekap, klik tombol ekspor di bawah.",
                style: const TextStyle(fontSize: 16),
              ),
            ),

            Expanded(
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      if (isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (historyData.isEmpty)
                        const Text("Belum ada data inspeksi.")
                      else
                        for (var item in historyData)
                          HistoryDataCard(
                            urlPhoto: item["urlPhoto"],
                            platenumber: item["platenumber"],
                            inspector: item["inspector"],
                            capacity: item["capacity"],
                            category: item["category"],
                            date: item["date"],
                          ),
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
