import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:petrosafe_app/pages/page_main.dart';
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
              _submitInspectionToServer(context);
            },
            child: const Text("Kirim", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  bool asBool(dynamic v) {
    if (v is bool) return v;
    if (v is num) return v != 0; // 1/0, 1.0/0.0
    if (v is String) {
      final s = v.trim().toLowerCase();
      return s == 'true' || s == '1' || s == 'ya';
    }
    return false;
  }

  Future<void> _submitInspectionToServer(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final allItems = <Map<String, dynamic>>[];

      for (final item in inspections) {
        final key = item["key"] as String;
        final raw = prefs.getString(key);
        if (raw == null) continue;

        final decoded = jsonDecode(raw);

        // --- CASE 1: APAR (nested map: right/left/cabin)
        if (key == "apar_inspection" && decoded is Map<String, dynamic>) {
          final aparData = Map<String, dynamic>.from(decoded);

          // mapping helper
          void addAparItem(
            String posKey,
            String label,
            Map<String, dynamic> posData,
          ) {
            final inspection = Map<String, dynamic>.from(
              posData["inspection"] ?? {},
            );
            final sesuai = asBool(inspection["status"]);
            final note = inspection["note"];
            final photoPath = inspection["photoPath"];

            allItems.add({
              "item_key": "apar_${label}_ukuran",
              "sesuai": sesuai,
              "value": posData["size"] ?? "",
              if (!sesuai && note != null) "note": note,
              if (!sesuai && photoPath != null) "photoPath": photoPath,
            });

            allItems.add({
              "item_key": "apar_${label}_merk",
              "sesuai": sesuai,
              "value": posData["brand"] ?? "",
              if (!sesuai && note != null) "note": note,
              if (!sesuai && photoPath != null) "photoPath": photoPath,
            });
          }

          addAparItem(
            "right",
            "belakang_kanan",
            Map<String, dynamic>.from(aparData["right"] ?? {}),
          );
          addAparItem(
            "left",
            "belakang_kiri",
            Map<String, dynamic>.from(aparData["left"] ?? {}),
          );
          addAparItem(
            "cabin",
            "kabin",
            Map<String, dynamic>.from(aparData["cabin"] ?? {}),
          );
        }
        // --- CASE 2: SPILL KIT (map dengan setiap alat)
        else if (key == "spillkit_inspection" &&
            decoded is Map<String, dynamic>) {
          final spillkitData = Map<String, dynamic>.from(decoded);

          // helper buat nambah item spillkit
          void addSpillkitItem(String keySuffix, Map<String, dynamic>? data) {
            if (data == null) return;

            final status = asBool(data["status"]);
            final note = data["note"];
            final photoPath = data["photoPath"];

            allItems.add({
              "item_key": "spillkit_$keySuffix",
              "sesuai": status,
              if (!status && note != null) "note": note,
              if (!status && photoPath != null) "photoPath": photoPath,
            });
          }

          addSpillkitItem("sekop_lipat", spillkitData["sekop_lipat"]);
          addSpillkitItem("absorbent_pad", spillkitData["absorbent_pad"]);
          addSpillkitItem(
            "plastik_terpal_4x4m",
            spillkitData["plastik_terpal"],
          );
          addSpillkitItem(
            "sarung_tangan_tahan_minyak",
            spillkitData["sarung_tangan"],
          );
          addSpillkitItem("safety_glass", spillkitData["safety_glass"]);
        }
        // --- CASE 3: GANJAL RODA
        else if (key == "ganjal_roda_inspection" &&
            decoded is Map<String, dynamic>) {
          final ganjalData = Map<String, dynamic>.from(decoded);
          final inspection = Map<String, dynamic>.from(
            ganjalData["inspection"] ?? {},
          );
          final sesuai = asBool(inspection["status"]);
          final note = inspection["note"];
          final photoPath = inspection["photoPath"];

          // jumlah
          allItems.add({
            "item_key": "ganjal_roda_jumlah",
            "sesuai": sesuai,
            "value": ganjalData["jumlah"] ?? "",
            if (!sesuai && note != null) "note": note,
            if (!sesuai && photoPath != null) "photoPath": photoPath,
          });

          // material
          allItems.add({
            "item_key": "ganjal_roda_material",
            "sesuai": sesuai,
            "value": ganjalData["material"] ?? "",
            if (!sesuai && note != null) "note": note,
            if (!sesuai && photoPath != null) "photoPath": photoPath,
          });
        }
        // --- CASE 4: SAFETY CONE
        else if (key == "safety_cone_inspection" &&
            decoded is Map<String, dynamic>) {
          final coneData = Map<String, dynamic>.from(decoded);
          final inspection = Map<String, dynamic>.from(
            coneData["inspection"] ?? {},
          );
          final sesuai = asBool(inspection["status"]);
          final note = inspection["note"];
          final photoPath = inspection["photoPath"];

          allItems.add({
            "item_key": "safety_cone_jumlah",
            "sesuai": sesuai,
            "value": coneData["jumlah"] ?? "",
            if (!sesuai && note != null) "note": note,
            if (!sesuai && photoPath != null) "photoPath": photoPath,
          });
        }
        // --- CASE 5: SAFETY SWITCH
        else if (key == "safety_switch_inspection" &&
            decoded is Map<String, dynamic>) {
          final switchData = Map<String, dynamic>.from(decoded);

          void addSwitchItem(String keySuffix, Map<String, dynamic>? data) {
            if (data == null) return;

            final status = asBool(data["status"]);
            final note = data["note"];
            final photoPath = data["photoPath"];

            allItems.add({
              "item_key": "safety_switch_$keySuffix",
              "sesuai": status,
              if (!status && note != null) "note": note,
              if (!status && photoPath != null) "photoPath": photoPath,
            });
          }

          addSwitchItem("functionality", switchData["functionality"]);
          addSwitchItem("conformity", switchData["conformity"]);
        }
        // --- CASE 6: EMERGENCY CUT OFF
        else if (key == "emergency_cutoff_inspection" &&
            decoded is Map<String, dynamic>) {
          final cutoffData = Map<String, dynamic>.from(decoded);

          final total = cutoffData["total"] ?? "";
          final funcData = Map<String, dynamic>.from(
            cutoffData["functionality"] ?? {},
          );
          final confData = Map<String, dynamic>.from(
            cutoffData["conformity"] ?? {},
          );

          // 1️⃣ Jumlah Emergency Cut Off
          allItems.add({
            "item_key": "emergency_cutoff_total",
            "sesuai": true, // jumlah tidak perlu validasi sesuai/tidak
            "value": total,
          });

          // 2️⃣ Fungsi Emergency Cut Off
          final funcStatus = asBool(funcData["status"]);
          final funcNote = funcData["note"];
          final funcPhoto = funcData["photoPath"];
          allItems.add({
            "item_key": "emergency_cutoff_functionality",
            "sesuai": funcStatus,
            if (!funcStatus && funcNote != null) "note": funcNote,
            if (!funcStatus && funcPhoto != null) "photoPath": funcPhoto,
          });

          // 3️⃣ Kesesuaian Emergency Cut Off
          final confStatus = asBool(confData["status"]);
          final confNote = confData["note"];
          final confPhoto = confData["photoPath"];
          allItems.add({
            "item_key": "emergency_cutoff_conformity",
            "sesuai": confStatus,
            if (!confStatus && confNote != null) "note": confNote,
            if (!confStatus && confPhoto != null) "photoPath": confPhoto,
          });
        }
        // --- CASE 7: P3K
        else if (key == "p3k_inspection" && decoded is Map<String, dynamic>) {
          final p3kData = Map<String, dynamic>.from(decoded);

          void addP3KItem(String keySuffix, Map<String, dynamic>? data) {
            if (data == null) return;

            final status = asBool(data["status"]);
            final note = data["note"];
            final photoPath = data["photoPath"];

            allItems.add({
              "item_key": "p3k_$keySuffix",
              "sesuai": status,
              if (!status && note != null) "note": note,
              if (!status && photoPath != null) "photoPath": photoPath,
            });
          }

          addP3KItem("antiseptik", p3kData["antiseptik"]);
          addP3KItem("perban", p3kData["perban"]);
          addP3KItem("plester", p3kData["plester"]);
          addP3KItem("salep_luka_bakar", p3kData["salep_luka_bakar"]);
          addP3KItem("obat_cuci_mata", p3kData["obat_cuci_mata"]);
        }
        // --- CASE 8: GROUNDING
        else if (key == "grounding_inspection" &&
            decoded is Map<String, dynamic>) {
          final groundData = Map<String, dynamic>.from(decoded);

          final groundingSection = Map<String, dynamic>.from(
            groundData["grounding"] ?? {},
          );
          final ardeSection = Map<String, dynamic>.from(
            groundData["arde"] ?? {},
          );

          // --- BODY GROUND
          final groundInspect = Map<String, dynamic>.from(
            groundingSection["inspection"] ?? {},
          );
          final groundStatus = asBool(groundInspect["status"]);
          final groundNote = groundInspect["note"];
          final groundPhoto = groundInspect["photoPath"];

          allItems.add({
            "item_key": "grounding_body_ground",
            "sesuai": groundStatus,
            "value": groundingSection["length"] ?? "",
            if (!groundStatus && groundNote != null) "note": groundNote,
            if (!groundStatus && groundPhoto != null) "photoPath": groundPhoto,
          });

          // --- ARDE
          final ardeInspect = Map<String, dynamic>.from(
            ardeSection["inspection"] ?? {},
          );
          final ardeStatus = asBool(ardeInspect["status"]);
          final ardeNote = ardeInspect["note"];
          final ardePhoto = ardeInspect["photoPath"];

          allItems.add({
            "item_key": "grounding_arde",
            "sesuai": ardeStatus,
            "value": ardeSection["notes"] ?? "",
            if (!ardeStatus && ardeNote != null) "note": ardeNote,
            if (!ardeStatus && ardePhoto != null) "photoPath": ardePhoto,
          });
        }
      }

      final nopol = prefs.getString("vehicle_plate") ?? "";
      final kapasitas = prefs.getString("vehicle_capacity") ?? "";
      final kategori = prefs.getString("vehicle_category") ?? "";
      final vehiclePhotoPath = prefs.getString("vehicle_photo");

      final formData = FormData();

      formData.fields.addAll([
        MapEntry("nopol", nopol),
        MapEntry("kapasitas", kapasitas),
        MapEntry("kategori", kategori),
        MapEntry("inspection_date", DateTime.now().toIso8601String()),
      ]);

      for (var i = 0; i < allItems.length; i++) {
        final item = allItems[i];
        formData.fields.add(
          MapEntry("items[$i][item_key]", item["item_key"].toString()),
        );
        formData.fields.add(
          MapEntry("items[$i][sesuai]", item["sesuai"] == true ? "1" : "0"),
        );
        if (item["value"] != null && item["value"].toString().isNotEmpty) {
          formData.fields.add(
            MapEntry("items[$i][value]", item["value"].toString()),
          );
        }
        if (item["note"] != null && item["note"].toString().isNotEmpty) {
          formData.fields.add(
            MapEntry("items[$i][note]", item["note"].toString()),
          );
        }
      }

      if (vehiclePhotoPath != null) {
        final vehicleFile = File(vehiclePhotoPath);
        if (await vehicleFile.exists()) {
          formData.files.add(
            MapEntry(
              "vehicle_photo",
              await MultipartFile.fromFile(
                vehicleFile.path,
                filename: vehicleFile.uri.pathSegments.last,
              ),
            ),
          );
        }
      }

      for (final i in allItems) {
        if (!asBool(i["sesuai"]) && i["photoPath"] != null) {
          final file = File(i["photoPath"]);
          if (await file.exists()) {
            final fieldName = "photo_${i["item_key"]}";
            formData.files.add(
              MapEntry(
                fieldName,
                await MultipartFile.fromFile(
                  file.path,
                  filename: file.uri.pathSegments.last,
                ),
              ),
            );
          }
        }
      }

      final dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:3000/api"));
      final token = prefs.getString("token");

      // --- LOGGING SEBELUM REQUEST ---
      debugPrint("=== 🧾 INSPECTION FORM DATA ===");
      debugPrint("Nopol: $nopol");
      debugPrint("Kapasitas: $kapasitas");
      debugPrint("Kategori: $kategori");
      debugPrint("Token: ${token?.substring(0, 15)}...");

      debugPrint("Items JSON:");
      debugPrint(const JsonEncoder.withIndent('  ').convert(allItems));

      debugPrint("📎 Files to upload:");
      for (final f in formData.files) {
        debugPrint(
          " - ${f.key}: ${(f.value.length)} bytes (${f.value.filename})",
        );
      }
      debugPrint("==============================");

      final response = await dio.post(
        "/inspections",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Inspeksi berhasil dikirim ke server!"),
            backgroundColor: Colors.green,
          ),
        );

        await _clearOldInspectionData();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
          (Route<dynamic> route) => false,
        );
      } else {
        throw Exception("Gagal kirim inspeksi (${response.statusCode})");
      }
    } catch (e) {
      debugPrint("Error submit: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal kirim data: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
