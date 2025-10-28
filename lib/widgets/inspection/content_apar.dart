import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_conformity.dart';
import 'package:petrosafe_app/widgets/forms/form_inspection.dart';

class AparContent extends StatelessWidget {
  const AparContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cek APAR", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("Belakang Kanan"),
                const PetroForm(hintText: "Masukkan Ukuran"),
                const SizedBox(height: 8),
                const PetroForm(hintText: "Masukkan Merk"),
                const SizedBox(height: 8),
                const ConformityCard(),

                const SizedBox(height: 32),

                const Text("Belakang Kiri"),
                const PetroForm(hintText: "Masukkan Ukuran"),
                const SizedBox(height: 8),
                const PetroForm(hintText: "Masukkan Merk"),
                const SizedBox(height: 8),
                const ConformityCard(),

                const SizedBox(height: 32),

                const Text("Kabin"),
                const PetroForm(hintText: "Masukkan Ukuran"),
                const SizedBox(height: 8),
                const PetroForm(hintText: "Masukkan Merk"),
                const SizedBox(height: 8),
                const ConformityCard(),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () => {Navigator.pop(context)},
                    child: Text(
                      "Simpan",
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
      ),
    );
  }
}
