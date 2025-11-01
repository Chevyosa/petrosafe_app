import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:petrosafe_app/pages/page_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('user_name');
    await prefs.remove('user_position');
    await prefs.remove('user_photo');

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
                  const CircleAvatar(
                    backgroundImage: AssetImage(
                      "lib/assets/images/userphoto.jpeg",
                    ),
                    radius: 50,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
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

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                ),
                onPressed: () => logout(context),
                child: Row(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        logoutIcon,
                        SizedBox(width: 10),
                        Text("Keluar", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Spacer(),
                    rightArrow,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
