import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:petrosafe_app/pages/page_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
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

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Berhasil keluar dari akun")));
  }

  @override
  Widget build(BuildContext context) {
    const logoutIcon = Icon(FeatherIcons.logOut, color: Colors.white);
    const rightArrow = Icon(CupertinoIcons.chevron_right, color: Colors.white);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
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
                        style: const TextStyle(
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

              SizedBox(height: 32),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                ),
                onPressed: () => logout(context),
                child: Padding(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          logoutIcon,
                          SizedBox(width: 10),
                          Text(
                            "Keluar",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      Spacer(),
                      rightArrow,
                    ],
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
