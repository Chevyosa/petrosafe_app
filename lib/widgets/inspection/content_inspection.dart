import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_camera.dart';
import 'package:petrosafe_app/widgets/forms/form_inspection.dart';
import 'package:petrosafe_app/widgets/inspection/content_inspect.dart';

class InspectionContent extends StatelessWidget {
  const InspectionContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inspeksi Kendaraan", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(
                "Sebelum melakukan Inspeksi, harap mengisi data kendaraan di bawah ini",
              ),

              SizedBox(height: 16),

              PetroForm(hintText: "Masukkan Nomor Polisi Kendaraan"),

              SizedBox(height: 16),

              PetroForm(hintText: "Masukkan Kapasitas Tangki Kendaraan"),

              SizedBox(height: 16),

              PetroForm(hintText: "Masukkan Kategori Kendaraan (Usia)"),

              SizedBox(height: 16),

              CameraCard(
                targetFoto: "1 Foto Kendaraan",
                sisiFoto: "Depan Kendaraan",
                tujuanFoto: "Diinspeksi",
              ),

              Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InspectContent()),
                    ),
                  },
                  child: Text(
                    "Selanjutnya",
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
