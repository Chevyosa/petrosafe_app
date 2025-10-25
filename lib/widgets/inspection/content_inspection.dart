import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:petrosafe_app/widgets/forms/form_inspection.dart';

class InspectionContent extends StatelessWidget {
  const InspectionContent({super.key});

  @override
  Widget build(BuildContext context) {
    const cameraIcon = Icon(FeatherIcons.camera, color: Colors.white);

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

              SizedBox(
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                  color: Colors.red[800],
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        cameraIcon,
                        SizedBox(height: 10),
                        Text(
                          "Ambil 1 Foto Kendaraan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Foto Bagian Depan Kendaraan Yang Diinspeksi",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () => {},
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
