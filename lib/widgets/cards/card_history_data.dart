import 'package:flutter/material.dart';

class HistoryDataCard extends StatelessWidget {
  final String urlPhoto;
  final String inspector;
  final String platenumber;
  final String capacity;
  final String category;
  final String date;

  const HistoryDataCard({
    super.key,
    required this.urlPhoto,
    required this.platenumber,
    required this.inspector,
    required this.capacity,
    required this.category,
    required this.date,
  });

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
            CircleAvatar(backgroundImage: AssetImage(urlPhoto), radius: 32),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  inspector,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(platenumber),
                Row(
                  children: <Widget>[
                    Text("$capacity L"),
                    SizedBox(width: 4),
                    Text("|"),
                    SizedBox(width: 4),
                    Text("Kategori $category"),
                  ],
                ),
              ],
            ),
            Spacer(),
            Column(
              children: <Widget>[Text(date, style: TextStyle(fontSize: 12))],
            ),
          ],
        ),
      ),
    );
  }
}
