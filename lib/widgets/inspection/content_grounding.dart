import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_conformity.dart';
import 'package:petrosafe_app/widgets/forms/form_inspection.dart';

class GroundingContent extends StatefulWidget {
  const GroundingContent({super.key});

  @override
  State<GroundingContent> createState() => _GroundingContentState();
}

class _GroundingContentState extends State<GroundingContent> {
  final lengthController = TextEditingController();
  final notesController = TextEditingController();

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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text("Grounding"),
              PetroForm(
                hintText: "Masukkan Panjang Grounding",
                controller: lengthController,
              ),
              const SizedBox(height: 8),
              const ConformityCard(),

              const SizedBox(height: 32),

              const Text("Arde"),
              PetroForm(
                hintText: "Masukkan Keterangan Arde",
                controller: notesController,
              ),
              const SizedBox(height: 8),
              const ConformityCard(),

              Spacer(),

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
    );
  }
}
