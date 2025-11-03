import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_camera.dart';
import 'package:petrosafe_app/widgets/forms/form_inspection.dart';
import 'package:petrosafe_app/widgets/inspection/content_inspect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InspectionContent extends StatefulWidget {
  const InspectionContent({super.key});

  @override
  State<InspectionContent> createState() => _InspectionContentState();
}

class _InspectionContentState extends State<InspectionContent> {
  final plateController = TextEditingController();
  final capacityController = TextEditingController();
  final categoryController = TextEditingController();

  String? _vehiclePhoto;

  bool isLoading = false;

  Future<void> saveVehicleData({
    required String nopol,
    required String kapasitas,
    required String kategori,
    required String photoPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("vehicle_plate", nopol);
    await prefs.setString("vehicle_capacity", kapasitas);
    await prefs.setString("vehicle_category", kategori);
    await prefs.setString("vehicle_photo", photoPath);
  }

  void _setPhoto(String path) {
    setState(() => _vehiclePhoto = path);
  }

  bool checkVehicleData() {
    return plateController.text.isNotEmpty &&
        capacityController.text.isNotEmpty &&
        categoryController.text.isNotEmpty &&
        _vehiclePhoto != null;
  }

  Future<void> handleNext(BuildContext context) async {
    if (!checkVehicleData()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap isi semua data kendaraan terlebih dahulu."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await saveVehicleData(
      nopol: plateController.text,
      kapasitas: capacityController.text,
      kategori: categoryController.text,
      photoPath: _vehiclePhoto ?? "",
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const InspectContent()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inspeksi Kendaraan", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Sebelum melakukan Inspeksi, harap mengisi data kendaraan di bawah ini",
                  ),

                  const SizedBox(height: 16),

                  PetroForm(
                    hintText: "Masukkan Nomor Polisi Kendaraan",
                    controller: plateController,
                  ),

                  const SizedBox(height: 16),

                  PetroForm(
                    hintText: "Masukkan Kapasitas Tangki Kendaraan",
                    controller: capacityController,
                  ),

                  const SizedBox(height: 16),

                  PetroForm(
                    hintText: "Masukkan Kategori Kendaraan (Usia)",
                    controller: categoryController,
                  ),

                  const SizedBox(height: 16),

                  CameraCard(
                    targetFoto: "1 Foto Kendaraan",
                    sisiFoto: "Depan Kendaraan",
                    tujuanFoto: "Diinspeksi",
                    onCaptured: (path) => _setPhoto(path),
                  ),
                ],
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async => await handleNext(context),
                  child: const Text(
                    "Selanjutnya",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
