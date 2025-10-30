import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_conformity.dart';

class P3KContent extends StatelessWidget {
  const P3KContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cek Perlengkapan P3K",
          style: TextStyle(fontSize: 20),
        ),
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
                const Text("Antiseptik"),
                const SizedBox(height: 8),
                const ConformityCard(),

                const SizedBox(height: 32),

                const Text("Perban"),
                const SizedBox(height: 8),
                const ConformityCard(),

                const SizedBox(height: 32),

                const Text("Plester"),
                const SizedBox(height: 8),
                const ConformityCard(),

                const SizedBox(height: 32),

                const Text("Salep Luka Bakar"),
                const SizedBox(height: 8),
                const ConformityCard(),

                const SizedBox(height: 32),

                const Text("Obat Cuci Mata"),
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
