import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_conformity.dart';

class SpillkitContent extends StatelessWidget {
  const SpillkitContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cek Spill Kit", style: TextStyle(fontSize: 20)),
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
                const Text("Sekop Lipat"),
                const ConformityCard(),

                const SizedBox(height: 32),

                const Text("Absorbent Pad"),
                const ConformityCard(),

                const SizedBox(height: 32),

                const Text("Plastik / Terpal 4x4 Meter"),
                const ConformityCard(),

                const SizedBox(height: 32),

                const Text("Sarung Tangan Tahan Minyak"),
                const ConformityCard(),

                const SizedBox(height: 32),

                const Text("Safety Glass"),
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
