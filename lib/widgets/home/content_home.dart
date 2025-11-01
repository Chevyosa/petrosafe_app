import 'package:flutter/material.dart';
import 'package:petrosafe_app/widgets/buttons/buttons_inspection.dart';
import 'package:petrosafe_app/widgets/cards/card_history_data.dart';
import 'package:petrosafe_app/widgets/history/content_history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String userName = '';
  String userPosition = '';
  String userPhoto = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'Pengguna';
      userPosition = prefs.getString('user_position') ?? '-';
      userPhoto = prefs.getString('user_photo') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> historyData = [
      {
        "urlPhoto": "lib/assets/images/Truk.png",
        "platenumber": "BP 8897 HJ",
        "inspector": "Toni",
        "capacity": "8000",
        "category": "8",
        "date": "24 Oktober 2025",
      },
      {
        "urlPhoto": "lib/assets/images/Truk.png",
        "platenumber": "BP 1172 FA",
        "inspector": "Rudi",
        "capacity": "5000",
        "category": "5",
        "date": "22 Oktober 2025",
      },
      {
        "urlPhoto": "lib/assets/images/Truk.png",
        "platenumber": "BP 2278 DJ",
        "inspector": "Agus",
        "capacity": "6000",
        "category": "6",
        "date": "18 Oktober 2025",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Selamat Pagi",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Row(
                children: <Widget>[
                  Text(
                    "Selamat ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "Beraktifitas",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: userPhoto.isNotEmpty
                        ? NetworkImage(userPhoto)
                        : const AssetImage("lib/assets/images/userphoto.jpeg")
                              as ImageProvider,
                    radius: 50,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        userPosition.isNotEmpty
                            ? userPosition
                            : "Inspektor Kendaraan",
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              PetroButton(
                title: "Lihat Seluruh Riwayat Inspeksi",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryContent()),
                ),
              ),

              const SizedBox(height: 32),
              const Text(
                "Riwayat Inspeksi Terakhir",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              for (var item in historyData)
                HistoryDataCard(
                  urlPhoto: item["urlPhoto"]!,
                  platenumber: item["platenumber"]!,
                  inspector: item["inspector"]!,
                  capacity: item["capacity"]!,
                  category: item["category"]!,
                  date: item["date"]!,
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
