import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    const logoutIcon = Icon(FeatherIcons.logOut, color: Colors.white);
    const rightArrow = Icon(CupertinoIcons.chevron_right, color: Colors.white);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
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

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                ),
                onPressed: () => {},
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
