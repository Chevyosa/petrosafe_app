import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_history_data.dart';

class HistoryContent extends StatelessWidget {
  const HistoryContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Riwayat Inspeksi", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    "Data inspeksi di bawah adalah data keseluruhan inspeksi. Scroll untuk melihat data yang lainnya. Untuk rekap, klik tombol ekspor di bawah.",
                    style: TextStyle(fontSize: 16),
                  ),

                  SizedBox(height: 16),

                  HistoryDataCard(),
                ],
              ),
            ),
          ),

          Spacer(),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () => {},
                  child: Text(
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
    );
  }
}
