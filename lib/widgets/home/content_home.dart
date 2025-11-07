import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:petrosafe_app/widgets/buttons/buttons_inspection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:petrosafe_app/widgets/cards/card_history_data.dart';
import 'package:petrosafe_app/widgets/history/content_history.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String userName = '';
  String userPosition = '';
  String userPhoto = '';
  bool isLoading = true;
  List<Map<String, dynamic>> historyData = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      loadUserData();
      fetchInspections();
    });
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Pengguna';
      userPosition = prefs.getString('user_position') ?? '-';
      userPhoto = prefs.getString('user_photo') ?? '';
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: fetchInspections,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Selamat Pagi",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Row(
                  children: <Widget>[
                    Text(
                      "Selamat ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "Beraktifitas",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: userPhoto.isNotEmpty
                          ? NetworkImage(userPhoto)
                          : const AssetImage("lib/assets/images/userphoto.jpeg")
                                as ImageProvider,
                      radius: 50,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          userPosition.isNotEmpty
                              ? userPosition
                              : "Inspektor Kendaraan",
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                PetroButton(
                  title: "Lihat Seluruh Riwayat Inspeksi",
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryContent(),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Riwayat Inspeksi Terakhir",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
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
    );
  }
}
