import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/cards/card_history_data.dart';
import 'package:petrosafe_app/widgets/history/content_history.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    const rightArrow = Icon(CupertinoIcons.chevron_right, color: Colors.white);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Selamat Pagi",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "Selamat Beraktifitas",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 24),

              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      "lib/assets/images/userphoto.jpeg",
                    ),
                    radius: 50,
                  ),

                  SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Riyanda Azis Febrian",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "Inspektor Kendaraan",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryContent()),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Lihat Seluruh Riwayat Inspeksi",
                        style: TextStyle(color: Colors.white),
                      ),
                      Spacer(),
                      rightArrow,
                    ],
                  ),
                ),
              ),

              SizedBox(height: 32),

              Text("Riwayat Inspeksi Terakhir", style: TextStyle(fontSize: 16)),

              SizedBox(height: 16),

              HistoryDataCard(),
            ],
          ),
        ),
      ),
    );
  }
}
