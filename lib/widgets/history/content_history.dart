import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
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

  DateTimeRange? selectedRange;

  Future<void> pickDateRange() async {
    final DateTime now = DateTime.now();

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange:
          selectedRange ??
          DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: DateTime.now(),
          ),
      locale: const Locale('id', 'ID'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedRange = picked;
      });
    }
  }

  /// 📤 Fungsi ekspor ke Excel
  Future<void> exportToExcel() async {
    try {
      if (selectedRange == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pilih rentang tanggal terlebih dahulu!"),
          ),
        );
        return;
      }

      setState(() => isLoading = true);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception('Token tidak ditemukan, silakan login kembali.');
      }

      final from = DateFormat('yyyy-MM-dd').format(selectedRange!.start);
      final to = DateFormat('yyyy-MM-dd').format(selectedRange!.end);
      final dio = Dio();

      final url =
          'http://10.0.2.2:3000/api/inspections/export?from=$from&to=$to';
      final filePath = '/storage/emulated/0/Download/riwayat_inspeksi.xlsx';

      final response = await dio.download(
        url,
        filePath,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("File berhasil disimpan untuk periode $from - $to"),
          ),
        );
        await OpenFilex.open(filePath);
      } else {
        throw Exception("Gagal mengunduh file (${response.statusCode})");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal ekspor: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

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
        const baseUrl = "http://10.0.2.2:3000";

        final mapped = inspections.map<Map<String, dynamic>>((item) {
          final DateTime date =
              DateTime.tryParse(item['inspection_date'] ?? '') ??
              DateTime.now();

          return {
            "urlPhoto": item["photo_path"] != null
                ? "$baseUrl/${item["photo_path"]}"
                : "",
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
        setState(() => isLoading = false);
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
    final selectedText = selectedRange == null
        ? "Belum dipilih"
        : "${DateFormat('d MMM yyyy', 'id_ID').format(selectedRange!.start)} - "
              "${DateFormat('d MMM yyyy', 'id_ID').format(selectedRange!.end)}";

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pilih rentang tanggal untuk ekspor:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: pickDateRange,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedText,
                            style: const TextStyle(fontSize: 15),
                          ),
                          const Icon(Icons.calendar_today, color: Colors.green),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Data inspeksi di bawah adalah keseluruhan data. "
                    "Scroll untuk melihat data lain. Untuk rekap, pilih tanggal dan klik ekspor.",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
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
                    onPressed: exportToExcel,
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
