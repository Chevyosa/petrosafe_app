import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_conformity.dart';
import 'package:petrosafe_app/widgets/forms/form_inspection.dart';

class AparContent extends StatefulWidget {
  const AparContent({super.key});

  @override
  State<AparContent> createState() => _AparContentState();
}

class _AparContentState extends State<AparContent> {
  final rightSize = TextEditingController();
  final leftSize = TextEditingController();

  final rightBrand = TextEditingController();
  final leftBrand = TextEditingController();

  final cabinSize = TextEditingController();
  final cabinBrand = TextEditingController();

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
                PetroForm(hintText: "Masukkan Ukuran", controller: rightSize),
                const SizedBox(height: 8),
                PetroForm(hintText: "Masukkan Merk", controller: rightBrand),
                const SizedBox(height: 8),
                const ConformityCard(),

                const SizedBox(height: 32),

                const Text("Belakang Kiri"),
                PetroForm(hintText: "Masukkan Ukuran", controller: leftBrand),
                const SizedBox(height: 8),
                PetroForm(hintText: "Masukkan Merk", controller: leftBrand),
                const SizedBox(height: 8),
                const ConformityCard(),

                const SizedBox(height: 32),

                const Text("Kabin"),
                PetroForm(hintText: "Masukkan Ukuran", controller: cabinSize),
                const SizedBox(height: 8),
                PetroForm(hintText: "Masukkan Merk", controller: cabinBrand),
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
