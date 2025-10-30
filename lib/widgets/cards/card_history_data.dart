import 'package:flutter/material.dart';

class HistoryDataCard extends StatelessWidget {
  const HistoryDataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage("lib/assets/images/Truk.png"),
              radius: 32,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Toni Artanto",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text("BP 9987 HJ"),
                Row(
                  children: <Widget>[
                    Text("8000L"),
                    SizedBox(width: 4),
                    Text("|"),
                    SizedBox(width: 4),
                    Text("Kategori 8"),
                  ],
                ),
              ],
            ),
            Spacer(),
            Column(
              children: <Widget>[
                Text("24 Oktober 2025", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
